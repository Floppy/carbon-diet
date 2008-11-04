require File.dirname(__FILE__) + '/../spec_helper'

describe ActionOverride do
  fixtures :action_overrides, :actions, :countries

  before(:each) do
    @override = action_overrides(:turn_off_lights)
  end
  
  it "has a related action" do    
    @override.action.should == actions(:turn_off_lights)
  end

  it "can be specific to a particular country" do    
    @override.should respond_to(:country)
  end

  it "can be paid for" do    
    @override.should respond_to(:paid_for)
  end

  it "has some content" do
    @override.content.should_not be_nil
  end

  it "must have content and related action defined to be valid" do
    x = ActionOverride.create
    x.should_not be_valid
    x = ActionOverride.create(:content => "test")
    x.should_not be_valid
    x = ActionOverride.create(:action_id => 1)
    x.should_not be_valid
    x = ActionOverride.create(:content => "test", :action_id => 1)
    x.should be_valid
  end  
  
end