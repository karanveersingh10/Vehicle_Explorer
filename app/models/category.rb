class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :vehicles, through: :categorizations

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end