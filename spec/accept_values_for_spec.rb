require 'spec_helper'

describe "AcceptValuesFor" do
  subject { Person.new(:gender => "MALE", :group => Group.new(:name => "Primary")) }

  it {should accept_values_for(:gender, "MALE", "FEMALE")}
  it {should_not accept_values_for(:gender, "INVALID", nil)}
  it { should_not accept_values_for(:group, nil) }
  it { should accept_values_for(:group, Group.new) }

  it "should have custom condition for should_not" do
    accept_values_for(:gender, "INVALID", "MALE").does_not_match?(subject).should be_false
  end
  
  it 'should properly display failure message for should' do
    avf = AcceptValuesFor.new(:gender, 'INVALID')
    avf.matches?(Person.new)
    avf.failure_message_for_should.should =~ /expected/
  end
end