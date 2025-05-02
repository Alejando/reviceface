class Patient < ApplicationRecord
  belongs_to :clinic
  belongs_to :user
  has_many :routines, dependent: :destroy

  validates :user, uniqueness: { scope: :clinic }
  accepts_nested_attributes_for :user

  delegate :full_name, :inactivated_at, to: :user

  scope :confirmed, -> { where.not(agree_terms_at: nil, agree_privacy_at: nil) }
  scope :active, -> { joins(:user).confirmed.where(users: { inactivated_at: nil }) }

  ransack_alias :search_patient, :user_first_name_or_user_last_name

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id search_patient]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def accepted_terms_and_conditions?
    agree_terms_at && agree_privacy_at
  end

  def upcoming_routines
    routines.where('start_at >= ?', Date.current).order(:start_at)
  end
end
