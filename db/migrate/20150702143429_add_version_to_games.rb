class AddVersionToGames < ActiveRecord::Migration
  def change
    add_column :games, :version, :integer, :default => 0
  end
end
