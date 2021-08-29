# frozen_string_literal: true

class PagesController < ApplicationController
  def homepage
    @posts = Post.all.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
end
