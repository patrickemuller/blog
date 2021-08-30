# frozen_string_literal: true

class PagesController < ApplicationController
  def homepage
    @posts = Post.all.order(created_at: :desc)
  end
end
