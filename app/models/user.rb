class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  attr_accessor :auth_token
  before_save   :downcase_email
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # JSONにエンコードするときのフィールドを指定する
  def to_json(options)
    self.as_json(only: [:id, :name, :email]).to_json
  end

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(auth_token)
    return false if auth_digest.nil?
    BCrypt::Password.new(auth_digest).is_password?(auth_token)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 認証トークンをデータベースに記憶する
  def set_auth_token
    self.auth_token = User.new_token
    update_attribute(:auth_digest, User.digest(auth_token))
    update_attribute(:logined_at, Time.zone.now)
  end

  # 認証トークンをデータベースから削除する
  def delete_auth_token
    update_attribute(:auth_digest, nil)
    update_attribute(:logined_at, nil)
  end

  # トークンの有効期限が切れていればtrue
  def token_expired?
    logined_at < 1.hours.ago
  end

  # 認証トークンとUserIDを結合してエンコードしたアクセストークンを返す
  def access_token
    access_table = { id: id, auth_token: auth_token }
    CGI.escape(Base64.encode64(JSON.dump(access_table)))
  end

  # 受け取ったアクセストークンをデコードして認証トークンとUserIDを返す
  def self.decode_token(access_token)
    access_table = JSON.parse(Base64.decode64(CGI.unescape(access_token)))
    return access_table["id"], access_table["auth_token"]
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end
end
