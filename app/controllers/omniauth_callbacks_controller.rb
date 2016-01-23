class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    find_and_login(:facebook)
  end

  def vkontakte
    find_and_login(:vkontakte)
  end

  def twitter
    find_and_login(:twitter)
  end

  private

  # rubocop:disable Metrics/AbcSize, Metrics/LineLength
  def find_and_login(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else
      session['devise.oauth_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to email_required_path
    end
  end
end
