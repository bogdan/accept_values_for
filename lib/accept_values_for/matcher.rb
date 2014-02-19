module AcceptValuesFor
  class Matcher
    attr_reader :attribute, :values, :model

    def initialize(attribute, *values)
      @attribute = attribute
      @values = values
    end

    def matches?(model)
      base_matches?(model) do |value|
        unless model.errors[attribute].to_a.empty?
          failed_values[value] = Array(model.errors[attribute]).join(", ")
        end
      end
    end

    def does_not_match?(model)
      base_matches?(model) do |value|
        if model.errors[attribute].to_a.empty?
          failed_values[value] = nil
        end
      end
    end

    def failure_message_for_should
      result = "expected #{model.inspect} to accept values #{formatted_failed_values} for #{@attribute.inspect}, but it was not\n"
      failed_values.keys.sort.each do |key|
        result << "\nValue: #{key}\tErrors: #{attribute} #{failed_values[key]}"
      end
      result
    end

    def failure_message_for_should_not
      "expected #{model.inspect} to not accept values #{formatted_failed_values} for #{attribute.inspect} attribute, but was"
    end

    def description
      "accept values #{values.map(&:inspect).join(', ')} for #{attribute.inspect} attribute"
    end

    private
    def base_matches?(model)
      @model = model
      old_value = model.send(attribute)
      values.each do |value|
        model.send("#{attribute}=", value)
        model.valid?
        yield(value)
      end
      return failed_values.empty?
    ensure
      model.send("#{attribute}=", old_value) if defined?(old_value)
    end

    def formatted_failed_values
      failed_values.keys.sort.map(&:inspect).join(", ")
    end

    def failed_values
      @failed_values ||= {}
    end
  end
end
