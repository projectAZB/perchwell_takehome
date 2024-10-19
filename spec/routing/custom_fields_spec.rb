require "rails_helper"

RSpec.describe CustomFieldsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/clients/1/custom_fields").to route_to("custom_fields#create", client_id: "1")
    end
  end
end
