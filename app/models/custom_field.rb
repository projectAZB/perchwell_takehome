class CustomField < ApplicationRecord
  belongs_to :client

  enum value_type: { number: 0, text: 1, enum: 2 }

  validates :value, presence: true
  validates :value_type, presence: true

  validate :value_matches_type

  private

  def value_matches_type
    case value_type.to_sym
    when :number
      errors.add(:value, "must be a number") unless value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
    when :enum
      errors.add(:value, "must be a comma-separated list for enum type") unless value.to_s.include?(',')
    end 
  end
end
