require File.dirname(__FILE__) + '/../test_helper'

class ActionTest < Test::Unit::TestCase
  fixtures :actions
  fixtures :action_categories
  fixtures :action_overrides

  def test_relationships
    action = Action.find(1)
    assert action.action_category
    assert action.action_overrides
    assert action.completed_actions
    assert action.users
  end
  
  def test_override
    action = Action.find(1)
    action.load_random_override(1)
    assert action.content == ActionOverride.find(1).content
  end
  
end