# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < JSONAPI::ResourceController
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :null_session
    end
  end
end
