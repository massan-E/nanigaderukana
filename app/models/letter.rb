class Letter < ApplicationRecord
  validates :radio_name, presence: true, length: { maximum: 50 }
  validates :title, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 999 }

  belongs_to :user,  optional: true
  belongs_to :letterbox
  belongs_to :program

  scope :search, ->(q) { where("radio_name LIKE ?", "%#{q}%").limit(6) }

  def self.ransackable_attributes(auth_object = nil)
    [ "body", "letterbox_id", "is_read", "publish", "radio_name", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end

  def self.reset_is_read
    letters = self.where(is_read: true)
    letters.update_all(is_read: false)
  end
end
