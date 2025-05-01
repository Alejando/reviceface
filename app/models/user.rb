class User < ApplicationRecord
  has_one_attached :profile_photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  belongs_to :clinic, optional: true
  has_one :patient, dependent: :destroy
  has_one_attached :profile_photo

  enum :role, %w[admin doctor patient].index_by(&:to_sym), prefix: true

  before_validation :set_defaults, on: :create
  validates :encrypted_password, presence: true, on: :update


  attr_accessor :skip_password_validation


  #TODO: remove confirm_user after implementing email confirmation
  after_create :confirm_user

  def age
    return nil unless birthdate

    ((Time.zone.now - birthdate.to_datetime) / 1.year.seconds).floor
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def profile_photo_url
    if profile_photo.attached?
      profile_photo.url
    else
      ActionController::Base.helpers.asset_path('default-avatar.png')
    end
  end

  private

  def set_defaults
    self.role ||= :patient
    self.clinic ||= Clinic.first
  end

  def confirm_user
    self.confirm
  end

  def password_required?
    return false if skip_password_validation
    super
  end
end
