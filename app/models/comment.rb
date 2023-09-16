class Comment < ApplicationRecord
  
  validates :text, presence: true, length:{maximum: 60}
  
  belongs_to :user
  belongs_to :post
  
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :top_parent_id, dependent: :destroy
  
end
