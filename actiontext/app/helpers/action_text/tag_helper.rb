# frozen_string_literal: true

require "active_support/core_ext/object/try"
require "action_view/helpers/tags/placeholderable"

module ActionText
  module TagHelper
    cattr_accessor(:id, instance_accessor: false) { 0 }

    def rich_text_area_tag(name, value = nil, options = {})
      ActionText.editor.rich_text_area_tag(main_app, name, value, options)
    end
  end
end

module ActionView::Helpers
  class Tags::ActionText < Tags::Base
    include Tags::Placeholderable

    delegate :dom_id, to: ActionView::RecordIdentifier

    def render
      options = @options.stringify_keys
      add_default_name_and_id(options)
      options["input"] ||= dom_id(object, [options["id"], "#{ActionText.editor.name}_input"].compact.join("_")) if object
      @template_object.rich_text_area_tag(options.delete("name"), editable_value, options)
    end

    def editable_value
      value&.body.try(:to_editor_html)
    end
  end

  module FormHelper
    # Returns a +trix-editor+ tag that instantiates the Trix JavaScript editor as well as a hidden field
    # that Trix will write to on changes, so the content will be sent on form submissions.
    #
    # ==== Options
    # * <tt>:class</tt> - Defaults to "trix-content" which ensures default styling is applied.
    #
    # ==== Example
    #   form_with(model: @message) do |form|
    #     form.rich_text_area :content
    #   end
    #   # <input type="hidden" name="message[content]" id="message_content_trix_input_message_1">
    #   # <trix-editor id="content" input="message_content_trix_input_message_1" class="trix-content" ...></trix-editor>
    def rich_text_area(object_name, method, options = {})
      Tags::ActionText.new(object_name, method, self, options).render
    end
  end

  class FormBuilder
    def rich_text_area(method, options = {})
      @template.rich_text_area(@object_name, method, objectify_options(options))
    end
  end
end
