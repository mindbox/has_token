class Token < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true
  
  named_scope :for, lambda{|k| {:conditions => {:parent_type => k.to_s.classify}} }
  
  def self.get(value)
    find_by_value(value).try(:parent)
  end
end
