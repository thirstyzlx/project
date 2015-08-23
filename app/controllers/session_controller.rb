class SessionController < Devise::SessionsController
  def new
    super
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message :notice, :"Sign in failed: #{:signed_in}"
    sign_in(resource_name, resource)
    yield resource if block_given?
    #respond_with resource, location: root_path
    redirect_to request.referer
  end
end