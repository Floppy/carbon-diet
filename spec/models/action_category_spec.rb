require File.dirname(__FILE__) + '/../spec_helper'

describe ActionCategory do
  fixtures :action_categories, :actions
  
  it "should have a number of actions" do
    action_categories(:electricity).actions.should_not be_nil
  end
  
end