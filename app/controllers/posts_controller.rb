# frozen_string_literal: true

class PostsController < ApplicationController
  def show
    @post = Post.find_by(slug: params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end
end
