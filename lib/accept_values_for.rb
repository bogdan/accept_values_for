require "active_model"
require "rspec"

require "accept_values_for/helpers"
require "accept_values_for/matcher"

RSpec.configure do |config|
  config.include(AcceptValuesFor::Helpers)
end
