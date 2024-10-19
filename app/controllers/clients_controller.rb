class ClientsController < ApplicationController
  def index
    @clients = Client.page(params[:page]).per(10)
    render json: {
      clients: @clients.as_json(except: [:created_at, :updated_at]),
      total_pages: @clients.total_pages,
      current_page: @clients.current_page,
      total_count: @clients.total_count
    }
  end
end
