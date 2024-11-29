class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  attr_accessor :remember_token

  validates :email, uniqueness: true, allow_blank: true # deviceとともに追加

  validates :name,  presence: true, uniqueness: true, length: { maximum: 50 }


  has_many :letters, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :user_participations, dependent: :destroy
  has_many :joined_programs, through: :user_participations, source: :program

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def session_token
    remember_digest || remember
  end

  # ransack用
  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  # device用
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
