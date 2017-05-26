class CreatePackagesAndGames < ActiveRecord::Migration
  def change
    create_table :packages do |t|
    	t.string :name
    	t.timestamps null: false
    	t.string :description
    end

    create_table :games do |t|
    	t.string :name
    	t.string :description
    	t.string :gamekey
    end

    create_table :games_packages, id: false do |t|
    	t.belongs_to :package, index: true
    	t.belongs_to :game, index: true
    end
  end
end
