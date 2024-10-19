FactoryBot.define do
  factory :custom_field do
    name { "Test Field" }
    value_type { "text" }
    association :client
  end
end
