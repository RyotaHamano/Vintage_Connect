class Post < ApplicationRecord
  
  has_many_attached :post_images
  
  has_many :taggings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  
  enum prefecture: {Hokkaido: 0, Aomori: 1, Iwate: 2, Miyagi: 3, Akita: 4, Yamagata: 5, Fukushima: 6, Ibaraki: 7, Tochigi: 8, Gunma: 9, Saitama: 10, 
                    Chiba: 11, Tokyo: 12, Kanagawa: 13, Niigata: 14, Toyama: 15, Ishikawa: 16, Fukui: 17, Yamanashi: 18, Nagano: 19, Gifu: 20, 
                    Shizuoka: 21, Aichi: 22, Mie: 23, Shiga: 24, Kyoto: 25, Osaka: 26, Hyogo: 27, Nara: 28, Wakayama: 29, Tottori: 30, 
                    Shimane:31, Okayama: 32, Hiroshima: 33, Yamaguchi: 34, Tokushima: 35, Kagawa: 36, Ehime: 37, Kochi: 38, Fukuoka: 39, Saga: 40, 
                    Nagasaki: 41, Kumamoto: 42, Oita: 43, Miyazaki: 44, Kagoshima: 45, Okinawa: 46}
  
end
