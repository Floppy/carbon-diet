require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :friendships

  def test_add_friend
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check unapproved status
    user1 = User.find(2)
    user2 = User.find(3)
    assert user2.unapproved_fans.include?(user1)
    assert user1.unapproved_friends.include?(user2)
    # Accept request
    user2.approve_friend_request(user1)
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status
    assert !user2.unapproved_fans.include?(user1)
    assert user2.fans.include?(user1)
    assert !user1.unapproved_friends.include?(user2)
    assert user1.friends.include?(user2)
    assert user2.unapproved_befriendships.empty?
    assert !user2.approved_befriendships.empty?
    assert user1.unapproved_friendships.empty?
    assert !user1.approved_friendships.empty?
  end
  
  def test_add_friend_repeat
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
    assert user2.unapproved_fans.size == 1
    assert user1.unapproved_friends.size == 1
    # Approve the request
    user2.approve_friend_request(user1)
    # Reload
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status - make sure there is nothing outstanding
    assert user2.unapproved_fans.empty?
    assert user1.unapproved_friends.empty?
    assert user2.unapproved_befriendships.empty?
    assert user1.unapproved_friendships.empty?
  end
  
  def test_add_friend_repeat_approval
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
    assert user2.fans.size == 1
    assert user1.friends.size == 1
  end

  def test_add_friend_after_approval
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
    assert user2.unapproved_fans.empty?
    assert user1.unapproved_friends.empty?
  end

  def test_reject_friend
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check unapproved status
    user1 = User.find(2)
    user2 = User.find(3)
    assert user2.unapproved_fans.include?(user1)
    assert user1.unapproved_friends.include?(user2)
    # Reject the request
    user2.reject_friend_request(user1)
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status
    assert !user2.unapproved_fans.include?(user1)
    assert !user2.fans.include?(user1)
    assert !user1.unapproved_friends.include?(user2)
    assert !user1.friends.include?(user2)
    assert user2.unapproved_befriendships.empty?
    assert user2.approved_befriendships.empty?
    assert user1.unapproved_friendships.empty?
    assert user1.approved_friendships.empty?
  end

  def test_remove_friend
    user1 = User.find(2)
    user2 = User.find(3)
    user1.add_friend(user2)
    # Check unapproved status
    user1 = User.find(2)
    user2 = User.find(3)
    assert user2.unapproved_fans.include?(user1)
    assert user1.unapproved_friends.include?(user2)
    # Approve the request
    user2.approve_friend_request(user1)    
    user1 = User.find(2)
    user2 = User.find(3)
    # Remove the friend
    user1.remove_friend(user2)
    user1 = User.find(2)
    user2 = User.find(3)
    # Check friend list status
    assert !user2.fans.include?(user1)
    assert user2.friends.include?(user1)
    assert !user1.friends.include?(user2)
    assert user1.fans.include?(user2)
    assert user2.approved_befriendships.empty?
    assert !user2.approved_friendships.empty?
    assert !user1.approved_befriendships.empty?
    assert user1.approved_friendships.empty?
  end
  
end
