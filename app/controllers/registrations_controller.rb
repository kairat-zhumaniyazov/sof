class RegistrationsController < Devise::RegistrationsController
  def email_required
    respond_with(@user = User.new)
  end

  def create_with_email
    if @user = User.find_by(email: user_params[:email])
      flash[:notice] =
        'Email already registered in system. For binding you must verify your email address.'
      create_auth_and_redirect_for @user
    else
      @user = User.create_with_psw(user_params[:email])
      if @user.persisted?
        flash[:notice] =
          'Congratulations! Email successfully registered. You must verify your email address'
        create_auth_and_redirect_for @user
      else
        render :email_required
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def create_auth_and_redirect_for(user)
    user.authorizations.create!(provider: session['devise.oauth_data']['provider'],
                                uid: session['devise.oauth_data']['uid'])
    redirect_to new_user_session_path
  end
end
