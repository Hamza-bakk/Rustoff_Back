class CheckoutController < ApplicationController
  def create
    puts "Params received: #{params.inspect}"
    
    # Cette partie permet de créer le paiement stripe à travers l'API
    @total = params[:total].to_d
    puts "Current User ID: #{current_user&.id}"
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: (@total * 100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout',
            },
          },
          quantity: 1
        },
      ],
      mode: 'payment',
      success_url: "http://localhost:5173/order",
    )
    
    # Stockez @session dans la session pour y accéder dans d'autres actions
    session[:checkout_session] = @session.id

    order_details = {
      total: @total,
      cart_items: params[:cartItems]
    }

    session[:order_details] = order_details

    render json: { id: @session.id, sessionUrl: @session.url }
    puts "Session url après : #{@session.url}"
  end
  
 def order
  if session[:checkout_session].present?
    # Accédez à @session en utilisant l'ID stocké dans la session
    @session = Stripe::Checkout::Session.retrieve(session[:checkout_session])
    puts "Current User avant la session include: #{current_user&.id}"

    if @session.url.include?("http://localhost:5173/order")
      puts "Current User ID: #{current_user&.id}"

      order = Order.new(total_price: session[:order_details][:total])

      session[:order_details][:cart_items].each do |item_params|
        item = Item.find(item_params["id"])
        quantity = item_params["quantity"].to_i
        order_item = order.order_items.build(
          item: item,
          quantity: quantity,
          unit_price: item.price
        )
        order_item.save # Enregistrez l'order_item dans la base de données
      end

      # Enregistrez la commande dans la base de données
      if order.save
        puts "Order created successfully after successful payment."
      else
        # Gérez l'erreur si la sauvegarde de la commande échoue
        puts "Error: Order creation failed. Errors: #{order.errors.full_messages.join(', ')}"
      end
    end

    # Supprimez l'ID de la session une fois qu'il a été utilisé
    session.delete(:checkout_session)
    session.delete(:order_details)
  end

  render json: { order_details: session[:order_details] }
end

end
