class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :email, uniqueness: { case_sensitive: false, allow_blank: true } # deviceとともに追加

  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 50 }


  has_many :letters, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :user_participations, dependent: :destroy
  has_many :joined_programs, through: :user_participations, source: :program
  has_many :sns_credential, dependent: :destroy

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
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

  class << self   # ここからクラスメソッドで、メソッドの最初につける'self.'を省略できる
    # SnsCredentialsテーブルにデータがないときの処理
    def without_sns_data(auth)
      user = User.where(email: auth.info.email).first

      if user.present?
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
      else   # User.newの記事があるが、newは保存までは行わないのでcreateで保存をかける
        user = User.create(
          name: auth.info.name,    # デフォルトから追加したカラムがあれば記入
          email: auth.info.email,
          # profile_image: auth.info.image,
          password: Devise.friendly_token(10),   # 10文字の予測不能な文字列を生成する
          confirmed_at: Time.current   # 確認済みの時間を現在の時間に設定
          )
        sns = SnsCredential.create(
          user_id: user.id,
          uid: auth.uid,
          provider: auth.provider
          )
      end
      { user:, sns: }   # ハッシュ形式で呼び出し元に返す
    end

    # SnsCredentialsテーブルにデータがあるときの処理
    def with_sns_data(auth, snscredential)
      user = User.where(id: snscredential.user_id).first
      # 変数userの中身が空文字, 空白文字, false, nilの時の処理
      if user.blank?
        user = User.create(
          name: auth.info.name,
          email: auth.info.email,
          # profile_image: auth.info.image,
          password: Devise.friendly_token(10),
          confirmed_at: Time.current
          )
      end
      { user: }
    end

    # Googleアカウントの情報をそれぞれの変数に格納して上記のメソッドに振り分ける処理
    def find_oauth(auth)
      uid = auth.uid
      provider = auth.provider
      snscredential = SnsCredential.where(uid:, provider:).first
      if snscredential.present?
        user = with_sns_data(auth, snscredential)[:user]
        sns = snscredential
      else
        user = without_sns_data(auth)[:user]
        sns = without_sns_data(auth)[:sns]
      end
      { user:, sns: }
    end
  end
end
