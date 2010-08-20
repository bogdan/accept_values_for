require "rubygems"
require "bundler"
Bundler.setup

require 'sqlite3'
require 'spec'
require 'spec/autorun'
require 'active_record'
require 'lib/accept_values_for'
require 'lib/discover'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.configurations = true

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do

  create_table :people do |t|
    t.string :gender
    t.integer :group_id
    t.string :name
  end

  create_table :groups do |t|
    t.string :name
  end
end

Spec::Runner.configure do |config|
  config.before(:each) do
    class ::Group < ActiveRecord::Base
      has_many :people
      
      scope :by_char, lambda { |char| 
        { 
          :conditions => ["name like ?", char + "%"],
          :order => "name"
        } 
      }
    end

    class ::Person < ActiveRecord::Base
      belongs_to :group
      validates_inclusion_of :gender, :in => ["MALE", "FEMALE"]
      validates_presence_of :group
    end
  end

  config.after(:each) do
    Object.send(:remove_const, :Person)
    Object.send(:remove_const, :Group)
  end
end
