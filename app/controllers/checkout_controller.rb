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
  end

  def order
    order_details = params["checkout"]

    ActiveRecord::Base.transaction do
      # Créer la commande
      order = Order.new(
        user_id: order_details["userId"],  # Ajout de l'utilisateur associé à la commande
        total_price: order_details["total"]
      )

      if order.save
        puts "Order enregistrée avec succès! Order ID: #{order.id}"

        # Créer des order_items pour chaque élément du panier
        order_details["cartItems"].each do |cart_item|
          order_item = OrderItem.new(
            order: order,
            item_id: cart_item["id"],
            quantity: cart_item["quantity"],
            unit_price: cart_item["price"].to_d
          )

          if order_item.save
            puts "OrderItem enregistré avec succès!"
          else
            puts "Erreur lors de l'enregistrement de l'OrderItem: #{order_item.errors.full_messages.join(', ')}"
          end
        end

        # Réinitialiser les détails de la commande de la session
        session[:order_details] = nil

        render json: { success: true, order_id: order.id }
      else
        puts "Erreur lors de l'enregistrement de l'Order: #{order.errors.full_messages.join(', ')}"
        render json: { success: false, error: "Erreur lors de l'enregistrement de la commande" }
      end
    end
  end
end
