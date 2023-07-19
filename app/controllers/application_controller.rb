class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  def authorize_request(kind = nil)
  unless kind.include?(current_user.role)
    notice = "No estás autorizado para realizar esta acción"
    redirect_to posts_path, notice: notice
  end
end


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :age, :phone])
  end
end
