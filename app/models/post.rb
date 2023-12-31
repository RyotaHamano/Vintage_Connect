class Post < ApplicationRecord
  
  validates :shop_genre, presence: true
  validates :shop_name, presence: true
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :review, presence: true, length:{maximum: 400}
  validates :rate, presence: true
  validate :validate_number_of_files
  
  has_many_attached :post_images
  
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  
  enum prefecture: {hokkaido: 0, aomori: 1, iwate: 2, miyagi: 3, akita: 4, yamagata: 5, fukushima: 6, ibaraki: 7, tochigi: 8, gunma: 9, saitama: 10, 
                    chiba: 11, tokyo: 12, kanagawa: 13, niigata: 14, toyama: 15, ishikawa: 16, fukui: 17, yamanashi: 18, nagano: 19, gifu: 20, 
                    shizuoka: 21, aichi: 22, mie: 23, shiga: 24, kyoto: 25, osaka: 26, hyogo: 27, nara: 28, wakayama: 29, tottori: 30, 
                    shimane:31, okayama: 32, hiroshima: 33, yamaguchi: 34, tokushima: 35, kagawa: 36, ehime: 37, kochi: 38, fukuoka: 39, saga: 40, 
                    nagasaki: 41, kumamoto: 42, oita: 43, miyazaki: 44, kagoshima: 45, okinawa: 46}
  
  enum shop_genre: {old_clothing: 0, old_item: 1, old_tool: 2, old_interior: 3, antique: 4}
  
  # 並べ替え
  def self.ordered_sort(rule)
    if rule == "0"
      order(id: :desc)
    elsif rule == "1"
      order(id: :asc)
    elsif rule == "2"
      order(rate: :desc)
    elsif rule == "3"
      #.sort{|a,b| b.favorites.size <=> a.favorites.size }
      left_joins(:favorites)
             .select('posts.*, COUNT(favorites.id) AS favorites_count')
             .group('posts.id')
             .order('favorites_count DESC')
    end
  end
  
  FILE_NUMBER_LIMIT = 5
  
  private
  
  def validate_number_of_files
    return if post_images.length <= FILE_NUMBER_LIMIT
    errors.add(:post_images, "に添付できる画像は#{FILE_NUMBER_LIMIT}件までです。")
  end
  
end