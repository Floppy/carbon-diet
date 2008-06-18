require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < Test::Unit::TestCase
  fixtures :notes
  fixtures :users
  fixtures :electricity_accounts
  fixtures :gas_accounts
  fixtures :vehicles

  def test_fixture_load
    # Load user
    user = User.find(1)
    # Check that fixture was loaded
    assert user.notes.size == 2
    assert user.notes[0].date = Date.today
    assert user.notes[0].note = "Test note 1"
    assert user.notes[1].date = Date.today
    assert user.notes[1].note = "Test note 2"
  end

  def test_add_note_to_user
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
    assert user.notes.size == 1
    assert user.notes.first.note = "test note"
    assert user.notes.first.date = Date.today
  end

  def test_add_note_to_elec_account
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
    assert user.electricity_accounts.first.notes.size == 1
    assert user.electricity_accounts.first.notes.first.note = "test note"
    assert user.electricity_accounts.first.notes.first.date = Date.today
  end

  def test_add_note_to_gas_account
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
    assert user.gas_accounts.first.notes.size == 1
    assert user.gas_accounts.first.notes.first.note = "test note"
    assert user.gas_accounts.first.notes.first.date = Date.today
  end

  def test_add_note_to_vehicle
    # Set up
    account = Vehicle.find(1)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to user
    assert(account.notes << note)
    # Check note was added
    user = User.find(1)
    assert user.vehicles.first.notes.size == 1
    assert user.vehicles.first.notes.first.note = "test note"
    assert user.vehicles.first.notes.first.date = Date.today
  end

  def test_aggregate_notes
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
    account = Vehicle.find(1)
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(account.notes << note)
    # Test all notes were added
    user = User.find(1)
    assert user.all_notes.size == 5
  end

  def test_remove_user
    # Should be 2 notes in system
    assert Note.find(:all).size == 2
    # Remove user
    User.find(1).destroy
    # Should be no notes in system
    assert Note.find(:all).size == 0    
  end

  def test_remove_elec_account
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(ElectricityAccount.find(1).notes << note)
    # Should be 3 notes in system
    assert Note.find(:all).size == 3
    # Remove account
    ElectricityAccount.find(1).destroy
    # Should be 2 notes in system
    assert Note.find(:all).size == 2
  end

  def test_remove_gas_account
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(GasAccount.find(1).notes << note)
    # Should be 3 notes in system
    assert Note.find(:all).size == 3
    # Remove account
    GasAccount.find(1).destroy
    # Should be 2 notes in system
    assert Note.find(:all).size == 2
  end

  def test_remove_vehicle
    # Create note
    note = Note.new
    note.note = "test note"
    note.date = Date.today
    # Store, attached to account
    assert(Vehicle.find(1).notes << note)
    # Should be 3 notes in system
    assert Note.find(:all).size == 3
    # Remove account
    Vehicle.find(1).destroy
    # Should be 2 notes in system
    assert Note.find(:all).size == 2
  end

end
