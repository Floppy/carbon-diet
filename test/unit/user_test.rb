require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  # Test icons

  def test_admin_icon
    user = User.find(1)
    assert user.admin
    assert user.image == 'admin.png'
  end

  def test_tester_icon
    user = User.find(3)
    assert !user.admin
    assert user.tester
    assert user.image == 'tester.png'
  end

  def test_normal_icon
    user = User.find(30)
    assert !user.admin
    assert !user.tester
    assert user.image == 'user.png'
  end

  def test_assign_email
    user = User.find(1)
    assert user.email = "test@example.com"
  end
  
  def test_send_reminder
    user = User.find(1)
    assert user.needs_reminding?
    assert user.confirmed_email
    assert user.send_reminder
  end

end
