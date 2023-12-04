class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show update destroy ]
  before_action :user_is_current_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create]

  # GET /properties
  def index
    @properties = Property.all

    render json: @properties
  end

  # GET /properties/1
  def show
    render json: @property
  end

  # POST /properties
 # app/controllers/properties_controller.rb

def create
  # Check if an image file was provided in the request
  if params[:image].present?
    # Upload the image to Cloudinary
    image = Cloudinary::Uploader.upload(params[:image])

    # Create a new Property instance with the image URL
    @property = Property.new(image: image['url'])
  else
    # Handle the case where no image was provided
    @property = Property.new
  end

  # Assuming you have authentication set up to get the current user, uncomment this line
  # puts "Current user: #{current_user.inspect}"

  # Set other property attributes based on your form data
  @property.title = params[:property][:title]
  @property.price = params[:property][:price]
  @property.description = params[:property][:description]
  @property.user_id = params[:property][:user_id]

  if @property.save
    render json: @property, status: :created, location: @property
  else
    render json: @property.errors, status: :unprocessable_entity
  end
end



  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
      render json: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:title, :price, :description, :user_id, :image)
    end

    def user_is_current_user
      unless current_user == @property.user
        render json: { error: "Accès non autorisé" }, status: :unauthorized
      end
    end
end
