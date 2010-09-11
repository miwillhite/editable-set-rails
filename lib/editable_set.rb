# TODO: 
#   Build span (look at how rails does it actionpack>actionview>helpers>form_helper.rb)
#   Should form builder actually build a form? if so, editable-set js needs to be able to compensate for that

class EditableSetFormBuilder < ActionView::Helpers::FormBuilder
  
  def editable_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => EditableSetFormBuilder)
    form_for(*(args + [options]), &block).gsub(/^<form/, "<div").gsub(/<\/form>/, "</div>").html_safe!
  end
  
  def text_field(object_name, method, options = {})      
    InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_span_tag("text", options)
  end
  
end

module ActionView
  module Helpers
    class InstanceTag
      
      def to_input_field_span_tag(field_type, options = {})
        options = options.stringify_keys
        options["data-size"] = options["data-maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("data-size")
        options = DEFAULT_FIELD_OPTIONS.merge(options)
        if field_type == "hidden"
          options.delete("data-size")
        end
        options["data-type"] = field_type
        add_default_name_and_id(options)
        content_tag(:span, options)
      end
      
    end
  end
end