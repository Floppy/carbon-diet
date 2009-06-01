require 'digest/sha2'
require 'mini_magick'

class User < ActiveRecord::Base
  # Relationships
  belongs_to :country
  has_many :electricity_accounts
  has_many :electricity_readings, :through => :electricity_accounts
  has_many :gas_accounts
  has_many :gas_readings, :through => :gas_accounts
  has_many :vehicles
  has_many :vehicle_fuel_purchases, :through => :vehicles
  has_many :flights
  has_many :completed_actions
  has_many :actions, :through => :completed_actions
  has_many :group_memberships
  has_many :groups, :through => :group_memberships
  has_many :group_invitations
  has_many :sent_group_invitations, :class_name => 'GroupInvitation', :foreign_key => 'inviter_id'
  has_many :owned_groups, :class_name => 'Group', :foreign_key => 'owner_id'
  has_many :notes, :as => :notatable
  has_many :authored_comments, :class_name => 'Comment', :order => "created_at DESC"
  has_many :comments, :as => :commentable, :order => "created_at DESC"
  # Friendships - aargh, complicated!
  has_many :approved_friendships,
    :foreign_key =>       'user_id',
    :class_name =>        'Friendship',
    :conditions =>        [ "approved = TRUE" ]
  has_many :unapproved_friendships,
    :foreign_key =>       'user_id',
    :class_name =>        'Friendship',
    :conditions =>        [ "approved = FALSE" ]
  has_many :approved_befriendships,
    :foreign_key =>       'friend_id',
    :class_name =>        'Friendship',
    :conditions =>        [ "approved = TRUE" ]
  has_many :unapproved_befriendships,
    :foreign_key =>       'friend_id',
    :class_name =>        'Friendship',
    :conditions =>        [ "approved = FALSE" ]
  has_many :friends,
    :through => :approved_friendships,
    :source => :friend
  has_many :unapproved_friends,
    :through => :unapproved_friendships,
    :source => :friend
  has_many :fans,
    :through => :approved_befriendships,
    :source => :user
  has_many :unapproved_fans,
    :through => :unapproved_befriendships,
    :source => :user
      
  # Validation
  validates_uniqueness_of :login
  validates_format_of :email, :with => /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :login, :with => /^\w+$/i
  validates_numericality_of :people_in_household
  # Attributes
  attr_accessible :display_name, :country_id, :public, :reminder_frequency 
  attr_accessible :reminded_at, :email, :notify_friend_requests, :notify_profile_comments, :people_in_household

  def get_guid!
    if self.guid.nil?
      self.guid = Digest::SHA256.hexdigest(self.login + self.id.to_s + self.created_at.to_s + self.password_salt)
      self.save!
    end
    self.guid
  end

  def reset_password
    self.password_change_code = [Array.new(21){rand(256).chr}.join].pack("m").chomp
    save
  end

  def password=(passwd)
    # Create password salt
    generate_salt
    # Create password hash
    self.password_hash = Digest::SHA256.hexdigest(passwd + self.password_salt)
    # Clear change code in case it's set
    self.password_change_code = nil
  end
 
  def confirmed_email
    return nil unless confirmation_code.nil?
    return nil if email.blank?
    return self.email
  end

  def login=(name)
    # Store in lowercase
    write_attribute('login', name.nil? ? nil : name.downcase)
  end  

  def email=(email)
    # Check to see if address has changed
    return if self.email == email
    # Store email
    write_attribute('email', email)
    if self.save and not email.blank?
      # Create salt
      generate_salt
      # Create hashed version of email address for confirmation code
      self.confirmation_code = Digest::SHA256.hexdigest(self.email + self.password_salt)
      # Send confirmation email
      UserMailer.deliver_email_confirmation(self)
    end
  end  

  def self.authenticate(login, passwd)
    user = User.find(:first, :conditions => ["login = ?", login.downcase])
    if user.nil?
      user = User.find(:first, :conditions => ['email = ?', login])
    end
    if user.nil?      
      return :no_such_user    
    else
      if user.email == login and not (user.login.blank? or user.login.nil?)
        return :logged_in_using_email
      elsif Digest::SHA256.hexdigest(passwd + user.password_salt) != user.password_hash
        return :wrong_password
      else
        return user.id
      end
    end
  end

  def avatar=(file)
    unless file.blank?
      # Resize avatar and write to filesystem
      img = MiniMagick::Image.from_blob(file.read)
      img.format 'png'
      img.resize '100x100'
      img.write("#{RAILS_ROOT}/public/images/avatars/#{login}.png")
      img.resize '32x32'
      img.write("#{RAILS_ROOT}/public/images/avatars/thumbnails/#{login}.png")
      # Set avatar flag
      write_attribute('has_avatar', true)
    end
  end
  
  def avatar(small=false)
    if has_avatar
      # Generate path
      path = "avatars/"
      path += "thumbnails/" if small
      # Create avatar URL
      path + self.login + ".png"
    elsif email
      "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&size=#{small ? 32 : 80}&d=wavatar"
    else
      small ? "avatar32.png" : "avatar80.png"
    end
  end
  
  def destroy
    # Remove all associated input data
    electricity_accounts.each { |x| x.destroy }
    gas_accounts.each { |x| x.destroy }
    vehicles.each { |x| x.destroy }
    flights.each { |x| x.destroy }
    # Remove completed actions
    completed_actions.each { |x| x.destroy }
    # Remove friend relations
    approved_friendships.each { |x| x.destroy }
    unapproved_friendships.each { |x| x.destroy }
    approved_befriendships.each { |x| x.destroy }
    unapproved_befriendships.each { |x| x.destroy }
    # Remove group memberships
    group_memberships.each { |x| x.destroy }
    # Remove notes
    notes.each { |x| x.destroy }
    # Remove all comments
    authored_comments.each { |x| x.destroy }
    comments.each { |x| x.destroy }
    # Remove avatar images
    if has_avatar
      FileUtils.remove("#{RAILS_ROOT}/public/images/avatars/#{login}.png")
      FileUtils.remove("#{RAILS_ROOT}/public/images/avatars/thumbnails/#{login}.png")
    end
    # Call base
    super
  end
  
  def has_no_accounts
    electricity_accounts.blank? and gas_accounts.blank? and vehicles.blank?
  end

  def has_enough_data_to_analyse
    for account in electricity_accounts
      return true if account.has_enough_data_to_analyse
    end
    for account in gas_accounts
      return true if account.has_enough_data_to_analyse
    end
    for vehicle in vehicles
      return true if vehicle.has_enough_data_to_analyse
    end
    return true if flights.count > 0
    return false
  end

  def all_emissions
    all_emissions_for_account_type(electricity_accounts) + all_emissions_for_account_type(gas_accounts) + all_emissions_for_account_type(vehicles) + all_emissions_for_flights
  end

  def count_elec_readings
    num = 0
    for account in electricity_accounts
      num += account.count_readings
    end
    return num
  end

  def count_gas_readings
    num = 0
    for account in gas_accounts
      num += account.count_readings
    end
    return num
  end

  def count_vehicle_fuel_purchases
    num = 0
    for account in vehicles
      num += account.count_purchases
    end
    return num
  end

  def send_reminder
    # Check that a reminder is required
    return unless needs_reminding?
    # Send reminder if there is an email address confirmed
    unless self.confirmed_email.nil? or self.login.blank? # Can't send reminder to people without a login, because we can't save the reminder time
      UserMailer.deliver_reminder(self.confirmed_email)
      # Store todays date in reminder field
      self.reminded_at = Time::now
      self.save!
    end
  end

  def name
    return display_name unless display_name.nil? or display_name.blank?
    return login
  end

  def flag
    return country.flag_image unless country.nil?
    return ""
  end

  def image
    return 'admin.png' if admin
    return 'tester.png' if tester
    'user.png'
  end

  def self.find_public(search)    
    search = search.downcase
    like = "%" + search + "%"
    User.find(:all, 
              :conditions => ["public IS TRUE AND (login LIKE ? OR LOWER(email) = ? OR LOWER(display_name) LIKE ?)", like, search, like],
              :order => "login")
  end

  def calculate_totals(period)
    # Calculate start date
    start = Date::today - period + 1
    @date = Date::MONTHNAMES[start.month] + " " + start.day.to_s + ", " + start.year.to_s
    # Store total
    totals = []
    grand_total = 0.0
    # Calculate totals for each emissions source
    for item in all_emissions
      totals << {:name => item[:name], :image => item[:image], :categories => item[:categories], :data => item[:data].calculate_total_over_period(period)}
      grand_total += totals.last[:data][:total]
    end
    # Calculate percentages and yearly totals
    for item in totals
      unless item[:data][:total] == 0
        item[:data][:percentage] = (item[:data][:total] / grand_total) * 100
      end
    end
    # Sort
    totals = totals.sort {|x,y| y[:data][:total] <=> x[:data][:total] }    
    # Add overall total
    total_perday = total_perannum = total_total = 0
    totals.each { |x| total_total += x[:data][:total]; total_perday += x[:data][:perday]; total_perannum += x[:data][:perannum] }
    totals << { :name => "Total", :image => 'chart_pie.png', :data => { :total => total_total, :percentage => 100, :perday => total_perday, :perannum => total_perannum } }
    return totals
  end

  def add_friend(friend)
    # Add to friends list
    unless (friends.include?(friend) or unapproved_friends.include?(friend))
      friends << friend 
      # Send email to friend
      unless friend.confirmed_email.nil? or friend.notify_friend_requests == false
        UserMailer.deliver_friend_request(self.name, friend.confirmed_email)
      end
    end
  end

  def remove_friend(friend)
    # Remove friendship relation
    approved_friendships.find_by_friend_id(friend.id).destroy rescue nil
  end

  def approve_friend_request(friend)
    # Approve the original friend link
    unapproved_befriendships.find_by_user_id(friend.id).approve rescue nil
    # Add a reciprocal link to the friend
    friends << friend unless friends.include?(friend)
    # Auto-approve the reciprocal link
    unapproved_friendships.find_by_friend_id(friend.id).approve rescue nil
  end
  
  def reject_friend_request(friend)
    # Reject the original friend link
    unapproved_befriendships.find_by_user_id(friend.id).reject
  end

  def reset_login_key!
    if login_key.nil? or login_key_expires_at < Time.now
  		self.login_key = Digest::SHA1.hexdigest(Time.now.to_s + password_hash.to_s + rand(123456789).to_s).to_s
	  	self.login_key_expires_at = Time.now.utc+1.year
		  save!
		end
		login_key
	end

  def clear_login_key!
		self.login_key = nil
		self.login_key_expires_at = nil
		save!
	end

  def all_notes(limit = nil)
    all_notes_array = []
    all_notes_array += notes.find(:all, :limit => limit, :order => "date DESC")
    electricity_accounts.each { |acc| all_notes_array += acc.notes.find(:all, :limit => limit, :order => "date DESC") }
    gas_accounts.each { |acc| all_notes_array += acc.notes.find(:all, :limit => limit, :order => "date DESC") }
    vehicles.each { |acc| all_notes_array += acc.notes.find(:all, :limit => limit, :order => "date DESC") }
    return all_notes_array.sort{ |x,y| y.date <=> x.date }
  end

  def annual_emissions
    update_stored_statistics! unless self.annual_emission_total
    total = self.annual_emission_total
    return total
  end

  def update_stored_statistics!
    days = Date::today - date_of_first_data
    days = 365 if days > 365
    self.annual_emission_total = calculate_totals(days).last[:data][:perannum] / people_in_household
    self.save! rescue nil
  end

  def needs_reminding?
    return false if reminder_frequency == 0
    cutoff = (reminder_frequency.weeks + 1.day).ago
    return false if created_at > cutoff # Don't remind if the user was created recently
    oldest_new_data = date_of_oldest_new_data
    return false if (not oldest_new_data.nil? and oldest_new_data.to_time > cutoff) # Don't remind if data was entered recently
    return false if (not reminded_at.nil? and reminded_at > cutoff) # Don't remind if the user was reminded recently
    return true
  end

  def needs_more_data
    date = date_of_oldest_new_data
    return true if date.nil?
    date_of_oldest_new_data < 1.week.ago.to_date
  end

  def date_of_first_data
    start = Date::today
    self.electricity_accounts.each { |x| start = x.start_date if x.start_date < start }
    self.gas_accounts.each { |x| start = x.start_date if x.start_date < start }
    self.vehicles.each { |x| start = x.start_date if x.start_date < start }
    self.flights.each { |x| start = x.outbound_on if x.outbound_on < start }
    start
  end
  
private

  def date_of_oldest_new_data
    oldest_date = nil
    for account in electricity_accounts
      account_newest = account.date_of_newest_data
      oldest_date = account_newest if oldest_date.nil? or oldest_date > account_newest
    end
    for account in gas_accounts
      account_newest = account.date_of_newest_data
      oldest_date = account_newest if oldest_date.nil? or oldest_date > account_newest
    end
    # Don't remind for vehicles - they get filled up as and when
    #for account in vehicles
    #  account_newest = account.date_of_newest_data
    #  oldest_date = account_newest if oldest_date > account_newest
    #end
    return oldest_date
  end

  def all_emissions_for_account_type(accounts)
    emissions = []
    # For each account, calculate emissions
    for account in accounts
      # Find the emissions for the account
      emissions << {:name => account.name, :image => account.image, :data => account.emissions, :categories => account.action_categories}
    end
    return emissions    
  end

public

  def all_emissions_for_flights
    return [] if flights.count == 0
    # Adapt data into format used in all_emissions_for_* functions
    [{:name => 'Flights', :image => 'plane.png', :data => flight_emissions, :categories => [ActionCategory.find_by_name("Travel")]}]
  end

  def flight_emissions
    # Initialise result array
    emissiondata = EmissionArray.new
    # Analyse each reading
    for flight in flights.find(:all, :order => "outbound_on")
      # Add to result array
      days = flight.return_on ? (flight.return_on - flight.outbound_on + 1) : 1
      co2 = flight.kg_of_co2
      emissiondata << { :start => flight.outbound_on - 1,
                        :end => flight.return_on ? flight.return_on : (flight.outbound_on),
                        :co2 => co2,
                        :days => days.to_i,
                        :co2_per_day => co2 / days }
    end	
    # Done - return data
    return emissiondata
  end    

  def to_param
    login
  end

private

  def generate_salt
    if self.password_salt.blank?
      self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    end
  end

end
