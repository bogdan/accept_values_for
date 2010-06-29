if defined?(ActiveRecord)

  # In order to spec a complex validation for ActiveRecord models
  # Implemented accept_values_for custom matcher
  #
  # :call-seq:
  #   model.should accept_values_for(attribute, value1, value2 ...)
  #   model.should_not accept_values_for(attribute, value1, value2 ...)
  #
  # model should be an instance of ActiveRecord::Base
  # attribute should be the model attribute name
  #
  # Use this if you want to check that model should not have errors 
  # on specified attribute with the given values
  #
  # == Examples
  #
  #   user.should accept_values_for(:email, "john@example.com", "lambda@gusiev.com")
  #   user.should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com")
  #
  #
  def discover(*objects)
    Rspec::Discover.new(*objects)
  end

end

module Rspec
  class Discover  #:nodoc:

    def initialize(*objects)
      @objects = objects
      @after_objects = []
    end

    def after(object)
      @after_objects << object
      self
    end

    def matches?(scope)
      @scope = scope
      return valid_findness? && valid_indexes?
    end

    def failure_message_for_should
      result = "expected #{@scope.inspect} to include objects: #{@objects.inspect} " 
      result += after_string
      result += ",but it was not.\n" 
      result += found_objects_string
      result
    end

    def failure_message_for_should_not
      result = "expected #{@scope.inspect} to include objects: #{@objects.inspect} " 
      result += after_string
      result += ", but it was." 
      result += found_objects_string
      result
    end


    def description
      "discover #{@objects.map(&:inspect).join(', ')} " + after_string
    end

    protected

    def valid_findness?
      !((@objects + @after_objects).any?{|o| @scope.index(o) == nil})
    end

    def valid_indexes?
      return true if @after_objects.blank?
      min_index = @objects.map{|o| @scope.index(o)}.min
      index_range = @after_objects.map{|o| @scope.index(o)}.reverse + [min_index]
      index_range == index_range.sort
    end

    def invalid_scope_string
      "expected #{scope} to be an instance of ActiveRecord::NamedScope::Scope but it wasn't"
    end

    def found_objects_string
      "Found objects: " + @scope.map(&:id).inspect
    end


    def after_string
      return "" if @after_objects.blank?
      result = ""
      @after_objects.each do |after_object|
        result += "after: #{after_object.inspect} "
      end
      result
    end

  end
end


