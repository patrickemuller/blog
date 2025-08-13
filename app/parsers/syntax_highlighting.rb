require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

class SyntaxHighlighting < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def initialize(options = {})
    super({ prettify: true })
  end
end
