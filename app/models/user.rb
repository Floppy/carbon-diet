require 'digest/sha2'
require 'mini_magick'

class User < ActiveRecord::Base
  # Relationships
  belongs_to :country
  has_many :electricity_accounts do
    def current
      where(:current => true)
    end
  end
  has_many :electricity_readings, :through => :electricity_accounts
  has_many :gas_accounts do
    def current
      where(:current => true)
    end
  end
  has_many :gas_readings, :through => :gas_accounts
  has_many :vehicles do
    def current
      where(:current => true)
    end
  end
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
    :conditions =>        { :approved => true }
  has_many :unapproved_friendships,
    :foreign_key =>       'user_id',
    :class_name =>        'Friendship',
    :conditions =>        { :approved => false }
  has_many :approved_befriendships,
    :foreign_key =>       'friend_id',
    :class_name =>        'Friendship',
    :conditions =>        { :approved => true }
  has_many :unapproved_befriendships,
    :foreign_key =>       'friend_id',
    :class_name =>        'Friendship',
    :conditions =>        { :approved => false }
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
      UserMailer.email_confirmation(self).deliver
    end
  end  

  def self.authenticate(login, passwd)
    user = User.where(:login => login.downcase).first
    if user.nil?
      user = User.where(:email => login).first
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
  
  def avatar(small=false)
    if email
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
      FileUtils.remove("#{Rails.root}/public/images/avatars/#{login}.png")
      FileUtils.remove("#{Rails.root}/public/images/avatars/thumbnails/#{login}.png")
    end
    # Call base
    super
  end
  
  def has_no_accounts
    electricity_accounts.blank? and gas_accounts.blank? and vehicles.blank?
  end

  def has_enough_data_to_analyse
    electricity_accounts.each do |account|
      return true if account.has_enough_data_to_analyse
    end
    gas_accounts.each do |account|
      return true if account.has_enough_data_to_analyse
    end
    vehicles.each do |vehicle|
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
    electricity_accounts.each do |account|
      num += account.count_readings
    end
    return num
  end

  def count_gas_readings
    num = 0
    gas_accounts.each do |account|
      num += account.count_readings
    end
    return num
  end

  def count_vehicle_fuel_purchases
    num = 0
    vehicles.each do |account|
      num += account.count_purchases
    end
    return num
  end

  def send_reminder
    # Check that a reminder is required
    return unless needs_reminding?
    # Send reminder if there is an email address confirmed
    unless self.confirmed_email.nil? or self.login.blank? # Can't send reminder to people without a login, because we can't save the reminder time
      UserMailer.reminder(self).deliver
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
    User.where(:public => true).where("(login LIKE ? OR LOWER(email) = ? OR LOWER(display_name) LIKE ?)", like, search, like).order(:login)
  end

  def calculate_totals(period)
    # Calculate start date
    start = Date::today - period + 1
    @date = Date::MONTHNAMES[start.month] + " " + start.day.to_s + ", " + start.year.to_s
    # Store total
    totals = []
    grand_total = 0.0
    # Calculate totals for each emissions source
    all_emissions.each do |item|
      totals << {:name => item[:name], :image => item[:image], :categories => item[:categories], :data => item[:data].calculate_total_over_period(period)}
      grand_total += totals.last[:data][:total]
    end
    # Calculate percentages and yearly totals
    totals.each do |item|
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
      unapproved_friendships.create(:friend => friend, :approved => false)
      # Send email to friend
      unless friend.confirmed_email.nil? or friend.notify_friend_requests == false
        UserMailer.friend_request(self, friend).deliver
      end
    end
  end

  def remove_friend(friend)
    # Remove friendship relation
    approved_friendships.find_by_friend_id(friend.id).destroy
  end

  def approve_friend_request(friend)
    # Approve the original friend link
    friendship = unapproved_befriendships.find_by_user_id(friend.id)
    if friendship
      friendship.approve
      # Add a reciprocal link to the friend
      approved_friendships.create(:friend => friend, :approved => true)
    end
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
    all_notes_array += notes.limit(limit).order("date DESC")
    electricity_accounts.each { |acc| all_notes_array += acc.notes.limit(limit).order("date DESC") }
    gas_accounts.each { |acc| all_notes_array += acc.notes.limit(limit).order("date DESC") }
    vehicles.each { |acc| all_notes_array += acc.notes.limit(limit).order("date DESC") }
    return all_notes_array.sort{ |x,y| y.date <=> x.date }
  end

  def annual_emissions
    update_stored_statistics! unless self.annual_emission_total
    total = self.annual_emission_total
    return total
  end

  def update_stored_statistics!(save = true)
    days = Date::today - date_of_first_data
    days = 365 if days > 365
    self.annual_emission_total = calculate_totals(days).last[:data][:perannum] / people_in_household
    self.save(:validate => false) if save
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
    electricity_accounts.each do |account|
      account_newest = account.date_of_newest_data
      oldest_date = account_newest if oldest_date.nil? or oldest_date > account_newest
    end
    gas_accounts.each do |account|
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
    accounts.each do |account|
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
    flights.order("outbound_on").each do |flight|
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

  def points # Experimental
    ranges = [
      [0,1,"Newborn"],
      [1,10,"Beginner"],
      [10,25,"Apprentice"],
      [25,50,"Adept"],
      [50,100,"Master"],
      [100,250,"Expert"],
      [250,500,"Genius"],
      [500,1e100,"Wizard"]
    ]
    breakdown = {}
    breakdown[:entries] = {:value => electricity_readings.count(:conditions => {:automatic => false})+gas_readings.count+vehicle_fuel_purchases.count+flights.count, :description => "measurement"}
    breakdown[:actions] = {:value => actions.inject(0){|t,x| t += x.points}, :description => "actions"}
    breakdown[:sociability] = {:value => (friends.count+groups.count)*2, :description => "sociability"}
    breakdown[:gossip] = {:value => comments.count, :description => "gossip"}
    emissions_limit = -(breakdown.inject(0){|sum,(k,v)| sum += v[:value]} / 2)
    breakdown[:emissions] = {:value => [-((annual_emissions>1000?annual_emissions-1000:annual_emissions)/10).to_i,emissions_limit].max, :description => "emissions"}
    total = breakdown.inject(0){|sum,(k,v)| sum += v[:value]}
    level = ranges.find{|x| total >= x[0] && total < x[1]}
    {
      :total => total,
      :breakdown => breakdown,
      :level => level,
      :percentage => level != ranges.last ? (((total - level[0]).to_f / (level[1] - level[0]).to_f) * 100).to_i : 100
    }
  end

  # initialize the multipass object
  def self.multipass
    @multipass ||= MultiPass.new('carbondiet', ENV['MULTIPASS_API_KEY'])
  end

  # create a multipass for this user object
  def multipass
    self.class.multipass.encode(:email => email, :name => name, :expires => 30.minutes.from_now, :external_url => "http://www.carbondiet.org/profile/#{login}")
  end

private

  def generate_salt
    if self.password_salt.blank?
      self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    end
  end

end
