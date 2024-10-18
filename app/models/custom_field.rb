class CustomField < ApplicationRecord
  belongs_to :client

  enum value_type: { number: 0, text: 1, enum_type: 2 }

  validates :name, presence: true
  validates :value_type, presence: true
  validates :client, presence: true

end
