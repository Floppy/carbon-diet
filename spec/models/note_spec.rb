require File.dirname(__FILE__) + '/../spec_helper'

describe "Note", ActiveSupport::TestCase do
  fixtures :notes
  fixtures :users
  fixtures :electricity_accounts
  fixtures :gas_accounts
  fixtures :vehicles

  it "fixture load" do
    # Load user
    user = User.find(1)
    # Check that fixture was loaded
    user.notes.size.should == 2
    user.notes[0].date.should == Date.today
    user.notes[0].note.should == "Test note 1"
    user.notes[1].date.should == Date.today
    user.notes[1].note.should == "Test note 2"
  end

  it "add note to user" do
    # Set up
    user = User.find(2)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to user
    assert(user.notes << note)
    # Check note was added
    user = User.find(2)
    user.notes.size.should == 1
    user.notes.first.note.should == "test note"
    user.notes.first.date.should == Date.today
  end

  it "add note to elec account" do
    # Set up
    account = ElectricityAccount.find(1)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to user
    assert(account.notes << note)
    # Check note was added
    user = User.find(1)
    user.electricity_accounts.first.notes.size.should == 1
    user.electricity_accounts.first.notes.first.note.should == "test note"
    user.electricity_accounts.first.notes.first.date.should == Date.today
  end

  it "add note to gas account" do
    # Set up
    account = GasAccount.find(1)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to user
    assert(account.notes << note)
    # Check note was added
    user = User.find(1)
    user.gas_accounts.first.notes.size.should == 1
    user.gas_accounts.first.notes.first.note.should == "test note"
    user.gas_accounts.first.notes.first.date.should == Date.today
  end

  it "add note to vehicle" do
    # Set up
    account = vehicles(:vehicle_for_emissions_test)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to user
    assert(account.notes << note)
    # Check note was added
    account.notes.size.should == 1
    account.notes.first.note.should == "test note"
    account.notes.first.date.should == Date.today
  end

  it "aggregate notes" do
    account = ElectricityAccount.find(1)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(account.notes << note)
    # Set up
    account = GasAccount.find(1)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(account.notes << note)
    # Set up
    account = vehicles(:vehicle_for_emissions_test)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(account.notes << note)
    # Test all notes were added
    user = User.find(1)
    user.all_notes.size.should == 5
  end

  it "remove user" do
    # Should be 2 notes in system
    Note.find(:all).size.should == 2
    # Remove user
    User.find(1).destroy
    # Should be no notes in system
    Note.find(:all).size.should == 0    
  end

  it "remove elec account" do
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(ElectricityAccount.find(1).notes << note)
    # Should be 3 notes in system
    Note.find(:all).size.should == 3
    # Remove account
    ElectricityAccount.find(1).destroy
    # Should be 2 notes in system
    Note.find(:all).size.should == 2
  end

  it "remove gas account" do
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(GasAccount.find(1).notes << note)
    # Should be 3 notes in system
    Note.find(:all).size.should == 3
    # Remove account
    GasAccount.find(1).destroy
    # Should be 2 notes in system
    Note.find(:all).size.should == 2
  end

  it "remove vehicle" do
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(vehicles(:vehicle_for_emissions_test).notes << note)
    # Should be 3 notes in system
    Note.find(:all).size.should == 3
    # Remove account
    vehicles(:vehicle_for_emissions_test).destroy
    # Should be 2 notes in system
    Note.find(:all).size.should == 2
  end

end
