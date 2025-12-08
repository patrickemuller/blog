class AddFullTextSearchToPosts < ActiveRecord::Migration[8.0]
  def up
    # Add a generated tsvector column for full-text search
    execute <<-SQL
      ALTER TABLE posts
      ADD COLUMN search_vector tsvector
      GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(body, '')), 'B')
      ) STORED;
    SQL

    # Add GIN index for fast full-text search
    add_index :posts, :search_vector, using: :gin
  end

  def down
    remove_index :posts, :search_vector
    remove_column :posts, :search_vector
  end
end
