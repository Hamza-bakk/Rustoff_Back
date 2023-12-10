class DashboardController < ApplicationController
  
    def user_stats
      render json: { num_users: User.count }
    end
  
    def quote_stats
      render json: { num_quotes: Quote.count }
    end


    def create
      @item = Item.new(item_params)
      if @item.save
        redirect_to dashboard_store_path, notice: "Le produit a été ajouté avec succès."
      else
        render 'store'
      end
    end
    
    private
    
    def item_params
      params.require(:item).permit(:title, :description, :price, :image_url, :alt, :category)
    end
  end