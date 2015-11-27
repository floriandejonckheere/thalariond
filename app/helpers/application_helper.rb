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
    image_url(images[rand(images.size)])
  end
end
