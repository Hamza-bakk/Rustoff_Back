class CheckoutController < ApplicationController
  
    def create
      
      #Cette partie permet de créer le paiement stripe a travers l'API
      
      @total = params[:total].to_d
      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [
          {
            price_data: {
              currency: 'eur',
              unit_amount: (@total*100).to_i,
              product_data: {
                name: 'Rails Stripe Checkout',
              },
            },
            quantity: 1
          },
        ],
        mode: 'payment',
        success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: checkout_cancel_url
      )
      redirect_to @session.url, allow_other_host: true
    end
    
    def success
    
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
      
      # Par exemple, si vous avez un modèle de commande nommé Order :
      @order = Order.new(
        user_id: current_user.id, # Assurez-vous que l'utilisateur est connecté
        total_price: @total, # Remplacez cela par le montant total de la commande
        # Autres attributs de commande que vous souhaitez enregistrer
      )
      
      if @order.save

        CartItem.where(cart_id: current_user.cart.id).each do |cart_item|
          @order.order_items.create(
            item_id: cart_item.item_id,
            quantity: cart_item.quantity,
            unit_price: cart_item.item.price 
          )
        end
        
        
        current_user.cart.cart_items.destroy_all
        
        redirect_to order_path(@order)
      else

        flash[:error] = 'La commande n\'a pas pu être enregistrée.'
        redirect_to root_path
      end
    end
    
    def cancel
    end
  end