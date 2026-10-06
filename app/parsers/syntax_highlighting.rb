require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

class SyntaxHighlighting < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def initialize(options = {})
    super({ prettify: true })
  end

  # ```mermaid fences are left as escaped source for the client-side mermaid
  # Stimulus controller to render; everything else goes through Rouge.
  def block_code(code, language)
    return super unless language == "mermaid"

    %(<pre class="mermaid">#{ERB::Util.html_escape(code)}</pre>)
  end
end
