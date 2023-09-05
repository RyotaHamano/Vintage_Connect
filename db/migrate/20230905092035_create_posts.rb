class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :prefecture, null: false, default: 0
      t.string :address, null: false
      t.string :shop_name, null: false
      t.integer :shop_genre, null: false, default: 0
      t.text :review, null: false
      t.integer :rate, null: false
      t.boolean :reading_status, null: false, default: false

      t.timestamps
    end
  end
end
