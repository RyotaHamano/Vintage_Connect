class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :user_image
  
  has_many :posts, dependent: :destroy
  has_many :tags
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many :follow, class_name: 'Relation', foreign_key: "follow_id", dependent: :destroy
  has_many :followed, class_name: 'Relation', foreign_key: "followed_id", dependent: :destroy
  has_many :follow_user, through: :follow, source: :followed
  has_many :followed_user, through: :followed, source: :follow
  
  GUEST_USER_EMAIL = "guest@example.com"
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end
  
end
