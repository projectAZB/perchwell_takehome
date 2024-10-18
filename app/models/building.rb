class Building < ApplicationRecord
  belongs_to :client

  validates :address, presence: true, length: { minimum: 5, maximum: 200 }
  validates :state, presence: true, length: { is: 2 }, format: { with: /\A[A-Z]{2}\z/, message: "Must be a two-letter abbreviation" }
  validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "Must be a valid US ZIP code" }

  validate :custom_field_values_belong_to_client
  validate :custom_field_values_are_valid_types

  before_validation :normalize_state
  before_save :normalize_address

  private

  def custom_field_values_belong_to_client
    return if custom_field_values.blank?
    custom_field_ids = custom_field_values.keys.map(&:to_i)
    invalid_ids = custom_field_ids - client.custom_fields.pluck(:id)
    if invalid_ids.any?
      errors.add(:custom_field_values, "contains invalid custom field ids: #{invalid_ids.join(', ')}")
    end
  end

  def custom_field_values_are_valid_types
    return if custom_field_values.blank?
    custom_fields.each do |cf|
      value = custom_field_values[cf.id.to_s]

      if value.nil?
        errors.add(:custom_field_values, "#{cf.id} cannot be nil")
        next
      end

      case cf.value_type.to_sym
      when :number
        unless value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
          errors.add(:custom_field_values, "#{cf.id} must be a number")
        end
      when :text
        # Always valid if non-nil bc it's text
      when :enum_type
        unless cf.value.split(",").map(&:strip).include?(value.to_s)
          errors.add(:custom_field_values, "#{cf.id} must be one of #{cf.value}")
        end
      end
    end
  end

  def custom_fields
    @custom_fields ||= CustomField.where(id: custom_field_values.keys)
  end

  def normalize_state
    self.state = state.upcase if state.present?
  end

  def normalize_zip_code
    self.address = address.strip.titleize if address.present?
  end

end
