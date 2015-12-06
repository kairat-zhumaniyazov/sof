class RegistrationsController < Devise::RegistrationsController
  def email_required
    respond_with(@user = User.new)
  end

  def create_with_email
    @user = User.find_by(email: user_params[:email])
    if @user
      @user.authorizations.create!(user_params[:authorization])
      flash[:notice] = 'Email already registered in system. For binding you must verify your email address.'
      redirect_to new_user_session_path
    else
      @user = User.create_with_psw(user_params[:email])
      if @user.persisted?
        @user.authorizations.create!(user_params[:authorization])
        flash[:notice] = 'Congratulations! Email successfully registered. You must verify your email address'
        redirect_to new_user_session_path
      else
        render :email_required
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, authorization: [:id, :provider, :uid] )
  end
end
