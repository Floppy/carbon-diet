class Action < ActiveRecord::Base
  belongs_to :action_category
  has_many :completed_actions
  has_many :users, :through => :completed_actions
  has_many :action_overrides
  # Validation
  validates_presence_of :title
  validates_presence_of :content
  # Attributes
  attr_accessible :title, :content, :image, :level, :action_category_id
  attr_reader :paid_for

  def self.find_for_user(user, categories, num, offset=0)
    category_order = ""
    # Create category ordering string
    unless categories.empty?
      category_order = ", CASE action_category_id "
      orderid = 1
      categories.each do |category|
        category_order += "WHEN " + orderid.to_s + " THEN " + category.id.to_s + " "
        orderid.next
      end
      category_order += "END"
    end
    # Query
    Action.find_by_sql(["SELECT * FROM actions WHERE id NOT IN (SELECT action_id FROM completed_actions WHERE user_id = ?) ORDER BY level #{category_order} LIMIT ? OFFSET ?", user.id, num, offset])
  end

  def load_random_override(country_id)
    override = action_overrides.where("country_id = ? OR country_id = 0", country_id).shuffle.first
    if override
      self.content = override.content
      @paid_for = override.paid_for
    end
  end

  def points
    level * 10
  end

end
