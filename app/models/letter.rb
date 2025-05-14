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

  def generate_ogp_image_url
    url_removed_body = self.body.to_s.gsub(/https?:\/\/[\S]+/, "(URL)") # URLを削除
    trimmed_body = url_removed_body.gsub(/\R/, " ").gsub(/ /, "%20").truncate(300, omission: "...")
    "https://res.cloudinary.com/dvwsh79oq/image/upload/l_text:Sawarabi%20Gothic_45:#{CGI.escape(trimmed_body)},co_rgb:9aa5ce,y_-33,w_1010,h_400,c_fit/v1747177181/letter_ogp_back_s5ldoc.png"
  end
end
