class CompletedAction < ActiveRecord::Base
  # Relationships
  belongs_to :user
  belongs_to :action
  # Attributes
  attr_accessible :user_id, :action_id, :done
end
