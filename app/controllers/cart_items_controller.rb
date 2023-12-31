class CartItemsController < ApplicationController
    
    # GET /cart_items or /cart_items.json
    def index
      @cart_items = CartItem.all
    end
    
    # GET /cart_items/1 or /cart_items/1.json
    def show
    end
    
    # GET /cart_items/new
    def new
      @cart_item = CartItem.new
    end
    
    # GET /cart_items/1/edit
    def edit
    end
    
    # POST /cart_items or /cart_items.json
    def create
      @cart_item = CartItem.new(cart_item_params)
      
      respond_to do |format|
        if @cart_item.save
          format.html { redirect_to cart_path(current_user.cart), notice: "L'article du panier a été créé avec succès." }
          format.json { render :show, status: :created, location: current_user.cart }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        end
      end
    end
    
    # PATCH/PUT /cart_items/1 or /cart_items/1.json
    def update
      
      respond_to do |format|
        if @cart_item.update!(cart_item_params)
          format.html { redirect_to cart_url(current_user.cart), notice: "Le panier a été mis à jour avec succès."}           
          format.json { render :show, status: :ok, location: current_user.cart }
        end
      end
    end
    # DELETE /cart_items/1 or /cart_items/1.json
    def destroy
      @cart_item.destroy
      
      respond_to do |format|
        format.html { redirect_to cart_items_url, notice: "L'article du panier a été détruit avec succès." }
        format.json { head :no_content }
      end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def cart_item_params
      params.require(:cart_item).permit(:cart_id, :item_id, :quantity)
    end
  end