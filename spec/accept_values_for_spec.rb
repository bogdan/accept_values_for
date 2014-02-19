require 'spec_helper'

describe "AcceptValuesFor" do
  let(:person) { Person.new(:name => "John", :gender => "MALE") }
  let(:accept_values_for_object) { accept_values_for(:gender, *values) }

  describe "#matches?" do
    subject { accept_values_for_object.matches?(person) }
    context "when value is accepted" do
      let(:values) { ['MALE'] }
      it { should be_true }
    end
    context "when value is not accepted" do
      let(:values) { ['INVALID'] }
      it { should be_false }
      it "should have correct failure message for should" do
        accept_values_for_object.matches?(person)
        accept_values_for_object.failure_message_for_should.should == <<-MSG

expected to accept values: ["INVALID"]
                 accepted: []

Errors:
  "INVALID": ["is not included in the list"]

        MSG
      end
      it "should assign the old value for attribute" do
        accept_values_for_object.matches?(person)
        person.gender.should == 'MALE'
      end
    end
    context "when 2 values are not accepted" do
      let(:values) { ["INVALID", "WRONG"] }
      it { should be_false }
      it "should have correct failure message for should" do
        accept_values_for_object.matches?(person)
        accept_values_for_object.failure_message_for_should.should == <<-MSG

expected to accept values: ["INVALID", "WRONG"]
                 accepted: []

Errors:
  "INVALID": ["is not included in the list"]
    "WRONG": ["is not included in the list"]

        MSG
      end
    end
    context "when one value is accept and other is not" do
      let(:values) { ['MALE', 'INVALID'] }
      it { should be_false }
      it "should have correct failure message for should" do
        accept_values_for_object.matches?(person)
        accept_values_for_object.failure_message_for_should.should == <<-MSG

expected to accept values: ["MALE", "INVALID"]
                 accepted: ["MALE"]

Errors:
  "INVALID": ["is not included in the list"]

        MSG
      end
    end
  end

  describe "#does_not_match?" do
    subject { accept_values_for_object.does_not_match?(person) }
    context "when value is not accepted" do
      let(:values) { ['INVALID'] }
      it { should be_true }
    end
    context "when value is accepted" do
      let(:values) { ['FEMALE'] }
      it { should be_false }
      it "should have correct failure message for should" do
        accept_values_for_object.does_not_match?(person)
        accept_values_for_object.failure_message_for_should_not.should == <<-MSG

expected to reject values: ["FEMALE"]
                 rejected: []

        MSG
      end
      it "should assign the old value for attribute" do
        accept_values_for_object.does_not_match?(person)
        person.gender.should == 'MALE'
      end
    end
    context "when 2 values are accepted" do
      let(:values) { ["FEMALE", "MALE"] }
      it { should be_false }
      it "should have correct failure message for should" do
        accept_values_for_object.does_not_match?(person)
        accept_values_for_object.failure_message_for_should_not.should == <<-MSG

expected to reject values: ["FEMALE", "MALE"]
                 rejected: []

        MSG
      end
    end
    context "when one value is accept and other is not" do
      let(:values) { ['MALE', 'INVALID'] }
      it { should be_false }
    end
  end

  describe "api" do
    subject { person }
    it { should accept_values_for(:gender, "MALE", "FEMALE")}
    it { should_not accept_values_for(:gender, "INVALID", nil)}
    it { should_not accept_values_for(:name, nil) }
    it { should accept_values_for(:name, "John") }
  end
end
