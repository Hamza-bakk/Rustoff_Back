class Users::EditPasswordController < ApplicationController
  def update
    @user = User.find(params[:id]) # Utilisation de User.find pour récupérer l'utilisateur par l'ID
    if @user
      current_password = params[:user][:current_password]
      new_password = params[:user][:new_password]
      password_confirmation = params[:user][:password_confirmation]

      Rails.logger.debug("Current Password: #{current_password}")
      Rails.logger.debug("New Password: #{new_password}")
      Rails.logger.debug("Password Confirmation: #{password_confirmation}")

      if @user.valid_password?(current_password) && new_password == password_confirmation
        # Met à jour le mot de passe de l'utilisateur
        @user.password = new_password
        @user.password_confirmation = password_confirmation

        if @user.save
          Rails.logger.info("Password updated successfully for user #{@user.id}")
          sign_in(@user, bypass: true) # Signe l'utilisateur après la mise à jour du mot de passe
          render json: { success: true, message: 'Mot de passe mis à jour avec succès' }
        else
          Rails.logger.error("Failed to save the updated password for user #{@user.id}")
          render json: { success: false, message: 'Échec de la mise à jour du mot de passe', errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        Rails.logger.error("Failed to save the updated password for user #{@user.id}")
        render json: { success: false, message: 'Échec de la mise à jour du mot de passe', errors: { password: 'Mot de passe incorrect' } }, status: :unprocessable_entity
      end
    else
      Rails.logger.error("Invalid user or user is not the current user")
      render json: { success: false, message: 'Échec de la mise à jour du mot de passe', errors: { user: 'Utilisateur invalide ou n\'est pas l\'utilisateur actuel' } }, status: :unprocessable_entity
    end
  end

end
