class Token < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  validates_uniqueness_of :value

  def self.get(value)
    find_by_value(value).try(:parent)
  end

  def self.get!(value)
    token = find_by_value!(value)
    token.parent_type.constantize.find(token.parent_id)
  end
end
