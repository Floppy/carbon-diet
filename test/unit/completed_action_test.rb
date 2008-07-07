require File.dirname(__FILE__) + '/../test_helper'

class CompletedActionTest < Test::Unit::TestCase
  fixtures :completed_actions
  fixtures :actions
  fixtures :users

  def test_relationships
    action = completed_actions(:completed_actions_001)
    assert action.action
    assert action.user
  end
end
