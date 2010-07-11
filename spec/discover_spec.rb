require 'spec_helper'

describe "Discover" do


  let(:named_scope) {
      Group.by_char("j") 
  }
  let(:java) { Group.create!(:name => "java") }
  let(:json) { Group.create!(:name => "json") }
  let(:jruby) { Group.create!(:name => "jruby") }
  let(:ruby) { Group.create!(:name => "ruby")}
  let(:python) { Group.create!(:name => "python")}

  describe "#does_not_match?" do

    context "if scope contains any of the specified values" do
      subject { discover(java, ruby) }
      before(:each) do
        subject.does_not_match?(named_scope).should be_false
      end

      it { subject.failure_message_for_should_not.should == "expected #{named_scope.inspect} to not include objects: #{[java.id].inspect}, but it was. Found objects: #{named_scope.map(&:id).inspect}"}
      
    end

  end

  describe "#matches?" do
    context "if scope doesn't contain any of the specified objects" do
      subject { discover(java, ruby) }
      before(:each) do
        subject.matches?(named_scope).should be_false
      end

      it {subject.failure_message_for_should.should == "expected #{named_scope.inspect} to include objects: #{[ruby.id].inspect}, but it was not. Found objects: #{named_scope.map(&:id).inspect}"}
    end

    context "if scope contain all of the specified objects but without correct order" do
      subject { discover(jruby, java).with_exact_order }
      before(:each) do
        subject.matches?(named_scope).should be_false
      end

      it "should render error message correctly" do
        subject.failure_message_for_should.should == "expected #{named_scope.inspect} to be ordered as: #{[jruby.id, java.id].inspect}, but it was not. "
      end
    end
  end

  describe "api" do
    subject {
      named_scope
    }

    it { should discover(java) }

    it { should discover(json, java, jruby) }
    it { should discover(java, jruby, json).with_exact_order }
    it { should discover(java, json).with_exact_order }

    it { should_not discover(ruby) }
    it { should_not discover(ruby, python) }

    it { discover(ruby, java).matches?(subject).should be_false}
    it { discover(jruby, java).with_exact_order.matches?(subject).should be_false}
  end


end
