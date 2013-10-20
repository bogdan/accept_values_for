if defined?(ActiveRecord) && !respond_to?(:discover)
  def discover(*objects) #:nodoc:
    include(*objects)
  end
  warn "#discover matcher was removed from accept_values_for. Use gem discover instead"
end

