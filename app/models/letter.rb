class Letter < ApplicationRecord
  validates :radio_name, presence: true, length: { maximum: 50 }
  validates :title, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 999 }

  belongs_to :user,  optional: true
  belongs_to :letterbox
  belongs_to :program
end
