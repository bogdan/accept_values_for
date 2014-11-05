require "accept_values_for"

require "bundler"
Bundler.require(:test)
I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => ":memory:"
    )

    ActiveRecord::Schema.verbose = false
    ActiveRecord::Schema.define(:version => 1) do
      create_table :groups do |t|
        t.string :name
      end

      create_table :people do |t|
        t.integer :group_id
        t.string :gender
        t.string :name
      end
    end
  end

  config.before do
    class ::Group < ActiveRecord::Base
      has_many :people
    end

    class ::Person < ActiveRecord::Base
      belongs_to :group

      validates_presence_of :group
      validates_inclusion_of :gender, :in => ["MALE", "FEMALE", :male, :female]
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
