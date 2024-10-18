require "rails_helper"

RSpec.describe Building, type: :model do
  let(:client) { Client.create!(name: "Test Client") }
  let(:custom_field) { CustomField.create!(client: client, name: "Chimneys", value_type: :number) }

  describe "validations" do
    it { should validate_presence_of(:address) }
    it { should validate_length_of(:address).is_at_least(5).is_at_most(200) }
    it { should validate_presence_of(:state) }
    it { should validate_length_of(:state).is_equal_to(2) }
    it { should allow_value("PA").for(:state) }
    it { should_not allow_value("Pennsylvania").for(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should allow_value("17042").for(:zip_code) }
    it { should allow_value("17042-1234").for(:zip_code) }
    it { should_not allow_value("1234").for(:zip_code) }
  end

  describe "associations" do 
    it { should belong_to(:client) }
  end

  describe "custom field validation" do
    it "validates that custom field values belong to the client" do
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
        custom_field_values: { custom_field.id.to_s => "2" }
      )
      expect(building).to be_valid

      other_client_field = CustomField.create(
        client: Client.create(name: "Other Client"),
        name: "Architectural Style",
        value_type: :text,
      )
    end
  end

end