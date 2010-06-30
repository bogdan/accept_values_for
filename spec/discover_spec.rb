require 'spec_helper'

describe "Discover" do
  
  let(:java) { Group.create!(:name => "java") }
  let(:json) { Group.create!(:name => "json") }
  let(:jbug) { Group.create!(:name => "jbug") }
  let(:ruby) { Group.create!(:name => "ruby")}
  let(:python) { Group.create!(:name => "python")}


  describe "#by_char(j)" do
    subject {
     Group.by_char("j") 
    }
    it { should_not discover(ruby) }
    it { should discover(java) }

    it { should discover(json).after(jbug).after(java) }
    it { should_not discover(ruby) }
    it { should_not discover(ruby, python) }
    it { should discover(json, jbug).after(java) }
  end
end
