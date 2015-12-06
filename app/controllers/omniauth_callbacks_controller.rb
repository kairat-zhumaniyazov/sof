class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    find_and_login(:facebook)
  end

  def vkontakte
    find_and_login(:vkontakte)
  end

  def twitter
    # render json: request.env['omniauth.auth']
    find_and_login(:twitter)
  end

  private

  def find_and_login(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else
      #render partial: 'omniauth_callbacks/email_confirm'
      session["devise.oauth_data"] = request.env['omniauth.auth'].except('extra')
      redirect_to email_required_path
    end
  end
end
