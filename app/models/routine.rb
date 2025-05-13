class Routine < ApplicationRecord
  belongs_to :patient
  has_many :routine_exercises, dependent: :destroy
  has_many :exercises, through: :routine_exercises


  validates :name, :start_at, :patient_id, presence: true

  enum :status, %w[pending in_progress done].index_by(&:to_sym)

  before_validation :set_default_status, on: :create

  accepts_nested_attributes_for :routine_exercises, allow_destroy: true, reject_if: :all_blank

  before_destroy :can_destroy?

  ransack_alias :search_routine, :name_or_patient_user_first_name_or_patient_user_last_name

  def self.ransackable_attributes(auth_object = nil)
    %w[id name status start_at end_at search_routine]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[patient routine_exercises exercises]
  end

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
