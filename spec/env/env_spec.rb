require "rails_helper"

RSpec.describe "Environment Check" do
  it "prints the current Rails environment" do
    expect(Rails.env).to eq("test")
  end
end
