class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :slug, null: false
      t.index :slug, unique: true
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
