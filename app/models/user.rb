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

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 認証トークンをデータベースに記憶する
  def set_auth_token
    self.auth_token = User.new_token
    update_attribute(:auth_digest, User.digest(auth_token))
  end

  # 認証トークンをデータベースから削除する
  def delete_auth_token
    update_attribute(:auth_digest, nil)
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end
end
