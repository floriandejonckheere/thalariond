module ApplicationHelper

  def controller?(*controller)
    controller.include? params[:controller]
  end

  def action?(*action)
    action.include? params[:action]
  end

  def id?(id)
    id == params[:id]
  end

  def randomized_background_image
    images = Dir.glob('app/assets/images/backgrounds/*').map { |p| p.split('/')[-2..-1].join('/') }
    image_path(images[(Time.new.yday % images.size)])
  end

  # Bootstrap alert classes
  def bootstrap_class_for flash_type
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info',
      :info => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def ldapd_running?
    begin
      Process.getpgid LDAPd.pid
      return true
    rescue Errno::ESRCH
      return false
    end
  end

  # false when invoked as a rake task, a generator or test environment
  def server?
    not (ENV["RAILS_ENV"].nil? or ENV["RAILS_ENV"] == 'test')
  end
end
