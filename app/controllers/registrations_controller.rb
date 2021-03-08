class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_forgery_protection
  def new 
    build_resource(sign_up_params)
    if resource.save
      render_resource(resource)
    elsif
      render json: resource.errors
    end
  end

  def create
  end
  def update
    super
  end
end
