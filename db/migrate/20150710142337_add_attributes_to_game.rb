class AddAttributesToGame < ActiveRecord::Migration
  def change
    add_column :games, :short_description, :string
    add_column :games, :version_description, :string
    add_column :games, :company, :string
    add_column :games, :apk_link, :string
    add_column :games, :logo, :string
    add_column :games, :image1, :string
    add_column :games, :image2, :string
    add_column :games, :image3, :string
    add_column :games, :image4, :string
    add_column :games, :image5, :string
    add_column :games, :image6, :string
    add_column :games, :image7, :string
    add_column :games, :image8, :string
    add_column :games, :image9, :string
    add_column :games, :image10, :string
  end
end
