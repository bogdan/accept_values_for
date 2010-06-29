require 'spec_helper'

describe "Discover" do
  
  let(:java) { Group.create!(:name => "java") }
  let(:json) { Group.create!(:name => "json") }
  let(:jbug) { Group.create!(:name => "jbug") }
  let(:ruby) { Group.create!(:name => "ruby")}


  describe "#by_char(j)" do
    subject {
     Group.by_char("j") 
    }
    it { should_not discover(ruby) }
    it { should discover(java) }

    it { should discover(json).after(jbug).after(java) }
    it { should_not discover(jbug).after(json) }
    it { should discover(json, jbug).after(jbug) }
  end
end
