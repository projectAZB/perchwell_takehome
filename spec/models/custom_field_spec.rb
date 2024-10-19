require "rails_helper"

RSpec.describe CustomField, type: :model do
  let(:client) { Client.create(name: "Test Client") }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value_type) }
    it { should validate_presence_of(:client) }
  end

  describe "associations" do
    it { should belong_to(:client) }
  end

  describe "enums" do
    it { should define_enum_for(:value_type).with_values(number: 0, text: 1, enum_type: 2) }
  end

  describe "value attribute" do
    it "is optional for number type" do
      custom_field = CustomField.new(client: client, name: "Size", value_type: :number)
      expect(custom_field).to be_valid
    end

    it "is optional for text type" do
      custom_field = CustomField.new(client: client, name: "Description", value_type: :text)
      expect(custom_field).to be_valid
    end

    it "is required for enum type" do
      custom_field = CustomField.new(client: client, name: "Color", value_type: :enum_type)
      expect(custom_field).to be_invalid
      expect(custom_field.errors[:value]).to include("must contain at least one valid option for enum type")
    end

    it "must contain at least one valid option for enum type" do
      custom_field = CustomField.new(client: client, name: "Color", value_type: :enum_type, value: "")
      expect(custom_field).to be_invalid
      expect(custom_field.errors[:value]).to include("must contain at least one valid option for enum type")

      custom_field.value = "Red, Green, Blue"
      expect(custom_field).to be_valid
    end

    it "handles \"or\" in enum values" do
      custom_field = CustomField.new(client: client, name: "Color", value_type: :enum_type, value: "Red, Blue, or Green")
      expect(custom_field).to be_valid
      expect(custom_field.enum_values).to eq(["Red", "Blue", "Green"])
    end

    it "handles various formats of \"or\" in enum values" do
      custom_field = CustomField.new(client: client, name: "Color", value_type: :enum_type, value: "Red, Blue or Green or Yellow")
      expect(custom_field).to be_valid
      expect(custom_field.enum_values).to eq(["Red", "Blue", "Green", "Yellow"])
    end

    it "removes duplicate values in enum type" do
      custom_field = CustomField.new(client: client, name: "Color", value_type: :enum_type, value: "Red, Blue, Green, or Blue")
      expect(custom_field).to be_valid
      expect(custom_field.enum_values).to eq(["Red", "Blue", "Green"])
    end
  end

  describe "creation" do
    it "can create a number type custom field" do
      custom_field = CustomField.create(client: client, name: "Size", value_type: :number)
      expect(custom_field).to be_valid
      expect(custom_field.value_type).to eq("number")
    end

    it "can create a text type custom field" do
      custom_field = CustomField.create(client: client, name: "Description", value_type: :text)
      expect(custom_field).to be_valid
      expect(custom_field.value_type).to eq("text")
    end

    it "can create an enum type custom field" do
      custom_field = CustomField.create(client: client, name: "Color", value_type: :enum_type, value: "Red, Blue, or Green")
      expect(custom_field).to be_valid
      expect(custom_field.value_type).to eq("enum_type")
      expect(custom_field.enum_values).to eq(["Red", "Blue", "Green"])
    end
  end
end
