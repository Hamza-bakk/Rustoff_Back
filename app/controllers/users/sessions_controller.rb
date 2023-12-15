class Users::SessionsController < Devise::SessionsController

  respond_to :json

  def create
    super do |resource|
      if resource.persisted?
        # Assurez-vous que le jeton est généré ici
        payload = { id: resource.id }
        token = JWT.encode(payload, Rails.application.credentials.secret_key_base)
        resource.token = token
        resource.save
  
        # Ajoutez ces lignes pour le débogage
        puts "Cart ID: #{resource.cart&.id}"
        puts "Token: #{resource.token}"
        puts "User ID: #{resource.id}"
        puts "Token received: #{token}"
      end
    end
  end

  def destroy
    log_out
    render json: { message: 'You are logged out.' }, status: :ok
  end


  private

   def log_out
    current_user&.update(token: nil) # Assurez-vous de mettre à jour correctement le champ du token
    sign_out(current_user)
  end

  def respond_with(_resource, _opts = {})
    cart_id = resource.cart&.id
    isAdmin = resource.admin
    puts isAdmin
    render json: {
      message: 'You are logged in.',
      user: current_user,
      cartId: cart_id,
      isAdmin: isAdmin,
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
  end
end
