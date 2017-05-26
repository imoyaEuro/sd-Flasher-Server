class  AddIpUserAgentAndTicketIdToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :ip, :inet
    add_column :versions, :user_agent, :string
    add_column :versions, :ticket_id, :integer
  end

  def self.down
    remove_column :versions, :ip
    remove_column :versions, :user_agent
    remove_column :versions, :ticket_id
  end
end
