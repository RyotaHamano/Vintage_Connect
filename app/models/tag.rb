class Tag < ApplicationRecord
  
  validates :name, presence: true
  
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings
  
end
