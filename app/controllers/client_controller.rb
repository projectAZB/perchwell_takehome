class ClientController < ApplicationController
    def index
        @clients = Client.page(params[:page]).per(params[:per_page] || 10)

        render json: {
            status: "success",
            clients: clients_response(@clients),
            total_pages: @clients.total_pages,
            current_page: @clients.current_page,
        }
    end

    private

    def clients_response(clients)
        return clients.map do |client| {
            id: client.id,
            name: client.name,
            buildings_count: client.buildings.count,
        }
    end

end
