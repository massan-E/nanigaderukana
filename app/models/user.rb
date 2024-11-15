class User < ApplicationRecord
  validates :name,  presence: true, uniqueness: true, length: { maximum: 50 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
end
