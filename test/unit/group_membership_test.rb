require File.dirname(__FILE__) + '/../test_helper'

class GroupMembershipTest < Test::Unit::TestCase
  fixtures :users
  fixtures :groups
  fixtures :group_memberships

  def test_join
    # Setup test data
    user = User.find(3)
    # Join group 1
    group = Group.find(1)
    group.add_user(user)
    # Find user in group
    group = Group.find(1)
    assert group.users.include?(user)
    assert user.groups.include?(group)
  end

  def test_repeat_join
    # Setup test data
    user = User.find(3)
    # Join group 1 twice
    group = Group.find(1)
    group.add_user(user)
    group.add_user(user)
    # Make sure user is in group only once
    group = Group.find(1)
    assert_equal group.users, group.users.uniq
  end

  def test_leave
    # Setup test data
    user = User.find(3)
    # Join group 1
    group = Group.find(1)
    group.add_user(user)
    # Leave group 1
    group = Group.find(1)
    assert group.users.include?(user)
    group.remove_user(user)
    # Check that the user is not in the group
    group = Group.find(1)
    assert !group.users.include?(user)
    # Check that the users account still exists
    user = User.find(3)
    assert user
    # Check that the user is not in the group from the other direction
    assert !user.groups.include?(group)
    assert user.group_memberships.find_by_group_id(group.id).nil?
    assert user.group_memberships.empty?
  end

  def test_leave_if_not_in
    # Setup test data
    user = User.find(3)
    # Leave group 1
    group = Group.find(1)
    assert !group.users.include?(user)
    group.remove_user(user)
    # Check that the user is not in the group
    group = Group.find(1)
    assert !group.users.include?(user)
    # Check that the users account still exists
    user = User.find(3)
    assert user
    # Check that the user is not in the group from the other direction
    assert !user.groups.include?(group)
    assert user.group_memberships.find_by_group_id(group.id).nil?
    assert user.group_memberships.empty?
  end

  def test_leave_owner
    # Setup test data
    user = User.find(1)
    group = Group.find(1)
    group.add_user(user)
    # Check that the owner is in the group
    group = Group.find(1)
    assert group.users.include?(user)
    # Try and leave
    group.remove_user(user)
    # Check that the user is still in the group
    group = Group.find(1)
    assert group.users.include?(user)
    assert user.groups.include?(group)
    assert user.group_memberships.find_by_group_id(group.id)
  end

end
