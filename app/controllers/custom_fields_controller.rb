class CustomFieldsController < ApplicationController
  before_action :set_client
  before_action :set_custom_field, only: [:show, :update]

  def index
    @custom_fields = @client.custom_fields
    render json: @custom_fields
  end

  def show
    render json: @custom_field
  end

  def create
    @custom_field = @client.custom_fields.new(custom_field_params)

    if @custom_field.save
      render json: @custom_field, status: :created
    else
      render json: @custom_field.errors, status: :unprocessable_entity
    end
  end

  def update
    if @custom_field.update(custom_field_params)
      render json: @custom_field
    else
      render json: @custom_field.errors, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_custom_field
    @custom_field = @client.custom_fields.find(params[:id])
  end

  def custom_field_params
    params.require(:custom_field).permit(:name, :value_type, :value)
  end
end
