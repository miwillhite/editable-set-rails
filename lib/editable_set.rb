# TODO: 
#   Should form builder actually build a form? if so, editable-set js needs to be able to compensate for that
#   Scope the new methods somehow...probably mix it in / extend via the class?
#   Probably shouldn't be data-* prefixing standard html attributes :)


class EditableSetFormBuilder < ActionView::Helpers::FormBuilder
  def initialize(*args)
    super *args
  end
  def text_field(method, options = {})
    SpanTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options)
  end
  
  def text_area(method, options = {})
    SpanTag.new(object_name, method, self, options.delete(:object)).to_text_area_tag(options)
  end
  
  class SpanTag < ActionView::Helpers::InstanceTag
    
    # DEFAULT_FIELD_OPTIONS = ActionView::Helpers::InstanceTagMethods::DEFAULT_FIELD_OPTIONS
    # DEFAULT_RADIO_OPTIONS = ActionView::Helpers::InstanceTagMethods::DEFAULT_RADIO_OPTIONS
    # DEFAULT_TEXT_AREA_OPTIONS = ActionView::Helpers::InstanceTagMethods::DEFAULT_TEXT_AREA_OPTIONS
      
    def to_input_field_tag(field_type, options = {})
       options = options.stringify_keys
       options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
       options = DEFAULT_FIELD_OPTIONS.merge(options)
       if field_type == "hidden"
         options.delete("size")
       end
       options["type"]  ||= field_type
       options["value"] = options.fetch("value"){ value_before_type_cast(object) } unless field_type == "file"
       options["value"] &&= html_escape(options["value"])
       add_default_name_and_id(options)
       build_span(options)
    end

    def to_radio_button_tag(tag_value, options = {})
      options = DEFAULT_RADIO_OPTIONS.merge(options.stringify_keys)
      options["type"]     = "radio"
      options["value"]    = tag_value
      if options.has_key?("checked")
        cv = options.delete "checked"
        checked = cv == true || cv == "checked"
      else
        checked = self.class.radio_button_checked?(value(object), tag_value)
      end
      options["checked"]  = "checked" if checked
      add_default_name_and_id_for_value(tag_value, options)
      build_span(options)
    end

    def to_text_area_tag(options = {})
      options = DEFAULT_TEXT_AREA_OPTIONS.merge(options.stringify_keys)
      add_default_name_and_id(options)

      if size = options.delete("size")
        options["cols"], options["rows"] = size.split("x") if size.respond_to?(:split)
      end

      build_span(options)
    end

    # def to_check_box_tag(options = {}, checked_value = "1", unchecked_value = "0")
    #   options = options.stringify_keys
    #   options["type"]     = "checkbox"
    #   options["value"]    = checked_value
    #   if options.has_key?("checked")
    #     cv = options.delete "checked"
    #     checked = cv == true || cv == "checked"
    #   else
    #     checked = self.class.check_box_checked?(value(object), checked_value)
    #   end
    #   options["checked"] = "checked" if checked
    #   add_default_name_and_id(options)
    #   hidden = tag("input", "name" => options["name"], "type" => "hidden", "value" => options['disabled'] && checked ? checked_value : unchecked_value)
    #   checkbox = tag("input", options)
    #   (hidden + checkbox).html_safe!
    # end
    # 
    # def to_boolean_select_tag(options = {})
    #   options = options.stringify_keys
    #   add_default_name_and_id(options)
    #   value = value(object)
    #   tag_text = "<select"
    #   tag_text << tag_options(options)
    #   tag_text << "><option value=\"false\""
    #   tag_text << " selected" if value == false
    #   tag_text << ">False</option><option value=\"true\""
    #   tag_text << " selected" if value
    #   tag_text << ">True</option></select>"
    # end

    # def to_select_tag(choices, options, html_options)
    #   html_options = html_options.stringify_keys
    #   add_default_name_and_id(html_options)
    #   value = value(object)
    #   selected_value = options.has_key?(:selected) ? options[:selected] : value
    #   disabled_value = options.has_key?(:disabled) ? options[:disabled] : nil
    #   content_tag("select", add_options(options_for_select(choices, :selected => selected_value, :disabled => disabled_value), options, selected_value), html_options)
    # end
    # 
    # def to_collection_select_tag(collection, value_method, text_method, options, html_options)
    #   html_options = html_options.stringify_keys
    #   add_default_name_and_id(html_options)
    #   value = value(object)
    #   disabled_value = options.has_key?(:disabled) ? options[:disabled] : nil
    #   selected_value = options.has_key?(:selected) ? options[:selected] : value
    #   content_tag(
    #     "select", add_options(options_from_collection_for_select(collection, value_method, text_method, :selected => selected_value, :disabled => disabled_value), options, value), html_options
    #   )
    # end
    # 
    # def to_grouped_collection_select_tag(collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
    #   html_options = html_options.stringify_keys
    #   add_default_name_and_id(html_options)
    #   value = value(object)
    #   content_tag(
    #     "select", add_options(option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, value), options, value), html_options
    #   )
    # end
    # 
    # def to_time_zone_select_tag(priority_zones, options, html_options)
    #   html_options = html_options.stringify_keys
    #   add_default_name_and_id(html_options)
    #   value = value(object)
    #   content_tag("select",
    #     add_options(
    #       time_zone_options_for_select(value || options[:default], priority_zones, options[:model] || ActiveSupport::TimeZone),
    #       options, value
    #     ), html_options
    #   )
    # end
    private

    def build_span(options)
      # Prepend 'data-' to each of the attributes
      attributes = options.keys.inject({}) do |attrs, attribute|
        attrs["data-#{attribute}"] = options[attribute]
        attrs
      end
      content_tag("span", html_escape(options.delete("value")), attributes)
    end
  end
end

module ApplicationHelper
  
  def title(title)
  end
  
  def editable_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array, *(args << options.merge(:builder => EditableSetFormBuilder)), &proc)
  end
  
end