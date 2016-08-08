class SessionsController < Devise::SessionsController
  after_filter :log_failed_login, :only => :new

  def create
    super
    ::Rails.logger.info "Login successful for user #{request.filtered_parameters["user"]["uid"]}"
      AuthEvent.create!(:component => "http",
                        :action => "signin",
                        :result => true,
                        :ip => request.remote_ip,
                        :agent => request.user_agent,
                        :user_id => User.find_by(:uid => request.filtered_parameters["user"]["uid"]).id)
  end

  private
  def log_failed_login
    if failed_login?
      ::Rails.logger.info "Login failed for user #{request.filtered_parameters["user"]["uid"]} from #{request.remote_ip} (#{request.user_agent})"
      AuthEvent.create!(:component => "http",
                        :action => "signin",
                        :result => false,
                        :ip => request.remote_ip,
                        :agent => request.user_agent,
                        :user_id => nil)
    end
  end

  def failed_login?
    (options = env["warden.options"]) && options[:action] == "unauthenticated"
  end
end
