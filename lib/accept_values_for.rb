if defined?(ActiveModel)
  
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
  def accept_values_for(attribute, *values)
    AcceptValuesFor.new(attribute, *values)
  end
  
  
end

class AcceptValuesFor  #:nodoc:

  def initialize(attribute, *values)
    @attribute = attribute
    @values = values
    @failed_values = {}
  end

  def matches?(model)
    base_matches?(model) do |value|
      unless model.errors[@attribute].to_a.empty?
        @failed_values[value] = Array(model.errors[@attribute]).join(", ")
      end
    end
  end

  def does_not_match?(model)
    base_matches?(model) do |value|
      if model.errors[@attribute].to_a.empty?
        @failed_values[value] = nil
      end
    end
  end

  def failure_message_for_should
    result = "expected #{@model.inspect} to accept values #{@failed_values.keys.inspect} for #{@attribute.inspect}, but it was not\n"
    @failed_values.each do |key, value|
      result << "\nValue: #{key}\tErrors: #{@attribute} #{value}"
    end
    result
  end

  def failure_message_for_should_not
    "expected #{@model.inspect} to not accept values #{@failed_values.keys.inspect} for #{@attribute.inspect} attribute, but was"
  end

  def description
    "accept values #{@values.map(&:inspect).join(', ')} for #{@attribute.inspect} attribute"
  end

  private
  def base_matches?(model)
    @model = model
    !has_validations_module?(model) and return false
    old_value = @model.send(@attribute)
    @values.each do |value|
      model.send("#@attribute=", value)
      next if model.valid?
      yield(value) if @model.respond_to?(:errors) && @model.errors.is_a?(ActiveModel::Errors)
    end
    return @failed_values.empty?
  ensure
    @model.send("#@attribute=", old_value) if defined?(old_value)
  end

  def has_validations_module?(model)
    model.class.included_modules.include?(ActiveModel::Validations)
  end

end

