require 'spec_helper'

describe "Group", ActiveSupport::TestCase do
  fixtures :users
  fixtures :groups
  fixtures :group_memberships

  it "load" do
    group = Group.find(1)
    group.name.should == "Developers"
    group.description.should == "A group for the Carbon Diet developers."
    group.owner_id.should == 1
    group.owner.should == User.find(1)
    group.owner.groups.include?(group).should_not be_nil
  end

  it "create" do
    # Setup test data
    owner = User.find(1)
    name = "Test Group"
    description = "This group is a test"
    # Create a new group
    group = Group.new(:name => name, :description => description, :owner => owner)
    group.save.should_not be_nil
    # Check that the group is there
    group = Group.find_by_name(name)
    group.should_not be_nil
    # Check that the data was stored properly
    group.name.should == name
    group.description.should == description
    group.owner.should == owner
    group.users.include?(owner).should_not be_nil
    owner.groups.include?(group).should_not be_nil
  end

  it "destroy" do
    # Setup test data
    user3 = User.find(3)
    user5 = User.find(5)
    user6 = User.find(6)
    group = Group.find(1)
    group.add_user(user3)
    group.add_user(user5)
    group.add_user(user6)
    owner = group.owner
    user3.group_memberships.find_by_group_id(1).should_not be_nil
    user5.group_memberships.find_by_group_id(1).should_not be_nil
    user6.group_memberships.find_by_group_id(1).should_not be_nil
    owner.group_memberships.find_by_group_id(1).should_not be_nil
    # Destroy the group
    group.destroy
    # Check that the group is gone
    group = Group.find(1) rescue nil
    group.nil?.should_not be_nil
    # Check that the users still exist
    user3 = User.find(3)
    user5 = User.find(5)
    user6 = User.find(6)
    user3.should_not be_nil
    user5.should_not be_nil
    user6.should_not be_nil
    user3.group_memberships.find_by_group_id(1).nil?.should_not be_nil
    user5.group_memberships.find_by_group_id(1).nil?.should_not be_nil
    user6.group_memberships.find_by_group_id(1).nil?.should_not be_nil
    owner.group_memberships.find_by_group_id(1).nil?.should_not be_nil
    user3.group_memberships.empty?.should_not be_nil
    user5.group_memberships.empty?.should_not be_nil
    user6.group_memberships.empty?.should_not be_nil
  end

end
