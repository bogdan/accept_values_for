require 'spec_helper'

describe "AcceptValuesFor" do
  subject { Person.new(:gender => "MALE", :group => Group.new(:name => "Primary")) }


  it "should have custom condition for should" do
    accept_values_for(:gender, "INVALID", "MALE").matches?(subject).should be_false
  end

  it "should have custom condition for should_not" do
    accept_values_for(:gender, "INVALID", "MALE").does_not_match?(subject).should be_true
  end

  describe "#matches?" do
    let(:matcher) { accept_values_for(:gender, "INVALID", "WRONG") }

    it "should return false if one of values is not accepted" do
      matcher.matches?(subject).should be_false
      matcher.failure_message_for_should.should == "expected #{subject.inspect} to accept values [\"INVALID\", \"WRONG\"] for :gender, but it was not\n\nValue: INVALID\tErrors: gender is not included in the list\nValue: WRONG\tErrors: gender is not included in the list"
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
  end
end
