class CakesController < ApplicationController
  before_action :authorized, except: [:get_items, :search]
  def index
    @cakes = CakeService.getAllCakes
  end

  def new
    @cake = Cake.new
  end

  def create
    @cake = Cake.new(cake_params)
    @is_cake_create = CakeService.createCake(@cake)
    if @is_cake_create && @cake.valid?
      render json: {}, status: :created
    else
      render json: @is_cake_create.errors, status: :unprocessable_entity
    end
  end
 
  def edit
    @cake = CakeService.getCakeByID(params[:id])
  end


  def update
    @cake = CakeService.getCakeByID(params[:id])
    @is_cake_update  = CakeService.updateCake(@cake,cake_params)
    if  @is_cake_update
      flash[:success] = "Cake Updated successfully" 
      redirect_to @cake
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cake = CakeService.getCakeByID(params[:id])
    @is_cake_destroy  = CakeService.destroy(@cake)
    if  @is_cake_destroy
      redirect_to @cake
    end
  end
  
  def import
    @cakes = Cake.all
    if params[:file].present?
    @cakes = Cake.import(params[:file], logged_in_user.id)
    render json: {}, status: :created
    else
      render json: @cakes.errors, status: :unprocessable_entity
    end
  end

  def get_items
    @cakes, @type_name = CakeService.getItems
    base_url = "#{request.protocol}#{request.host_with_port}"
    if @cakes.present?
      cake_data = @cakes.map do |cake|
        image_url = "#{base_url}#{rails_blob_path(cake.image, only_path: true)}"
        cake.attributes.merge(image_url: image_url)
      end
      render json: { items: cake_data, type_names: @type_name }, status: :ok
    else
      render json: { items: [], type_names: [] }, status: :ok
    end
  end

  def search
    @cakes, @type_name = CakeService.search(params[:search])
    base_url = "#{request.protocol}#{request.host_with_port}"
    if @cakes.present?
      cake_data = @cakes.map do |cake|
        image_url = "#{base_url}#{rails_blob_path(cake.image, only_path: true)}"
        cake.attributes.merge(image_url: image_url)
      end
      render json: { items: cake_data, type_names: @type_name }, status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private
  def cake_params
    params.permit(:image, :name, :description, :price, :type_name).merge(user_id: logged_in_user.id)
  end

end
