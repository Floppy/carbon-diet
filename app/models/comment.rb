class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true  
  validates_presence_of :commentable_id, :commentable_type, :text
  attr_accessible :text
end
