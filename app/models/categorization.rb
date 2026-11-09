class Categorization < ApplicationRecord
  belongs_to :vehicle
  belongs_to :category

  validates :vehicle_id, presence: true
  validates :category_id, presence: true

  validates :vehicle_id, uniqueness: {
    scope: :category_id
  }
end