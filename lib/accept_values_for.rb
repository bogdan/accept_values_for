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

  def initialize(attributes, *values)
    if attributes.kind_of?(Array)
      @attribute, @label = attributes
    else
      @attribute = attributes
    end
    @values = values

  end

  def matches?(model)
    @model = model
    return false unless model.class.included_modules.include?(ActiveModel::Validations)
    old_value = @model.send(@attribute)
    @values.each do |value|
      model.send("#{@attribute}=", value)
      model.valid?
      unless model.errors[@attribute].to_a.empty?
        @failed_value = value
        return false
      end
    end
    return true
  ensure
    @model.send("#{@attribute}=", old_value) if defined?(old_value)
  end

  def does_not_match?(model)
    @model = model
    return false unless model.class.included_modules.include?(ActiveModel::Validations)
    old_value = @model.send(@attribute)
    @values.each do |value|
      model.send("#{@attribute}=", value)
      model.valid?
      if model.errors[@attribute].to_a.empty?
        @failed_value = value
        return false
      end
    end
    return true
  ensure
    @model.send("#{@attribute}=", old_value) if defined?(old_value)
  end

  def failure_message_for_should
    result = "expected #{@model.inspect} to accept value #{@failed_value.inspect} for #{@attribute.inspect}, but it was not\n"
    if @model.respond_to?(:errors) && @model.errors.is_a?(ActiveModel::Errors)
      result += "Errors: #{@attribute} " + Array(@model.errors[@attribute]).join(", ")
    end
    result
  end

  def failure_message_for_should_not
    "expected #{@model.inspect} to not accept value #{@failed_value.inspect} for #{@attribute.inspect} attribute, but was"
  end

  def description
    "accept values #{@label || @values.map(&:inspect).join(', ')} for #{@attribute.inspect} attribute"
  end

end

