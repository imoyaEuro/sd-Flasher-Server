require 'rubygems'
require 'role_model'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include RoleModel
  roles_attribute :roles_mask
  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end! (never delete an old role!)
  roles :admin, :games_manager,:providers_manager,:packages_manager,:sales_manager,:sdpackages_manager, :users_manager
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
end
