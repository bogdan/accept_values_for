require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'active_record'
require 'lib/accept_values_for'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.configurations = true

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do

  create_table :people do |t|
    t.string :gender
  end
end

Spec::Runner.configure do |config|
  config.before(:each) do
    class ::Person < ActiveRecord::Base
      validates_inclusion_of :gender, :in => ["MALE", "FEMALE"]
    end
  end

  config.after(:each) do
    Object.send(:remove_const, :Person)
  end
end
