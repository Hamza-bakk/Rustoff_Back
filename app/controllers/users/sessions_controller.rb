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
    # Assurez-vous que le token est récupéré correctement depuis les headers
    token = request.headers['Authorization']&.split('Bearer ')&.last
  
    # Si le token est présent, décodez-le pour obtenir l'ID de l'utilisateur
    if token.present?
      # Utilisez la même clé pour le décodage que celle utilisée pour l'encodage
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
      user_id = decoded_token[0]['id']
  
      # Si l'utilisateur est actuellement connecté, déconnectez-le
      if user_signed_in? && current_user.id == user_id.to_i
        sign_out(current_user)
        render json: { message: 'You are logged out.' }, status: :ok
      else
        render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
      end
    else
      render json: { message: 'No token provided.' }, status: :unauthorized
    end
  rescue JWT::DecodeError => e
    render json: { message: "Failed to decode token: #{e.message}" }, status: :unauthorized
  end


  private

  def respond_with(_resource, _opts = {})
    cart_id = resource.cart&.id
    render json: {
      message: 'You are logged in.',
      user: current_user,
      cartId: cart_id
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
