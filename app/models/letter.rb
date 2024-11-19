class Letter < ApplicationRecord
  validates :radio_name, presence: true, length: { maximum: 50 }
  validates :title, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 999 }

  belongs_to :user,  optional: true
  belongs_to :letterbox
  belongs_to :program

  def self.ransackable_attributes(auth_object = nil)
    [ "body", "letterbox_id", "is_read", "publish", "radio_name", "created_at" ]
  end

  # def self.random
  #   random_letter_id = self.where(publish: true, is_read: false).pluck(:id).sample
  #   random_letter = random_letter_id ? Letter.find(random_letter_id) : nil
  #   random_letter.update!(is_read: true) if random_letter
  #   random_letter
  # end

  def self.reset_is_read
    letters = self.where(is_read: true)
    letters.each { |letter| letter.update!(is_read: false) }
  end
end
