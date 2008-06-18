require File.dirname(__FILE__) + '/../test_helper'

class ActionOverrideTest < Test::Unit::TestCase
  fixtures :action_overrides
  fixtures :actions
  fixtures :countries

  def test_relationships
    actionOverride = ActionOverride.find(1)
    assert actionOverride.action
    assert actionOverride.country
  end
end