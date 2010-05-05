if defined?(ActiveRecord)
  
  # In order to spec a complex validation for ActiveRecord models
  # Implemented accept_values_for custom matcher
  #
  # :call-seq:
  #   model.should accept_values_for(attribute, value1, value2 ...)
  #   model.should_not accept_values_for(attribute, value1, value2 ...)
  #
  # model should be a valid ActiveRecord model
  # attribute should be the model attribute name
  #
  # Use this if you want to check that model will be valid 
  # with the given values for the given attribute
  #
  # == Examples
  #
  #   user.should accept_values_for(:email, "john@example.com", "lambda@gusiev.com")
  #   user.should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com")
  #
  # IMPORTANT: passed model should be valid. Use fixtures or factories to create one.
  #
  def accept_values_for(attribute, *values)
    AcceptValuesFor.new(attribute, *values)
  end
  
end

class AcceptValuesFor  #:nodoc:

  def initialize(attribute, *values)
    @attribute = attribute
    @values = values
  end

  def matches?(model)
    @model = model
    return false unless model.is_a?(ActiveRecord::Base)
    @values.each do |value|
      model[@attribute] = value
      unless model.valid?
        @failed_value = value
        return false 
      end
    end
    return true
  end

  def failure_message_for_should
    result = "expected #{@model.inspect} to accept value #{@failed_value.inspect} for #{@attribute.inspect}, but it was not\n" 
    if @model.respond_to?(:errors) && ActiveRecord::Errors === @model.errors 
      result += "Errors: " + @model.errors.full_messages.join(", ")
    end
    result
  end

  def failure_message_for_should_not
    "expected #{@model.inspect} to not accept value #{@failed_value.inspect} for #{@attribute.inspect} attribute, but was" 
  end

  def description
    "accept values #{@values.map(&:inspect).join(', ')} for #{@attribute.inspect} attribute"
  end


end

