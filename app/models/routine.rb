class Routine < ApplicationRecord
  belongs_to :patient
  has_many :routine_exercises, dependent: :destroy
  has_many :exercises, through: :routine_exercises


  validates :name, :start_at, :patient_id, presence: true

  enum :status, %w[pending in_progress done].index_by(&:to_sym), prefix: true

  before_validation :set_default_status, on: :create

  accepts_nested_attributes_for :routine_exercises, allow_destroy: true, reject_if: :all_blank

  before_destroy :can_destroy?

  private

  def set_default_status
    self.status ||= :pending
  end

  def can_destroy?
    return if pending?

    errors.add(:base, I18n.t('routines.errors.destroy.not_allowed'))
    throw(:abort) if errors
  end
end
