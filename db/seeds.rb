# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = ENV['ADMIN_PASSWORD']
end

taro = User.find_or_create_by!(email: "vintage@example.com") do |user|
  user.name = "Vintage太郎"
  user.password = "password"
  user.most_favorite = "古着"
  user.introduction = "古着が好きです"
end

User.find_or_create_by!(email: "vintage_item@example.com") do |user|
  user.name = "Vintage次郎"
  user.password = "Password"
  user.most_favorite = "アメリカ古着"
  user.introduction = "アメリカ古着が好きです"
end

User.find_or_create_by!(email: "vintages@example.com") do |user|
  user.name = "Vintage三郎"
  user.password = "Password"
  user.most_favorite = "ユーロアンティーク"
  user.introduction = "ヨーロッパのアンティークが好きです"
end

User.find_or_create_by!(email: "antique@example.com") do |user|
  user.name = "Antique花子"
  user.password = "Password"
  user.most_favorite = "日本の古物"
  user.introduction = "昭和レトロ雑貨が好きです"
end

Tag.find_or_create_by!(name: "古着") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "古物") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "古道具") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "オールドインテリア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "アンティーク") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "アメリカ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ヨーロッパ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "日本") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "中国") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "韓国") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "フランス") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "イギリス") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "イタリア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ドイツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "チェコ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ベルギー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スウェーデン") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スイス") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "オランダ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "デンマーク") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "カナダ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "オーストリア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "デンマーク") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スペイン") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ギリシャ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ノルウェー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ロシア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ハンガリー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ポルトガル") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "オーストラリア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ポーランド") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ルーマニア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ブルガリア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "セルビア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "クロアチア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "フィンランド") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "パキスタン") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "Tシャツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "シャツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ポロシャツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "セーター") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "カーディガン") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スウェット") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "パーカー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ベスト") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ジャケット") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "コート") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ブラウス") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ワンピース") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ジャージ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "タンクトップ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "デニムパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スラックスパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ストレートパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ペインターパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "カーゴパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ワークパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スキニーパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ブーツカットパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "フレアパンツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "オーバーオール") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "オールインワン") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スカート") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "セットアップ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "バッグ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "スニーカー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ドレスシューズ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ブーツ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "サンダル") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "パンプス") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "腕時計") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "アクセサリー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "財布") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "帽子") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "サングラス") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "マフラー") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ネクタイ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "ベルト") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "バンダナ") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "食器") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "茶器") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "酒器") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "インテリア") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "照明") do |tag|
  tag.user = taro
end

Tag.find_or_create_by!(name: "銀細工") do |tag|
  tag.user = taro
end