class Patient < ApplicationRecord
  belongs_to :clinic
  belongs_to :user
  has_many :routines, dependent: :destroy

  validates :user, uniqueness: { scope: :clinic }
  accepts_nested_attributes_for :user

  delegate :full_name, to: :user

  scope :confirmed, -> { where.not(agree_terms_at: nil, agree_privacy_at: nil) }

  def accepted_terms_and_conditions?
    agree_terms_at && agree_privacy_at
  end
end
