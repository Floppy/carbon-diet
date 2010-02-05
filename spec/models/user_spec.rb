require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  fixtures :users

  it "should show an admin icon for administrators" do
    user = User.find(1)
    user.admin.should be_true
    user.image.should == 'admin.png'
  end

  it "should show a tester icon for testers" do
    user = User.find(3)
    user.admin.should be_false
    user.tester.should be_true
    user.image.should == 'tester.png'
  end

  it "should show a user icon for users" do
    user = User.find(30)
    user.admin.should be_false
    user.tester.should be_false
    user.image.should == 'user.png'
  end

  it "should be able to assign email successfully" do
    user = User.find(1)
    user.email = "test@example.com"
    user.email.should == "test@example.com"
  end
  
  it "should be able to send reminders" do
    user = User.find(1)
    user.needs_reminding?.should be_true
    user.confirmed_email.should be_present
    user.send_reminder.should be_true
  end

end
