if defined?(ActiveRecord)

  def discover(*objects) #:nodoc:
    include(*objects)
  end
  warn "#discover matcher was removed from accept_values_for. Use rspec builtin include instead."
end

