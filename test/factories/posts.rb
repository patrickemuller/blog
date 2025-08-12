FactoryBot.define do
  factory :post do
    sequence(:slug) { |n| "post-#{n}" }
    sequence(:title) { |n| "Post #{n}" }
    body do
      <<~MARKDOWN
        Today I want to share a simple but powerful Ruby method that I've been using in my Rails applications. The `pluck` method is incredibly useful when you need to extract specific column values from your database records without loading the entire ActiveRecord objects into memory.

        Here's a practical example of how to use it:

        ```ruby
        # Instead of this (loads full objects)
        user_names = User.all.map(&:name)

        # Use this (only fetches the name column)
        user_names = User.pluck(:name)

        # You can even pluck multiple columns
        user_data = User.pluck(:id, :name, :email)
        ```

        This approach is much more memory-efficient, especially when dealing with large datasets. The `pluck` method returns an array of values directly from the database, bypassing the overhead of instantiating ActiveRecord objects.

        I've found this particularly useful in reporting features where I need to generate CSV exports or create dropdown options. The performance difference becomes noticeable when working with thousands of records.

        What's your favorite ActiveRecord method for optimizing database queries? I'd love to hear about other techniques you use in your Rails applications!
      MARKDOWN
    end
  end
end