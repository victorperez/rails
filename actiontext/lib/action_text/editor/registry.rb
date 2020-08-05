# frozen_string_literal: true

module ActionText
  class Editor::Registry #:nodoc:
    attr_reader :editor_name

    def self.build(editor_name)
      new(editor_name).build
    end

    def initialize(editor_name)
      @editor_name = editor_name
    end

    def build
      resolve(editor_name).new(editor_name)
    end

    private
      def resolve(editor_name)
        require "action_text/editor/#{editor_name.to_s.underscore}_editor"
        ActionText::Editor.const_get(:"#{editor_name.to_s.camelize}Editor")
      rescue LoadError
        raise "Missing editor adapter for #{editor_name.inspect}"
      end
  end
end
