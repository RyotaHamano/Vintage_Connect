class Post < ApplicationRecord
  
  has_many :taggings
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  
end
