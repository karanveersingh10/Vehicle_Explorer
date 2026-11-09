class Vehicle < ApplicationRecord
  belongs_to :make

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  validates :model, presence: true
  validates :model_year, presence: true,
                         numericality: {
                           only_integer: true,
                           greater_than: 1885
                         }
  validates :vehicle_type, presence: true
end