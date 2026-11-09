class Make < ApplicationRecord
  has_many :vehicles, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
end