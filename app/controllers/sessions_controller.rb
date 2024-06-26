class SessionsController < ApplicationController
  skip_authentication only: %i[new create]
  def new; end

  def create
    @app_session = User.create_app_session(
      email: session_params[:email],
      password: session_params[:password]
    )
    if @app_session
      log_in(@app_session, session_params[:remember_me] == '1')
      flash[:success] = t('.success')
      recede_or_redirect_to root_path, status: :see_other
    else
      flash.now[:danger] = t('.incorrect_details')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out

    flash[:success] = t('.success')
    redirect_to root_path, status: :see_other
  end

  private

  def session_params
    @session_params ||=
      params.require(:user).permit(:email, :password, :remember_me)
  end
end
