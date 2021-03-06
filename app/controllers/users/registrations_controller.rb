class Users::RegistrationsController < Devise::RegistrationsController
#before_filter :configure_sign_up_params, only: [:create]
#before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if params[:user][:password] == params[:user][:passwordc] and params[:user][:password] != "" and params[:user][:email] != "" and params[:user][:game_id] != "" and not(User.exists?(:game_id => params[:user][:game_id]))
      build_resource(sign_up_params)
      resource.game_id = params[:user][:game_id]
      resource.rankb = "Unranked"
      resource.ranks = "1"
      resource.rankBadge = "/assets/rank1.png"
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

  # GET /resource/edit
  def edit
     super
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    if params[:user][:email] == nil or params[:user][:email]== current_user.email
      resource_updated = update_resource(resource, account_update_params)
      if params[:user][:rankb] != nil and params[:user][:ranks] != nil
        resource.rankb = params[:user][:rankb];
        resource.ranks = params[:user][:ranks];
        case params[:user][:rankb]
          when "Unranked"
            resource.rankBadge = "/assets/rank1.png"
          when "Bronze"
            resource.rankBadge = "/assets/rank2.png"
          when "Silver"
            resource.rankBadge = "/assets/rank3.png"
          when "Gold"
            resource.rankBadge = "/assets/rank4.png"
          when "Platinum"
            resource.rankBadge = "/assets/rank5.png"
          when "Diamond"
            resource.rankBadge = "/assets/rank6.png"
          when "Master"
            resource.rankBadge = "/assets/rank7.png"
          when "Challenger"
            resource.rankBadge = "/assets/rank8.png"

        end
        resource.save
      end
      yield resource if block_given?
      if resource_updated
        if is_flashing_format?
          flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
              :update_needs_confirmation : :updated
          set_flash_message :notice, flash_key
        end
        sign_in resource_name, resource, bypass: true
        redirect_to "/"
      else
        clean_up_passwords resource
        redirect_to "/"
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.for(:sign_up) << :attribute
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.for(:account_update) << :attribute
   end

  # The path used after sign up.
   def after_sign_up_path_for(resource)
     super(resource)
   end

  # The path used after sign up for inactive accounts.
   def after_inactive_sign_up_path_for(resource)
     super(resource)
  end
end
