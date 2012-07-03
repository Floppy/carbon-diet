class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true  
  validates_presence_of :commentable_id, :commentable_type, :text, :user
  attr_accessible :text, :commentable_type, :commentable_id
end
