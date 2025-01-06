class Exercise < ApplicationRecord
  has_many :routine_exercises, dependent: :destroy
  has_many :routines, through: :routine_exercises

  validates :name, presence: true
end
