# frozen_string_literal: true

Rails.logger.info('========> Creating Basic Admins....')

AdminUser.create!(email: 'admin@example.com', password: '123123123', password_confirmation: '123123123')

Rails.logger.info("DONE! \n\n")

Rails.logger.info('========> Creating Basic Posts....')

100.times do |index|
  Post.create!(slug: "post-#{index}", title: "Post #{index}", body: 'Lorem ipsum dolor sit amet')
end

Rails.logger.info("DONE! \n\n")
