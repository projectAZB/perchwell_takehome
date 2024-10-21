class BuildingsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :set_client
  before_action :set_building, only: [:show, :update, :destroy]

  def index
    @buildings = @client.buildings.page(params[:page]).per(10)
    custom_fields = @client.custom_fields.pluck(:id, :name).to_h

    buildings_with_custom_fields = @buildings.map do |building|
      custom_field_values = building.custom_field_values.transform_keys do |custom_field_id|
        custom_fields[custom_field_id.to_i] || custom_field_id
      end
      
      building.as_json.merge(custom_field_values: custom_field_values)
    end

    render json: {
      client_name: @client.name,
      buildings: buildings_with_custom_fields,
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

  def destroy
    if @building.destroy
      render json: { message: 'Building successfully deleted' }, status: :ok
    else
      render json: { errors: @building.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_building
    @building = @client.buildings.find(params[:id])
  end

  def record_not_found
    render json: { error: 'Building not found' }, status: :not_found
  end

  def building_params
    params.require(:building).permit(:address, :state, :zip_code, custom_field_values: {})
  end
end
