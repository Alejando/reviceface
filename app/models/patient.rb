class Patient < ApplicationRecord
  belongs_to :clinic
  belongs_to :user
  has_many :routines, dependent: :destroy

  validates :user, uniqueness: { scope: :clinic }
  accepts_nested_attributes_for :user

  delegate :full_name, :inactivated_at, to: :user

  scope :confirmed, -> { where.not(agree_terms_at: nil, agree_privacy_at: nil) }
  scope :active, -> { joins(:user).confirmed.where(users: { inactivated_at: nil }) }
  scope :order_by_user_status_and_name, -> (order = :asc) {
    joins(:user).order(Arel.sql("COALESCE(users.inactivated_at, '9999-12-31') ASC, users.first_name #{order}, users.last_name #{order}"))
  }

  def accepted_terms_and_conditions?
    agree_terms_at && agree_privacy_at
  end

  def upcoming_routines
    routines.where('start_at >= ?', Date.current).order(:start_at)
  end
end
