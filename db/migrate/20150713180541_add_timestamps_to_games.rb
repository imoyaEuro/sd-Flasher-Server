class AddTimestampsToGames < ActiveRecord::Migration
  def self.up # Or `def up` in 3.1
    change_table :games do |t|
      t.timestamps null: true
    end
  end
  def self.down # Or `def down` in 3.1
    remove_column :games, :created_at
    remove_column :games, :updated_at
  end
end
