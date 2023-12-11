class ItemsController < ApplicationController
  
  #La def destroy et create et edit concerne le coté admin qui peut avoir la gestion des items 
  def destroy
    @item.destroy
    render json: @items
  end
  
  # GET /items or /items.json
  def index
    @items = Item.all
    render json: @items
  end
  
  # GET /items/1 or /items/1.json
  def show
    @item = Item.find(params[:id])
    render json: @item
  end
  
  
  # GET /items/new
  def new
    @item = Item.new
  end
  
  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @categories = Item.distinct.pluck(:category)
  end
  
  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
  
    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end
  
  # PATCH/PUT /items/1 or /items/1.json
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to dashboard_products_path, notice: "Article mis à jour avec succès."
    else
      render :edit
    end
  end
  
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:title, :description, :category, :price, :image_url, :alt)
  end
end
