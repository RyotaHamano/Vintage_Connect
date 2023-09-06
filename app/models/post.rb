class Post < ApplicationRecord
  
  has_many_attached :post_images
  
  has_many :taggings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  
  
  
end
