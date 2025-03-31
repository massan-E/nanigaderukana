# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @omniauth = request.env["omniauth.auth"]
    info = User.find_oauth(@omniauth)
    @user = info[:user]
    if @user.persisted?    # persisted?は保存が完了しているかを評価するメソッド
      sign_in_and_redirect @user, event: :authentication
      # is_navigational_formatはフラッシュメッセージを発行する必要があるかどうかを確認する
      # capitalizeは文字列の先頭を大文字に、それ以外は小文字に変更して返すメソッド
      set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
      set_flash_message(:alert, :failure, kind: provider.to_s.capitalize, reason: @user.errors.full_messages.join("\n")) if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path and return
  end
end
