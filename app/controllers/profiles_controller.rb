class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = current_user
    restrict_access unless current_user == @user
  end

  def edit
    @user = current_user
  end

  def destroy
    @user = current_user
    Rails.logger.info("Trying to delete user with ID: #{@user.id}")
    
    if @user.destroy
      # Ajoutez ici la logique de redirection après la suppression du profil.
      Rails.logger.info("User deleted successfully.")
    else
      Rails.logger.error("Error deleting user: " + @user.errors.full_messages.join(', '))
    end
  end
  

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profil mis à jour avec succès."
    else
      render :edit
    end
  end

  private

  def restrict_access
    flash[:alert] = "Accès refusé. Vous ne pouvez pas accéder au profil d'un autre utilisateur."
    redirect_to root_path
  end

  def profile_params
    params.require(:user).permit(:email)
  end
end
