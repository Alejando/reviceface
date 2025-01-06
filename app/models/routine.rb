class Routine < ApplicationRecord
  belongs_to :patient
  has_many :routine_exercises, dependent: :destroy
  has_many :exercises, through: :routine_exercises


  validates :name, :start_at, :patient_id, presence: true

  enum :status, %w[pending in_progress done].index_by(&:to_sym)

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= :pending
  end
end
