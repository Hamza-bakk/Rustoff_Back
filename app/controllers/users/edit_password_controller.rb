class Users::EditPasswordController < ApplicationController
  def update
    # Utilise params[:user][:current_password], params[:user][:new_password], params[:user][:password_confirmation]
    # pour traiter les données du formulaire
    current_password = params[:user][:current_password]
    new_password = params[:user][:new_password]
    password_confirmation = params[:user][:password_confirmation]

    if current_password_valid?(current_password) && new_password_valid?(new_password, password_confirmation)
      # Met à jour le mot de passe de l'utilisateur
      current_user.update(password: new_password)
      sign_in(current_user, bypass: true) # Signe l'utilisateur après la mise à jour du mot de passe
      render json: { success: true, message: 'Mot de passe mis à jour avec succès' }
    else
      render json: { success: false, message: 'Échec de la mise à jour du mot de passe', errors: { password: 'Mot de passe incorrect' } }
    end
  end

  private

  def current_password_valid?(password)
    return false unless user_signed_in?
    current_user.valid_password?(password)
  end

  def new_password_valid?(new_password, password_confirmation)
    new_password == password_confirmation
  end
end
