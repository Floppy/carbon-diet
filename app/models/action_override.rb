class ActionOverride < ActiveRecord::Base
  belongs_to :action
  belongs_to :country
  # Validation
  validates_presence_of :content
  validates_presence_of :action_id
  # Attributes
  attr_accessible :action_id, :content, :country_id, :paid_for
end
