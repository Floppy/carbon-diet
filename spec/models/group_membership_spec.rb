require 'spec_helper'

describe "GroupMembership", ActiveSupport::TestCase do
  fixtures :users
  fixtures :groups
  fixtures :group_memberships

  it "join" do
    # Setup test data
    user = User.find(3)
    # Join group 1
    group = Group.find(1)
    group.add_user(user)
    # Find user in group
    group = Group.find(1)
    group.users.include?(user).should_not be_nil
    user.groups.include?(group).should_not be_nil
  end

  it "repeat join" do
    # Setup test data
    user = User.find(3)
    # Join group 1 twice
    group = Group.find(1)
    group.add_user(user)
    group.add_user(user)
    # Make sure user is in group only once
    group = Group.find(1)
    group.users.uniq.should == group.users
  end

  it "leave" do
    # Setup test data
    user = User.find(3)
    # Join group 1
    group = Group.find(1)
    group.add_user(user)
    # Leave group 1
    group = Group.find(1)
    group.users.include?(user).should_not be_nil
    group.remove_user(user)
    # Check that the user is not in the group
    group = Group.find(1)
    group.users.include?(user).should_not == true
    # Check that the users account still exists
    user = User.find(3)
    user.should_not be_nil
    # Check that the user is not in the group from the other direction
    user.groups.include?(group).should_not == true
    user.group_memberships.find_by_group_id(group.id).nil?.should_not be_nil
    user.group_memberships.empty?.should_not be_nil
  end

  it "leave if not in" do
    # Setup test data
    user = User.find(3)
    # Leave group 1
    group = Group.find(1)
    group.users.include?(user).should_not == true
    group.remove_user(user)
    # Check that the user is not in the group
    group = Group.find(1)
    group.users.include?(user).should_not == true
    # Check that the users account still exists
    user = User.find(3)
    user.should_not be_nil
    # Check that the user is not in the group from the other direction
    user.groups.include?(group).should_not == true
    user.group_memberships.find_by_group_id(group.id).nil?.should_not be_nil
    user.group_memberships.empty?.should_not be_nil
  end

  it "leave owner" do
    # Setup test data
    user = User.find(1)
    group = Group.find(1)
    group.add_user(user)
    # Check that the owner is in the group
    group = Group.find(1)
    group.users.include?(user).should_not be_nil
    # Try and leave
    group.remove_user(user)
    # Check that the user is still in the group
    group = Group.find(1)
    group.users.include?(user).should_not be_nil
    user.groups.include?(group).should_not be_nil
    user.group_memberships.find_by_group_id(group.id).should_not be_nil
  end

end
