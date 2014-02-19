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

    # FIXME
    def failure_message_for_should
      result = "expected #{model.inspect} to accept values #{formatted_failed_values} for #{@attribute.inspect}, but it was not\n"
      errors.sort.each do |key, errors|
        result << "\nValue: #{key}\tErrors: #{attribute} #{errors.join(", ")}"
      end
      result
    end

    # FIXME
    def failure_message_for_should_not
      "expected #{model.inspect} to not accept values #{formatted_failed_values} for #{attribute.inspect} attribute, but was"
    end

    # FIXME
    def description
      "accept values #{values.map(&:inspect).join(", ")} for #{attribute.inspect} attribute"
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
      errors[value] = model.errors[attribute]
    end

    def no_errors?
      errors.values.all? { |e| e.empty? }
    end

    def all_errors?
      errors.values.all? { |e| !e.empty? }
    end

    # FIXME
    def formatted_failed_values
      errors.keys.sort.map(&:inspect).join(", ")
    end
  end
end
