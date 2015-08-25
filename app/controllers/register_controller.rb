class RegisterController < Devise::SessionsController
  # POST /resource
  def create
    if params[:user][:password] == params[:user][:passwordc] and params[:user][:password] != "" and params[:user][:email] != "" and params[:user][:game_id] != "" and not(User.exists?(:game_id => params[:user][:game_id]))
      build_resource(sign_up_params)
      resource.game_id = params[:user][:game_id]
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      flash[:notice] = "Registration Failed, incorrect Info."
      redirect_to root_path
    end
  end

  protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def after_sign_up_path_for(resource)
    '/' # Or :prefix_to_your_route
  end

  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
  # POST /resource
  #def create
  #  if params[:user][:password] == params[:user][:passwordc] and params[:user][:password] != "" and params[:user][:email] != "" and params[:user][:game_id] != "" and not(User.exists?(:game_id => params[:user][:game_id]))
  #    u = User.new
  #    u.email = params[:user][:email]
  #    u.password = params[:user][:password]
  #    u.game_id = params[:user][:game_id]
  #    u.save
  #    sign_up(resource_name, resource)
  #    redirect_to root_path
  #  elsif params[:user][:password] == params[:user][:passwordc]
  #    flash[:notice] = "Registration Failed, incorrect Info."
  #    redirect_to root_path
  #  end
  #end
end