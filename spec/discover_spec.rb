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


  describe "api" do
    subject {
      named_scope
    }

    it { should discover(java) }

    it { should discover(json, java, jruby) }

    

    it { should_not discover(ruby) }
    it { should_not discover(ruby, python) }

  end


end
