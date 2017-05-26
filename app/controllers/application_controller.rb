class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # https://github.com/CanCanCommunity/cancancan/wiki/Role-Based-Authorization
  # Many roles per user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :save_roles
  protected
  def save_roles
    # Model does not save roles. (roles is a method from role_model gem)
    # This workaround is not perfect but works. 
    # Also it is vulnerable to CSRF!
    # Another workaround can be made by editing _rails_partial.erb loading a javascript
    # that generates roles_mask by hand and submit that. That workaround would not be
    # vulnerable to CSRF.
    if !current_user.nil? && (current_user.has_role? :admin ) && !params.nil? && !params["user"].nil? &&
      !params["user"]["roles"].nil? && params["_method"]=="put" && params["action"]=="edit" &&
      params["model_name"]=="user" && params["controller"]=="rails_admin/main" &&
      !params["_save"].nil? && !params["id"].nil? 
      user_to_modify = User.find(params["id"].to_i)
      # An admin cannot remove the admin role to itself. He has to ask other admin to do it.
      if(user_to_modify.id != current_user.id || ( user_to_modify.id == current_user.id && (params["user"]["roles"].include? "admin")))
        user_to_modify.roles = current_user.roles = params["user"]["roles"]
        user_to_modify.save
      end
    end

  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  { |u| u.permit(  :email, :password, :password_confirmation, roles: [] ) }
  end
  def info_for_paper_trail
    { :ip => request.remote_ip, 
      :user_agent => request.user_agent,
      :ticket_id => params["ticket_id"].nil? ? nil : params["ticket_id"].to_i }
  end
end
