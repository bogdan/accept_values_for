require 'spec_helper'

describe "Discover" do
  
  let(:java) { Group.create!(:name => "java") }
  let(:json) { Group.create!(:name => "json") }
  let(:jruby) { Group.create!(:name => "jruby") }
  let(:ruby) { Group.create!(:name => "ruby")}
  let(:python) { Group.create!(:name => "python")}


  describe "#by_char(j)" do
    subject {
     Group.by_char("j") 
    }
    it { should discover(java) }

    it { should discover(json, java, jruby) }
    it { should discover(java, jruby, json).with_exact_order }
    it { should discover(java, json).with_exact_order }

    it { should_not discover(ruby) }
    it { should_not discover(ruby, python) }

    it { discover(java, ruby).does_not_match?(subject).should be_false}
    it { discover(ruby, java).matches?(subject).should be_false}
    it { discover(jruby, java).with_exact_order.matches?(subject).should be_false}
  end
end
