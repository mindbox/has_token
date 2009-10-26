class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.belongs_to :parent, :polymorphic => true
      t.string :value
    end

    change_table :tokens do |t|
      t.index [:parent_id, :parent_type]
      t.index :value, :unique => true
    end
  end

  def self.down
    drop_table :tokens
  end
end
