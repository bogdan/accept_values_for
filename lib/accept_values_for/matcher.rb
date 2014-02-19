module AcceptValuesFor
  class Matcher
    attr_reader :attribute, :values, :model, :errors

    def initialize(attribute, *values)
      @attribute = attribute
      @values = values
    end

    def matches?(model)
      test(model)
      no_errors?
    end

    def does_not_match?(model)
      test(model)
      all_errors?
    end

    def failure_message_for_should
      message = <<-MSG

expected to accept values: #{values.inspect}
                 accepted: #{accepted_values.inspect}

Errors:
      MSG

      pad = rejected_values.map { |v| v.inspect.length }.max
      errors.each do |value, value_errors|
        padded_value = value.inspect.rjust(pad, " ")
        message << "  #{padded_value}: #{value_errors.inspect}\n"
      end

      message << "\n"
    end

    def failure_message_for_should_not
      <<-MSG

expected to reject values: #{values.inspect}
                 rejected: #{rejected_values.inspect}

      MSG
    end

    def description
      "accept values #{values.inspect} for #{attribute.inspect} attribute"
    end

    private

    def test(model)
      @model = model
      @errors = {}

      original_value = @model.send(attribute)

      values.each do |value|
        test_value(model, value)
      end
    ensure
      @model.send("#{attribute}=", original_value)
    end

    def test_value(model, value)
      model.send("#{attribute}=", value)
      model.valid?
      value_errors = model.errors[attribute]
      errors[value] = value_errors unless value_errors.empty?
    end

    def no_errors?
      errors.empty?
    end

    def all_errors?
      errors.size == values.size
    end

    def accepted_values
      values - rejected_values
    end

    def rejected_values
      errors.keys
    end
  end
end
