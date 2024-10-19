require "rails_helper"

RSpec.describe CustomFieldsController, type: :controller do
  let(:client) { create(:client) }
  let(:valid_attributes) {
    { name: "Test Field", value_type: "text" }
  }
  let(:invalid_attributes) {
    { name: "", value_type: "text" }
  }
  let(:valid_enum_attributes) {
    { name: "Enum Field", value_type: "enum_type", value: "Option1, Option2, Option3" }
  }

  describe "GET #index" do
    it "returns a successful response" do
      get :index, params: { client_id: client.id }
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      custom_field = create(:custom_field, client: client)
      get :show, params: { client_id: client.id, id: custom_field.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new CustomField" do
        expect {
          post :create, params: { client_id: client.id, custom_field: valid_attributes }
        }.to change(CustomField, :count).by(1)
      end

      it "renders a JSON response with the new custom_field" do
        post :create, params: { client_id: client.id, custom_field: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "creates a new enum CustomField" do
        post :create, params: { client_id: client.id, custom_field: valid_enum_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["value_type"]).to eq("enum_type")
        expect(JSON.parse(response.body)["value"]).to eq("Option1, Option2, Option3")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        post :create, params: { client_id: client.id, custom_field: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PUT #update" do
    let(:custom_field) { create(:custom_field, client: client) }

    context "with valid params" do
      let(:new_attributes) { { name: "Updated Field" } }

      it "updates the requested custom_field" do
        put :update, params: { client_id: client.id, id: custom_field.id, custom_field: new_attributes }
        custom_field.reload
        expect(custom_field.name).to eq("Updated Field")
      end

      it "renders a JSON response with the custom_field" do
        put :update, params: { client_id: client.id, id: custom_field.id, custom_field: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        put :update, params: { client_id: client.id, id: custom_field.id, custom_field: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end
end
