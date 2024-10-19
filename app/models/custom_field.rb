class CustomField < ApplicationRecord
  belongs_to :client

  enum :value_type, { :number => 0, :text => 1, :enum_type => 2 }

  validates :name, presence: true
  validates :value_type, presence: true
  validates :client, presence: true
  validates :value, presence: true, if: :enum_type?

  validate :value_format_for_enum_type

  def enum_values
    return [] unless enum_type? && value.present?
    value.gsub(/\s*,?\s*or\s*,?\s*/, ",").split(",").map(&:strip).reject(&:empty?).uniq
  end

  private

  def value_format_for_enum_type
    if enum_type?
      if value.blank?
        errors.add(:value, "must contain at least one valid option for enum type")
      elsif enum_values.empty?
        errors.add(:value, "must contain at least one valid option for enum type")
      end
    end
  end

end
