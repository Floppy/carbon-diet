require File.dirname(__FILE__) + '/../test_helper'

class ActionCategoryTest < Test::Unit::TestCase
  fixtures :action_categories
  fixtures :actions

  def test_relationships
    assert ActionCategory.find(1).actions
  end

end