class RegisterController < Devise::SessionsController
  # POST /resource
  def create
    if params[:user][:password] == params[:user][:passwordc] and params[:user][:password] != "" and params[:user][:email] != "" and params[:user][:game_id] != ""
      u = User.new
      u.email = params[:user][:email]
      u.password = params[:user][:password]
      u.game_id = params[:user][:game_id]
      u.save
      flash[:notice] = "Registration Success, please sign in."
      redirect_to root_path
    elsif params[:user][:password] == params[:user][:passwordc]
      flash[:notice] = "Registration Failed, incorrect Info."
      redirect_to root_path
    end
  end
end