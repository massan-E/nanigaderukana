class Program < ApplicationRecord
  attr_accessor :invitation_token

  validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :body, allow_nil: true, length: { maximum: 255 }

  belongs_to :user
  has_many :user_participations, dependent: :destroy
  has_many :participants, through: :user_participations, source: :user
  has_many :letterboxes, dependent: :destroy
  has_many :letters, dependent: :nullify

  def self.ransackable_associations(auth_object = nil)
    [ "letter", "letterbox" ]
  end

  def create_invitation_digest
    self.invitation_token = User.new_token
    update_attribute(:invitation_digest,  User.digest(invitation_token))
    update_attribute(:send_invitation_at, Time.zone.now)
  end

  def invitation_expired?
    send_invitation_at < 1.hours.ago
  end

  def authenticated?(invitation_token)
    return false if invitation_digest.nil?
    BCrypt::Password.new(invitation_digest).is_password?(invitation_token)
  end

  def expiration_time
    (send_invitation_at + 1.hour).strftime("%Y年%m月%d日 %H:%M")
  end
end
