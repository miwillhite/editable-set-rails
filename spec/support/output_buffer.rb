module ActionView
  # def rails_safe_buffer_class
  #   # It's important that we check ActiveSupport first,
  #   # because in Rails 2.3.6 ActionView::SafeBuffer exists
  #   # but is a deprecated proxy object.
  #   return ActiveSupport::SafeBuffer if defined?(ActiveSupport::SafeBuffer)
  #   return ActionView::SafeBuffer
  # end
  # 
  class OutputBuffer < ActiveSupport::SafeBuffer
  end
end