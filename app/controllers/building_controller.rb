class BuildingController < ApplicationController
    before_action :set_building, only: [:update,  :show]

    def create
        client = Client.find_by!(name: building_params[:client_name])
        @building = Building.new(building_params.except(:client_name)).merge(client: client)

        if @building.save
            render json: { status: "success", building: building_response(@building) }, status: :created
        else
            render json: { status: "error", errors: @building.errors.full_messages }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: 'Client not found' }, status: :not_found
    end

    def update
        if @building.update(building_params.except(:client_name))
            render json: { status: "success", building: building_response(@building) }
        else
            render json: { status: "error", errors: @building.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        render json: { status: "success", building: building_response(@building) }
    end

    def index
        @buildings = Build.include(:client).page(params[:page]).per(params[:per_page] || 10)
        render json: {
            status: "success",
            buildings: @buildings.map { |building| building_response(building) },
            total_pages: @buildings.total_pages,
            current_page: @buildings.current_page,
        }
    end

    private 

    def set_building
        @building  = Building.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Building Not Found" }, status: :not_found
    end

    def building_params
        params.require(:building).permit(:client_name, :address, :state, :zip_code, custom_field_values: {})
    end

    def building_response(building)
        response = {
            id: building.id,
            client_name: building.client_name,
            address: building.address,
            state: building.state,
            zip_code: building.zip_code,
        }
        building.custom_field_values.each do |field_id, value|
            custom_field = CustomField.find(field_id)
            response[custom_field.name.underscore] = value
        end

        return response
    end

end
