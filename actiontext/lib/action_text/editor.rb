# frozen_string_literal: true

# The Strategy interface declares operations common to all supported versions of
# some algorithm.
#
# The Context uses this interface to call the algorithm defined by Concrete
# Strategies.
module ActionText
  class Editor
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def rich_text_area_tag(name, value = nil, options = {})
      raise NotImplementedError
    end
  end
end
