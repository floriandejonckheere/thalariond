class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Check if authorization is performed for every controller action
  check_authorization :unless => :devise_controller?

  # CanCan bug, see https://github.com/ryanb/cancan/issues/835#issuecomment-18663815
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  # Allow Paper Trail to use current_user
  before_action :set_paper_trail_whodunnit

  # Extra metadata for Paper Trail
  def info_for_paper_trail
    {
      :ip => request.remote_ip,
      :user_agent => request.user_agent
    }
  end

  # CanCanCan Access Denied
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_path, flash[:danger] => exception.message
  end

end
