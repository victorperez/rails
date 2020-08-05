# frozen_string_literal: true

# Concrete Strategies implement the algorithm while following the base Strategy
# interface. The interface makes them interchangeable in the Context.

module ActionText
  class Editor::TrixEditor < Editor
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper

    # Returns a +trix-editor+ tag that instantiates the Trix JavaScript editor as well as a hidden field
    # that Trix will write to on changes, so the content will be sent on form submissions.
    #
    # ==== Options
    # * <tt>:class</tt> - Defaults to "trix-content" which ensures default styling is applied.
    #
    # ==== Example
    #
    #   rich_text_area_tag "content", message.content
    #   # <input type="hidden" name="content" id="trix_input_post_1">
    #   # <trix-editor id="content" input="trix_input_post_1" class="trix-content" ...></trix-editor>
    def rich_text_area_tag(main_app, name, value = nil, options = {})
      options = options.symbolize_keys

      options[:input] ||= "trix_input_#{ActionText::TagHelper.id += 1}"
      options[:class] ||= "trix-content"

      options[:data] ||= {}
      options[:data][:direct_upload_url] = main_app.rails_direct_uploads_url
      options[:data][:blob_url_template] = main_app.rails_service_blob_url(":signed_id", ":filename")

      editor_tag = content_tag("trix-editor", "", options)
      input_tag = hidden_field_tag(name, value, id: options[:input])

      input_tag + editor_tag
    end
  end
end
