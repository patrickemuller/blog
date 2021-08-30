class AddStripedBodyToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :striped_body, :text, null: false, default: ''
  end
end
