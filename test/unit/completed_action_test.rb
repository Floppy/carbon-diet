require File.dirname(__FILE__) + '/../test_helper'

class CompletedActionTest < Test::Unit::TestCase
  fixtures :completed_actions
  fixtures :actions
  fixtures :users

  def test_relationships
    action = CompletedAction.find(1)
    assert action.action
    assert action.user
  end
end
