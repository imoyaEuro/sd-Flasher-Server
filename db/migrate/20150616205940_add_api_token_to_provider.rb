class AddApiTokenToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :api_token, :string, :limit => 64
  end
end
