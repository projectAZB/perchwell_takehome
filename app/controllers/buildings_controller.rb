class BuildingsController < ApplicationController
  before_action :set_client
  before_action :set_building, only: [:show, :update]

  def index
    @buildings = @client.buildings.page(params[:page]).per(10)
    render json: {
      buildings: @buildings.as_json(except: [:created_at, :updated_at]),
      total_pages: @buildings.total_pages,
      current_page: @buildings.current_page,
      total_count: @buildings.total_count
    }
  end

  def show
    render json: @building
  end

  def create
    @building = @client.buildings.new(building_params)

    if @building.save
      render json: @building, status: :created
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end

  def update
    if @building.update(building_params)
      render json: @building
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_building
    @building = @client.buildings.find(params[:id])
  end

  def building_params
    params.require(:building).permit(:address, :state, :zip_code, custom_field_values: {})
  end
end
