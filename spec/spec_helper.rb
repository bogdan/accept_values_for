require "accept_values_for"

require "bundler"
Bundler.require(:test)
I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.before do
    class ::Group
      include ActiveModel::Model

      attr_accessor :name
    end

    class ::Person
      include ActiveModel::Model

      attr_accessor :group, :gender
      validates_presence_of :group
      validates_inclusion_of :gender, :in => ["MALE", "FEMALE"]
    end
  end

  config.after do
    Object.send(:remove_const, :Person)
    Object.send(:remove_const, :Group)
  end

  config.expect_with(:rspec) do |c|
    c.syntax = [:should, :expect]
  end
end
