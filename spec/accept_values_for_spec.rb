require 'spec_helper'

describe "AcceptValuesFor" do
  let :person do
    Person.new(
      :gender => "MALE",
      :group  => Group.new(:name => "Primary"),
      :name   => "alice"
    )
  end
  subject &:person

  it "should have custom condition for should_not" do
    accept_values_for(:gender, "INVALID", "MALE").does_not_match?(subject).should be_false
  end

  describe "#matches?" do
    let(:matcher) { accept_values_for(:gender, "INVALID") }

    it "should return false if one of values is not accepted" do
      matcher.matches?(subject).should be_false
      matcher.failure_message_for_should.should == "expected #{subject.inspect} to accept value \"INVALID\" for :gender, but it was not\n" +
        "Errors: gender is not included in the list"
    end

    it "should assign the old value for attribute after #matches? " do
      matcher.matches?(subject).should be_false
      subject.gender.should == "MALE"
    end
  end

  describe "api" do
    it { should accept_values_for(:gender, "MALE", "FEMALE")}
    it { should_not accept_values_for(:gender, "INVALID", nil)}
    it { should_not accept_values_for(:group, nil) }
    it { should accept_values_for(:group, Group.new) }
    it { should_not accept_values_for([:name, "longer than 64 characters"], "a" * 65)}
  end
end
