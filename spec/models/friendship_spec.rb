require File.dirname(__FILE__) + '/../spec_helper'

describe "Friendship", ActiveSupport::TestCase do
  fixtures :users
  fixtures :friendships

  it "add friend" do
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check unapproved status
    user1 = User.find(2)
    user2 = User.find(3)
    user2.unapproved_fans.include?(user1).should_not be_nil
    user1.unapproved_friends.include?(user2).should_not be_nil
    # Accept request
    user2.approve_friend_request(user1)
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status
    user2.unapproved_fans.include?(user1).should_not == true
    user2.fans.include?(user1).should_not be_nil
    user1.unapproved_friends.include?(user2).should_not == true
    user1.friends.include?(user2).should_not be_nil
    user2.unapproved_befriendships.empty?.should_not be_nil
    user2.approved_befriendships.empty?.should_not == true
    user1.unapproved_friendships.empty?.should_not be_nil
    user1.approved_friendships.empty?.should_not == true
  end
  
  it "add friend repeat" do
    # Add a friend relationship
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Add it again
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Reload
    user1 = User.find(2)
    user2 = User.find(3)
    # Check that the friend request has only been added once
    user2.unapproved_fans.size.should == 1
    user1.unapproved_friends.size.should == 1
    # Approve the request
    user2.approve_friend_request(user1)
    # Reload
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status - make sure there is nothing outstanding
    user2.unapproved_fans.empty?.should_not be_nil
    user1.unapproved_friends.empty?.should_not be_nil
    user2.unapproved_befriendships.empty?.should_not be_nil
    user1.unapproved_friendships.empty?.should_not be_nil
  end
  
  it "add friend repeat approval" do
    # Add a friend relationship
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Approve the request
    user2.approve_friend_request(user1)
    # Reload
    user1 = User.find(2)
    user2 = User.find(3)
    # Approve the request again
    user2.approve_friend_request(user1)
    # Reload
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status is correct
    user2.fans.size.should == 1
    user1.friends.size.should == 1
  end

  it "add friend after approval" do
    # Add a friend relationship
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Approve the request
    user2.approve_friend_request(user1)
    # Add it again
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check that the friend request has not been added
    user2.unapproved_fans.empty?.should_not be_nil
    user1.unapproved_friends.empty?.should_not be_nil
  end

  it "reject friend" do
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check unapproved status
    user1 = User.find(2)
    user2 = User.find(3)
    user2.unapproved_fans.include?(user1).should_not be_nil
    user1.unapproved_friends.include?(user2).should_not be_nil
    # Reject the request
    user2.reject_friend_request(user1)
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status
    user2.unapproved_fans.include?(user1).should_not == true
    user2.fans.include?(user1).should_not == true
    user1.unapproved_friends.include?(user2).should_not == true
    user1.friends.include?(user2).should_not == true
    user2.unapproved_befriendships.empty?.should_not be_nil
    user2.approved_befriendships.empty?.should_not be_nil
    user1.unapproved_friendships.empty?.should_not be_nil
    user1.approved_friendships.empty?.should_not be_nil
  end

  it "remove friend" do
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check unapproved status
    user1 = User.find(2)
    user2 = User.find(3)
    user2.unapproved_fans.include?(user1).should_not be_nil
    user1.unapproved_friends.include?(user2).should_not be_nil
    # Approve the request
    user2.approve_friend_request(user1)    
    user1 = User.find(2)
    user2 = User.find(3)
    # Remove the friend
    user1.remove_friend(user2)
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status
    user2.fans.include?(user1).should_not == true
    user2.friends.include?(user1).should_not be_nil
    user1.friends.include?(user2).should_not == true
    user1.fans.include?(user2).should_not be_nil
    user2.approved_befriendships.empty?.should_not be_nil
    user2.approved_friendships.empty?.should_not == true
    user1.approved_befriendships.empty?.should_not == true
    user1.approved_friendships.empty?.should_not be_nil
  end
  
end
