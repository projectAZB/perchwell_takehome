class Client < ApplicationRecord
    has_many :buildings, dependent: :destroy
    has_many :custom_fields, dependent: :destroy

    validates :name, presence: true, length: { minimum: 2, maximum: 100 }

    before_save :normalize_name

    private

    def normalize_name
        self.name = name.strip.titleize
    end

end
