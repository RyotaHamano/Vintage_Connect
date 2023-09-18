class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :name, presence: true
  
  has_one_attached :user_image
  
  # プロフィール画像取得メソッド
  def get_user_image(width,height)
    unless user_image.attached?
      file_path = Rails.root.join('app/assets/images/sample.jpg')
      user_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    user_image.variant(resize_to_limit: [width,height]).processed
  end
  
  has_many :posts, dependent: :destroy
  has_many :tags
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy
  
  has_many :follow, class_name: 'Relation', foreign_key: "follow_id", dependent: :destroy
  has_many :followed, class_name: 'Relation', foreign_key: "followed_id", dependent: :destroy
  has_many :follow_user, through: :follow, source: :followed
  has_many :followed_user, through: :followed, source: :follow
  
  GUEST_USER_EMAIL = "guest@example.com"
  
  # ゲストログイン用アカウント作成
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end
  
  # ゲストユーザー判別
  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  # フォロー有無確認
  def follow?(user)
    follow_user.include?(user)
  end
  
  # 優良ユーザー判別
  def green?
    posts = self.number_of_deleted_posts
    comments = self.number_of_deleted_comments
    tags = self.number_of_deleted_tags
    return true if (self.is_admission == false) && (posts <= 3) && (comments <= 5) && (tags <= 5)
  end
  
  # 注意ユーザー判別
  def yellow?
    posts = self.number_of_deleted_posts
    comments = self.number_of_deleted_comments
    tags = self.number_of_deleted_tags
    return true if (self.is_admission == false) && ((posts <= 6) && (comments <= 10) && (tags <= 10))
  end
  
  # 要注意ユーザー判別
  def red?
    posts = self.number_of_deleted_posts
    comments = self.number_of_deleted_comments
    tags = self.number_of_deleted_tags
    return true if (self.is_admission == false) && ((posts <= 9) && (comments <= 15) && (tags <= 15))
  end
  
  # 削除待ちユーザー判別
  def gray?
    posts = self.number_of_deleted_posts
    comments = self.number_of_deleted_comments
    tags = self.number_of_deleted_tags
    return true if (self.is_admission == false) && ((posts >= 10) || (comments >= 16) || (tags <= 16))
  end
  
  # 削除済ユーザー判別
  def black?
    return true if self.is_admission == true
  end
  
end
