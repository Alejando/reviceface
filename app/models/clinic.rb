class Clinic < ApplicationRecord
  has_many :doctors, -> { where(role: 'doctor') }, class_name: 'User'
  has_many :patients
  has_many :routines, through: :patients

  validates :name, presence: true
  validates :status, presence: true

  enum :status, %w[active inactive].index_by(&:to_sym)
end
