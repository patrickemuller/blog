class AddIndexForSlugAndTitle < ActiveRecord::Migration[6.1]
  def change
    add_index :posts, [:slug, :title], unique: true
  end
end
