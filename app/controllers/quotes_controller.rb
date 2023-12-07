class QuotesController < ApplicationController
    before_action :set_quote, only: [:show, :mark, :destroy]  # Avant certaines actions, exécutez la méthode `set_quote` pour configurer l'objet @quote.
    #before_action :authenticate_user!  # Avant chaque action, assurez-vous que l'utilisateur est authentifié.
  
    def new
      @quote = Quote.new  # Créez une nouvelle instance de Quote pour le formulaire de création.
    end
  
    def create
      @quote = Quote.new(quote_params)
  
      if @quote.save
        render json: @quote, status: :created
      else
        render json: { errors: @quote.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def mark
      @quote.update(processed: params[:checked])  # Mettez à jour l'état du devis en fonction de la valeur de `params[:checked]`.
      redirect_to dashboard_quotes_path, notice: 'État du devis mis à jour avec succès.'  # Redirigez vers le tableau de bord avec un message de succès.
    end
  
    def reprocess
      quote = Quote.find(params[:id])  # Recherchez le devis par son identifiant.
      quote.update(processed: false)  # Réinitialisez l'état du devis à non traité.
      redirect_to dashboard_quotes_path, notice: 'État du devis mis à jour avec succès.'  # Redirigez vers le tableau de bord avec un message de succès.
    end
  
    def destroy
      @quote = Quote.find(params[:id])  # Recherchez le devis par son identifiant.
      @quote.destroy  # Supprimez le devis.
      redirect_to dashboard_quotes_path, notice: 'Devis supprimé avec succès.'  # Redirigez vers le tableau de bord avec un message de succès.
    end
  
    def show
      # Cette action est généralement utilisée pour afficher les détails d'un devis, mais elle semble être vide dans votre exemple.
    end
  
    private
  
    def set_quote
      @quote = Quote.find(params[:id])  # Recherchez un devis par son identifiant pour les actions spécifiques où cela est nécessaire.
    end
  
    def quote_params
      params.require(:quote).permit(:first_name, :last_name, :email, :description, :category)  # Autorisez les paramètres spécifiques du formulaire pour la création d'un devis.
    end
  end