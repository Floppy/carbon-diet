require File.dirname(__FILE__) + '/../test_helper'

class ActionTest < Test::Unit::TestCase
  fixtures :actions
  fixtures :action_categories
  fixtures :action_overrides

  def test_relationships
    action = actions(:turn_off_lights)
    assert action.action_category
    assert action.action_overrides
    assert action.completed_actions
    assert action.users
  end
  
  def test_override
    action = actions(:turn_off_lights)
    action.load_random_override(1)
    assert action.content == action_overrides(:turn_off_lights).content
  end
  
end