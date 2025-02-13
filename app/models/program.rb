class Program < ApplicationRecord
  attr_accessor :invitation_token

  validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :body, allow_nil: true, length: { maximum: 255 }

  belongs_to :user
  has_many :user_participations, dependent: :destroy
  has_many :participants, through: :user_participations, source: :user
  has_many :letterboxes, dependent: :destroy
  has_many :letters, dependent: :nullify

  has_one_attached :image

  def self.ransackable_associations(auth_object = nil)
    [ "letter", "letterbox", "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "title", "body" ]
  end

  def create_invitation_digest
    self.invitation_token = User.new_token
    update_attribute(:invitation_digest,  User.digest(invitation_token))
    update_attribute(:send_invitation_at, Time.zone.now)
  end

  def invitation_expired?
    send_invitation_at < 3.days.ago
  end

  def authenticated?(invitation_token)
    return false if invitation_digest.nil?
    BCrypt::Password.new(invitation_digest).is_password?(invitation_token)
  end

  def expiration_time
    (send_invitation_at + 3.days).strftime("%Y年%m月%d日 %H:%M")
  end
end
