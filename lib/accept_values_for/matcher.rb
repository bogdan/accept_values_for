require "active_model"

module AcceptValuesFor
  class Matcher
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

    def failure_message
      result = "expected #{@model.inspect} to accept values #{formatted_failed_values} for #{@attribute.inspect}, but it was not\n"
      sorted_failed_values.each do |key|
        result << "\nValue: #{key.inspect}\tErrors: #{@attribute} #{@failed_values[key]}"
      end
      result
    end

    def failure_message_when_negated
      "expected #{@model.inspect} to not accept values #{formatted_failed_values} for #{@attribute.inspect} attribute, but was"
    end

    alias :failure_message_for_should :failure_message
    alias :failure_message_for_should_not :failure_message_when_negated

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
        model.valid?
        yield(value) if @model.respond_to?(:errors) && @model.errors.is_a?(ActiveModel::Errors)
      end
      return @failed_values.empty?
    ensure
      @model.send("#@attribute=", old_value) if defined?(old_value)
    end

    def has_validations_module?(model)
      model.class.included_modules.include?(ActiveModel::Validations)
    end

    def formatted_failed_values
      sorted_failed_values.map(&:inspect).join(", ")
    end

    def sorted_failed_values
      @failed_values.keys.sort_by(&:to_s)
    end
  end
end
