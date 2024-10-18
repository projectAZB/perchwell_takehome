require "rails_helper"

RSpec.describe Building, type: :model do
  let(:client) { Client.create!(name: "Test Client") }
  let!(:number_field) { CustomField.create!(client: client, name: 'Chimneys', value_type: :number) }
  let!(:text_field) { CustomField.create!(client: client, name: 'Description', value_type: :text) }
  let!(:enum_field) { CustomField.create!(client: client, name: 'Color', value_type: :enum_type, value: 'Red, Blue, or Green') }

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

  describe "custom field validations" do
    it "validates that custom field values belong to the client" do
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
        custom_field_values: { number_field.id.to_s => "2" },
      )
      expect(building).to be_valid

      other_client = Client.create!(name: 'Other Client')
      other_client_field = CustomField.create(
        client: other_client,
        name: "Architectural Style",
        value_type: :text,
      )
      building.custom_field_values[other_client_field.id.to_s] = "Invalid"
      expect(building).to be_invalid
      expect(building.errors.full_messages).to include("Custom field values contains invalid custom field ids: #{other_client_field.id}")
    end

    it "validates number type custom field values" do
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
        custom_field_values: { number_field.id.to_s => "Not a number" },
      )
      expect(building).to be_invalid
      expect(building.errors.full_messages).to include("Custom field values #{number_field.id} must be a number")

      building.custom_field_values[number_field.id.to_s] = "2"
      expect(building).to be_valid
    end

    it "validates text type custom field values" do
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
        custom_field_values: { text_field.id.to_s => "All text is valid" },
      )
      expect(building).to be_valid
    end

    it "validates enum type custom field values" do
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
        custom_field_values: { enum_field.id.to_s => "Yellow" },
      )
      expect(building).to be_invalid
      expect(building.errors.full_messages).to include("Custom field values #{enum_field.id} must be one of: Red, Blue, Green")

      building.custom_field_values[enum_field.id.to_s] = "Blue"
      expect(building).to be_valid
    end

    it "is valid without any custom fields" do 
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
      )
      expect(building).to be_valid
    end

    it "validates presence of custom field values" do
      building = Building.new(
        client: client,
        address: "123 Maple Street",
        state: "PA",
        zip_code: "17042",
        custom_field_values: { number_field.id.to_s => nil }
      )
      expect(building).to be_invalid
      expect(building.errors.full_messages).to include("Custom field values #{number_field.id} cannot be nil")
    end

  end

  describe "callbacks" do
    it "normalizes the state before validation" do
      building = Building.create(client: client, address: "123 Test St", state: "pa", zip_code: "17042")
      expect(building.state).to eq("PA")
    end

    it "normalizes the address before saving" do
      building = Building.create(client: client, address: " 123 test st ", state: "PA", zip_code: "17042")
      expect(building.address).to eq("123 Test St")
    end
  end

end