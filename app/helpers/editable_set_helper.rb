module EditableSetHelper
  def editable_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => EditableSetFormBuilder)
    form_for(*(args + [options]), &block)
  end
  
  class EditableSetFormBuilder < ActionView::Helpers::FormBuilder
    def text_field(object_name, method, options = {})
      # TODO: Build span (look at how rails does it actionpack>actionview>helpers>form_helper.rb)      
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_span_tag("text", options)
    end
    
  end
  
  
end

module ActionView
  module Helpers
    class InstanceTag
      
      def to_input_field_span_tag(field_type, options = {})
        options = options.stringify_keys
        options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
        options = DEFAULT_FIELD_OPTIONS.merge(options)
        if field_type == "hidden"
          options.delete("size")
        end
        options["type"] = field_type
        options["value"] ||= value_before_type_cast(object) unless field_type == "file"
        options["value"] &&= html_escape(options["value"])
        add_default_name_and_id(options)
        tag("input", options) # Get rid of this?
      end
      
    end
  end
end