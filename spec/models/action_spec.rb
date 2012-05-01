require 'spec_helper'

describe "Action", ActiveSupport::TestCase do
  fixtures :actions
  fixtures :action_categories
  fixtures :action_overrides
  fixtures :countries

  it "relationships" do
    action = actions(:turn_off_lights)
    action.action_category.should_not be_nil
    action.action_overrides.should_not be_nil
    action.completed_actions.should_not be_nil
    action.users.should_not be_nil
  end
  
  it "override" do
    action = actions(:turn_off_lights)
    action.load_random_override(countries(:uk).id)
    action.content.should == action_overrides(:turn_off_lights).content
  end
  
end