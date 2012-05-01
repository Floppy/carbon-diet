require 'spec_helper'

describe User do

  it "should show an admin icon for administrators" do
    user = Factory(:user, :admin => true)
    user.admin.should be_true
    user.image.should == 'admin.png'
  end

  it "should show a tester icon for testers" do
    user = Factory(:user, :tester => true)
    user.admin.should be_false
    user.tester.should be_true
    user.image.should == 'tester.png'
  end

  it "should show a user icon for users" do
    user = Factory(:user)
    user.admin.should be_false
    user.tester.should be_false
    user.image.should == 'user.png'
  end

  it "should be able to assign email successfully" do
    user = Factory(:user)
    user.email = "test@example.com"
    user.email.should == "test@example.com"
  end
  
#  it "should be able to receieve reminders" do
#    user = Factory(:user_with_email)
#    user.needs_reminding?.should be_true
#    user.confirmed_email.should be_present
#    user.send_reminder.should be_true
#  end

end
