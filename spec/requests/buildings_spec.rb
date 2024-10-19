require "rails_helper"

RSpec.describe BuildingsController, type: :controller do
  let(:client) { create(:client) }
  let(:valid_attributes) { 
    { address: "123 Test St", state: "CA", zip_code: "12345", custom_field_values: {} }
  }
  let(:invalid_attributes) { 
    { address: "", state: "California", zip_code: "invalid" }
  }

  describe "GET #index" do
    it "returns a successful response" do
      get :index, params: { client_id: client.id }
      expect(response).to be_successful
    end

    it "returns paginated buildings" do
      create_list(:building, 15, client: client)
      get :index, params: { client_id: client.id }
      json_response = JSON.parse(response.body)
      
      expect(json_response["buildings"].length).to eq(10)
      expect(json_response["total_pages"]).to eq(2)
      expect(json_response["current_page"]).to eq(1)
      expect(json_response["total_count"]).to eq(15)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      building = create(:building, client: client)
      get :show, params: { client_id: client.id, id: building.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Building" do
        expect {
          post :create, params: { client_id: client.id, building: valid_attributes }
        }.to change(Building, :count).by(1)
      end

      it "renders a JSON response with the new building" do
        post :create, params: { client_id: client.id, building: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        post :create, params: { client_id: client.id, building: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PUT #update" do
    let(:building) { create(:building, client: client) }

    context "with valid params" do
      let(:new_attributes) { { address: "456 New St" } }

      it "updates the requested building" do
        put :update, params: { client_id: client.id, id: building.id, building: new_attributes }
        building.reload
        expect(building.address).to eq("456 New St")
      end

      it "renders a JSON response with the building" do
        put :update, params: { client_id: client.id, id: building.id, building: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        put :update, params: { client_id: client.id, id: building.id, building: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end
end
