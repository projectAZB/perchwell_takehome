class Building < ApplicationRecord
  belongs_to :client

  validates :address, presence: true, length: { minimum: 5, maximum: 200 }
  validates :state, presence: true, length: { is: 2 }, format: { with: /\A[A-Z]{2}\z/, message: "Must be a two-letter abbreviation" }
  validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "Must be a valid US ZIP code" }

  validate :custom_field_values_belong_to_client

  before_validation :normalize_state
  before_save :normalize_address

  private

  def custom_field_values_belong_to_client
    custom_field_ids = custom_field_values.keys.map(&:to_i)
    invalid_ids = custom_field_ids - client.custom_fields.pluck(:id)
    if invalid_ids.any?
      errors.add(:custom_field_values, "contains invalid custom field ids: #{invalid_ids.join(', ')}")
    end
  end

  def normalize_state
    self.state = state.upcase if state.present?
  end

  def normalize_zip_code
    self.address = address.strip.titleize if address.present?
  end

end
