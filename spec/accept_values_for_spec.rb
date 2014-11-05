require 'spec_helper'

describe "AcceptValuesFor" do
  let(:person) { Person.new(:gender => "MALE", :group => Group.new(:name => "Primary")) }
  let(:accept_values_for_object) { accept_values_for(:gender, *values) }

  describe "#matches?" do
    subject { accept_values_for_object.matches?(person) }
    context "when value is accepted" do
      let(:values) { ['MALE'] }
      it { should eq(true) }
    end
    context "when value is not accepted" do
      let(:values) { ['INVALID'] }
      it { should eq(false) }
      it "should have correct failure message for should" do
        accept_values_for_object.matches?(person)
        accept_values_for_object.failure_message_for_should.should == "expected #{person.inspect} to accept values \"INVALID\" for :gender, but it was not\n\nValue: INVALID\tErrors: gender is not included in the list"
      end
      it "should assign the old value for attribute" do
        accept_values_for_object.matches?(person)
        person.gender.should == 'MALE'
      end
    end
    context "when 2 values are not accepted" do
      context "when classes of 2 values are same" do
        let(:values) { ["INVALID", "WRONG"] }
        it { should eq(false) }
        it "should have correct failure message for should" do
          accept_values_for_object.matches?(person)
          accept_values_for_object.failure_message_for_should.should == "expected #{person.inspect} to accept values \"INVALID\", \"WRONG\" for :gender, but it was not\n\nValue: INVALID\tErrors: gender is not included in the list\nValue: WRONG\tErrors: gender is not included in the list"
        end
      end
      context "when classes of 2 values are not same" do
        let(:values) { ["INVALID", 10] }
        it { should eq(false) }
        it "should have correct failure message for should" do
          accept_values_for_object.matches?(person)
          accept_values_for_object.failure_message_for_should.should == "expected #{person.inspect} to accept values 10, \"INVALID\" for :gender, but it was not\n\nValue: 10\tErrors: gender is not included in the list\nValue: INVALID\tErrors: gender is not included in the list"
        end
      end
    end
    context "when one value is accept and other is not" do
      let(:values) { ['MALE', 'INVALID'] }
      it { should eq(false) }
    end
  end

  describe "#does_not_match?" do
    subject { accept_values_for_object.does_not_match?(person) }
    context "when value is not accepted" do
      let(:values) { ['INVALID'] }
      it { should eq(true) }
    end
    context "when value is accepted" do
      let(:values) { ['FEMALE'] }
      it { should eq(false) }
      it "should have correct failure message for should" do
        accept_values_for_object.does_not_match?(person)
        accept_values_for_object.failure_message_for_should_not.should == "expected #{person.inspect} to not accept values \"FEMALE\" for :gender attribute, but was"
      end
      it "should assign the old value for attribute" do
        accept_values_for_object.does_not_match?(person)
        person.gender.should == 'MALE'
      end
    end
    context "when 2 values are accepted" do
      context "when classes of 2 values are same" do
        let(:values) { ["FEMALE", "MALE"] }
        it { should eq(false) }
        it "should have correct failure message for should" do
          accept_values_for_object.does_not_match?(person)
          accept_values_for_object.failure_message_for_should_not.should == "expected #{person.inspect} to not accept values \"FEMALE\", \"MALE\" for :gender attribute, but was"
        end
      end
      context "when classes of 2 values are not same" do
        let(:values) { [:male, "FEMALE"] }
        it { should eq(false) }
        it "should have correct failure message for should" do
          accept_values_for_object.does_not_match?(person)
          accept_values_for_object.failure_message_for_should_not.should == "expected #{person.inspect} to not accept values \"FEMALE\", :male for :gender attribute, but was"
        end
      end
    end
    context "when one value is accept and other is not" do
      let(:values) { ['MALE', 'INVALID'] }
      it { should eq(false) }
    end
  end

  describe "api" do
    subject { person }
    it { should accept_values_for(:gender, "MALE", "FEMALE")}
    it { should_not accept_values_for(:gender, "INVALID", nil)}
    it { should_not accept_values_for(:group, nil) }
    it { should accept_values_for(:group, Group.new) }
  end
end
