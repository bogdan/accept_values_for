require 'spec_helper'

describe "AcceptValuesFor" do
  subject { Person.new }

  it {should accept_values_for(:gender, "MALE", "FEMALE")}
  it {should_not accept_values_for(:gender, "INVALID", nil)}
end
