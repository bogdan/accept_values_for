require "accept_values_for"

Bundler.require(:test)

class Person
  include ActiveModel::Validations

  attr_accessor :name, :gender

  def initialize(attributes = {})
    attributes.each do |name, value|
      self.send("#{name}=", value)
    end
  end

  validates_presence_of :name
  validates_inclusion_of :gender, :in => ["MALE", "FEMALE"]
end
