require "rails_helper"

RSpec.describe Client, type: :model do
    describe "validations" do
        it { should validate_presence_of(:name) }
        it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    end

    describe "associations" do
        it { should have_many(:buildings) }
        it { should have_many(:custom_fields) }
    end

    describe "callbacks" do
        it "normalizes the name before saving" do
            client = Client.create(name: " mark jones")
            expect(client.name).to eq("Mark Jones")
        end
    end

end
