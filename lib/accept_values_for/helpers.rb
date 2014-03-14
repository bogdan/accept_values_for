module AcceptValuesFor
  module Helpers
    def accept_values_for(*args)
      Matcher.new(*args)
    end
  end
end
