require 'spec_helper'

describe "CompletedAction", ActiveSupport::TestCase do
  fixtures :completed_actions
  fixtures :actions
  fixtures :users

  it "relationships" do
    action = completed_actions(:completed_actions_001)
    action.action.should_not be_nil
    action.user.should_not be_nil
  end
end
