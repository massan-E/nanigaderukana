class Letterbox < ApplicationRecord
  validates :title, presence: true, length: { miximum: 100 }
  validates :body, allow_nil: true, length: { maximum: 255 }

  belongs_to :programs
  has_many: :letters, dependent :destroy
end
