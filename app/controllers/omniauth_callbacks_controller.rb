class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    find_and_login(:facebook)
  end

  def vkontakte
    find_and_login(:vkontakte)
  end

  private

  def find_and_login(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
    end
  end
end
