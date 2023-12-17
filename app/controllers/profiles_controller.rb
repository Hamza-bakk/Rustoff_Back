class ProfilesController < ApplicationController
  def show
    @user = current_user
    restrict_access unless current_user == @user
  end

  def edit
    @user = current_user
  end

  def destroy
    @user = User.find(params[:id])

    if @user
      Rails.logger.info("Trying to delete user with ID: #{@user.id}")

      if @user.destroy
        Rails.logger.info("User deleted successfully.")
        render json: { message: "Compte supprimé avec succès." }, status: :ok
      else
        Rails.logger.error("Error deleting user: " + @user.errors.full_messages.join(', '))
        render json: { error: "Erreur lors de la suppression du compte utilisateur." }, status: :unprocessable_entity
      end
    else
      Rails.logger.error("User not found.")
      render json: { error: "Utilisateur non trouvé." }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(profile_params)
      render json: { message: "Profil mis à jour avec succès." }, status: :ok
    else
      render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
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
