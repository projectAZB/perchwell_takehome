class Building < ApplicationRecord
  belongs_to :client
  has_and_belongs_to_many :custom_fields

  validates :address, presence: true, length: { minimum: 5, maximum: 200 }
  validates :state, presence: true, length: { is: 2 }, format: { with: /\A[A-Z]{2}\z/, message: "Must be a two-letter abbreviation" }
  validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "Must be a valid US ZIP code" }

  validate :custom_fields_belong_to_client

  before_validation :normalize_state
  before_save :normalize_address

  private

  def custom_fields_belong_to_client
    if custom_fields.any? { |cf| cf.client_id != client_id }
      errors.add(:custom_fields, "Must belong to the same client as the building")
    end
  end

  def normalize_state
    self.state = state.upcase if state.present?
  end

  def normalize_zip_code
    self.address = address.strip.titleize if address.present?
  end

end
