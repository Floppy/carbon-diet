require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  fixtures :users
  fixtures :groups
  fixtures :group_memberships

  def test_load
    group = Group.find(1)
    assert_equal "Developers", group.name
    assert_equal "A group for the Carbon Diet developers.", group.description
    assert_equal 1, group.owner_id
    assert_equal User.find(1), group.owner
    assert group.owner.groups.include?(group)
  end

  def test_create
    # Setup test data
    owner = User.find(1)
    name = "Test Group"
    description = "This group is a test"
    # Create a new group
    group = Group.new(:name => name, :description => description, :owner => owner)
    assert group.save
    # Check that the group is there
    group = Group.find_by_name(name)
    assert_not_nil group
    # Check that the data was stored properly
    assert_equal name, group.name
    assert_equal description, group.description
    assert_equal owner, group.owner
    assert group.users.include?(owner)
    assert owner.groups.include?(group)
  end

  def test_destroy
    # Setup test data
    user3 = User.find(3)
    user5 = User.find(5)
    user6 = User.find(6)
    group = Group.find(1)
    group.add_user(user3)
    group.add_user(user5)
    group.add_user(user6)
    owner = group.owner
    assert user3.group_memberships.find_by_group_id(1)
    assert user5.group_memberships.find_by_group_id(1)
    assert user6.group_memberships.find_by_group_id(1)
    assert owner.group_memberships.find_by_group_id(1)
    # Destroy the group
    group.destroy
    # Check that the group is gone
    group = Group.find(1) rescue nil
    assert group.nil?
    # Check that the users still exist
    user3 = User.find(3)
    user5 = User.find(5)
    user6 = User.find(6)
    assert user3
    assert user5
    assert user6
    assert user3.group_memberships.find_by_group_id(1).nil?
    assert user5.group_memberships.find_by_group_id(1).nil?
    assert user6.group_memberships.find_by_group_id(1).nil?
    assert owner.group_memberships.find_by_group_id(1).nil?
    assert user3.group_memberships.empty?
    assert user5.group_memberships.empty?
    assert user6.group_memberships.empty?
  end

end
