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
    
    render json: { id: @session.id, sessionUrl: @session.url }
    puts "Session url aprés : #{@session.url}"
  end
  
    
    def success
    puts "Current User ID: #{current_user&.id}"

      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
      
      @order = Order.new(
        user_id: current_user.id, # Assurez-vous que l'utilisateur est connecté
        total_price: @total, 
      )
      
      if @order.save
        # Enregistrez les détails de la commande (par exemple, les articles commandés) ici
        # Assurez-vous d'ajuster cette logique en fonction de votre modèle de commande et de panier
        
        # Exemple fictif pour ajouter un article à la commande (à adapter à votre modèle) :
        CartItem.where(cart_id: current_user.cart.id).each do |cart_item|
          @order.order_items.create(
            item_id: cart_item.item_id,
            quantity: cart_item.quantity,
            unit_price: cart_item.item.price # Utilisez l'attribut unit_price pour stocker le prix de l'article
          )
        end
        
        
        # Videz le panier de l'utilisateur après avoir enregistré la commande
        current_user.cart.cart_items.destroy_all
        
        # Redirigez l'utilisateur vers une page de confirmation de commande
        redirect_to order_path(@order)
      else
        # La sauvegarde de la commande a échoué, gérez l'erreur en conséquence
        flash[:error] = 'La commande n\'a pas pu être enregistrée.'
        render json: { success: true } # Au lieu de rediriger, renvoyez une réponse JSON au frontend

      end
    end
    
    def cancel
    end
  end