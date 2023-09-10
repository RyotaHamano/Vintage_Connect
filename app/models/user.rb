class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :user_image
  
  def get_user_image(width, height)
    unless user_image.attached?
      file_path = Rails.root.join('app/assets/images/sample.jpg')
      user_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    user_image.variant(resize_to_limit: [width, height]).processed
  end
  
  has_many :posts, dependent: :destroy
  has_many :tags
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites
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
  
  def follow?(user)
    follow_user.include?(user)
  end
  
end
