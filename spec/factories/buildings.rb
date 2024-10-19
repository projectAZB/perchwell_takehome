FactoryBot.define do
  factory :building do
    address { "123 Test St" }
    state { "CA" }
    zip_code { "12345" }
    association :client
  end
end
