class SessionController < ApplicationController
  def new
    redirect_to timesheets_path if @current_user.present?
  end

  def create
    @user = User.find_by email: params[:email]

    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to timesheets_path
    else
      flash[:error] = 'Invalid Email or Password.'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
