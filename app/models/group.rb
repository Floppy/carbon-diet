class Group < ActiveRecord::Base
  has_many :group_memberships
  has_many :users, :through => :group_memberships
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"
  has_many :group_invitations
  has_many :comments, :as => :commentable, :order => "created_at DESC"

  validates_uniqueness_of :name

  def to_param
    name
  end
  
  def after_save
    unless owner.nil?
      add_user(owner)
    end
    super
  end

  def add_user(user)
    users << user unless users.include? user
  end

  def remove_user(user)
    if user != owner
      group_memberships.find_by_user_id(user.id).destroy rescue nil
    end
  end

  def destroy
    group_memberships.each { |x| x.destroy }
    # Remove all comments
    comments.each { |x| x.destroy }
    super
  end

  def self.search(search)    
    search = search.downcase
    like = "%" + search + "%"
    Group.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", like, like).order(:name)
  end
  
  def self.browse(string, limit=20)
    string = "" if string.nil?
    subsections = []
    groups = []
    if find_by_start_of_name(string, true).first["count"].to_i > limit
      ('a'..'z').each do |letter|
        newstring = (string + letter).capitalize
        num = find_by_start_of_name(newstring, true).first["count"].to_i
        subsections << [newstring, num] if num > 0
      end
    else
      groups = find_by_start_of_name(string)
    end
    return subsections, groups
  end

  def self.find_by_start_of_name(string, countonly=false)
    select = "COUNT(name) AS count" if countonly
    conditions = ["LOWER(name) LIKE ?", string.downcase + "%"] unless string.empty?
    Group.where(conditions).order(:name).select(select)
  end

end
