require "rails_helper"

RSpec.describe ClientsController, type: :controller do
  describe "GET #index" do
    before do
      # Create 15 clients for testing pagination
      15.times { |i| create(:client, name: "Client #{i+1}") }
    end

    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns clients in JSON format" do
      get :index
      json_response = JSON.parse(response.body)
      
      expect(json_response).to have_key("clients")
      expect(json_response["clients"]).to be_an(Array)
      expect(json_response["clients"].length).to eq(10) # Default per_page is 10
    end

    it "includes pagination information" do
      get :index
      json_response = JSON.parse(response.body)
      
      expect(json_response).to include("total_pages", "current_page", "total_count")
      expect(json_response["total_pages"]).to eq(2)
      expect(json_response["current_page"]).to eq(1)
      expect(json_response["total_count"]).to eq(15)
    end

    it "paginates correctly" do
      get :index, params: { page: 2 }
      json_response = JSON.parse(response.body)
      
      expect(json_response["clients"].length).to eq(5) # 5 clients on the second page
      expect(json_response["current_page"]).to eq(2)
    end

    it "returns client attributes correctly" do
      get :index
      json_response = JSON.parse(response.body)
      client = json_response["clients"].first
      
      expect(client).to include("id", "name")
      expect(client).not_to include("created_at", "updated_at")
    end
  end
end
