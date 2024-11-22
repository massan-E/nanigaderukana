class Letterbox < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, allow_nil: true, length: { maximum: 255 }

  belongs_to :program
  has_many :letters, dependent: :nullify

  def self.ransackable_attributes(auth_object = nil)
    [ "id" ]
  end
end
