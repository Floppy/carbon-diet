require 'spec_helper'

describe Friendship do
  fixtures :users

  describe 'adding friends' do

    before :each do
      @alice = users(:alice)
      @bob = users(:bob)
      @alice.add_friend(@bob)
    end

    it "adds a friend correctly" do
      # Bob should appear in Alice's unapproved friends list
      @alice.friends.should_not include(@bob)
      @alice.unapproved_friends.should include(@bob)
      # Alice should appear in Bob's unapproved fans list
      @bob.fans.should_not include(@alice)
      @bob.unapproved_fans.should include(@alice)
      # Bob accepts request
      @bob.approve_friend_request(@alice)
      # Reload to clear AR association caches
      @alice.reload
      @bob.reload
      # Bob should appear in Alice's approved friends list
      @alice.unapproved_friends.should_not include(@bob)
      @alice.friends.should include(@bob)
      # Alice should appear in Bob's approved fans list
      @bob.unapproved_fans.should_not include(@alice)
      @bob.fans.should include(@alice)
    end
  
    it "is only allowed once" do
      # Add a friend relationship again
      @alice.add_friend(@bob)
      # Check that the friend request has only been added once
      @bob.unapproved_fans.size.should == 1
      @alice.unapproved_friends.size.should == 1
      # Approve the request
      @bob.approve_friend_request(@alice)
      # Reload to clear AR association caches
      @alice.reload
      @bob.reload
      # Check friend list status - make sure there is nothing outstanding
      @bob.unapproved_fans.should be_empty
      @alice.unapproved_friends.should be_empty
    end
  
    it "can only be approved once" do
      # Approve the request twice
      @bob.approve_friend_request(@alice)
      @bob.approve_friend_request(@alice)
      # Check friend list status is correct
      @bob.fans.should == [@alice]
      @alice.friends.should == [@bob]
    end

    it "can be rejected" do
      # Reject the request
      @bob.reject_friend_request(@alice)
      # Alice should not be in Bob's lists any more
      @bob.unapproved_fans.should_not include(@alice)
      @bob.fans.should_not include(@alice)
      # Bob should also not appear in Alice's lists
      @alice.unapproved_friends.should_not include(@bob)
      @alice.friends.should_not include(@bob)
    end

  end

  describe 'with existing friends' do

    before :each do
      @alice = users(:alice)
      @bob = users(:bob)
      @alice.add_friend(@bob)
      @bob.approve_friend_request(@alice)    
    end

    it "cannot re-add" do
      # Add friend again
      @alice.add_friend(@bob)
      # Check that the friend request has not been added
      @bob.unapproved_fans.should be_empty
      @alice.unapproved_friends.should be_empty
    end

    it "can remove friend" do
      # Remove the friend
      @alice.remove_friend(@bob)
      # Alice should not be in Bob's lists any more
      @bob.unapproved_fans.should_not include(@alice)
      @bob.fans.should_not include(@alice)
      # Bob should also not appear in Alice's lists
      @alice.unapproved_friends.should_not include(@bob)
      @alice.friends.should_not include(@bob)
    end
  
  end

end