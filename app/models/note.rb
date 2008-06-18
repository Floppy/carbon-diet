class Note < ActiveRecord::Base
  belongs_to :notatable, :polymorphic => true  
  validates_presence_of :notatable_id, :notatable_type, :note, :date
  attr_accessible :note, :date

  def notatable_string=(string)
    self.notatable_type, self.notatable_id = string.split(';')
  end

  def notatable_string
    notatable_type + ";" + notatable_id.to_s rescue nil
  end

end
