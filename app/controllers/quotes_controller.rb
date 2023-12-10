class QuotesController < ApplicationController
    before_action :set_quote, only: [:show, :mark, :destroy]  # Avant certaines actions, exécutez la méthode `set_quote` pour configurer l'objet @quote.
    #before_action :authenticate_user!  # Avant chaque action, assurez-vous que l'utilisateur est authentifié.
  
    def index
      @quotes = Quote.all
      render json: @quotes
    end
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
      @quote.update(processed: params[:checked])
    
      render json: @quote, status: :ok
    end
  
    def reprocess
      @quote.update(processed: false)
      render json: @quote, status: :ok
    end
  
    def destroy
      @quote.destroy
      render json: { message: 'Devis supprimé avec succès.' }, status: :ok
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