class Letter < ApplicationRecord
  validates :title, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 999 }

  belongs_to :user,  optional: true
  belongs_to :letterbox
end
