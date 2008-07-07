require File.dirname(__FILE__) + '/../spec_helper'

describe ActionOverride do
  fixtures :action_overrides, :actions, :countries

  before(:each) do
    @override = action_overrides(:turn_off_lights)
  end
  
  it "has a related action" do    
    @override.action.should == actions(:turn_off_lights)
  end

  it "is specific to a particular country" do    
    @override.country.should_not be_nil
  end

  it "can be paid for" do    
    @override.paid_for.should_not be_nil
  end

  it "has some content" do
    @override.content.should_not be_nil
  end

end