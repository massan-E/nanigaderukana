class Program < ApplicationRecord
  validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :body, allow_nil: true, length: { maximum: 255 }

  belongs_to :user
  has_many :user_participations, dependent: :destroy
  has_many :participants, through: :user_participations, source: :user
  has_many :letterboxes, dependent: :destroy
end
