# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)  # Strong Parametersを使用して新しいユーザーを作成

    resource.skip_confirmation! # 確認をスキップ


    if resource.save
      # ユーザーが保存された場合の処理
      sign_in(resource)  # サインインさせる
      flash[:notice] = "Wel come to Music Hour!!"
      if params[:user][:email].present?
        resource.unconfirmed_email = params[:user][:email]
        resource.send_confirmation_instructions if resource.unconfirmed_email.present?
        resource.save(validate: false)
        flash[:notice] += "　メールアドレス宛てに確認メールを送信しました。メールに記載されているURLにアクセスし、メールアドレスを有効化してください"
      end
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource  # エラーが発生した場合、リソースを再表示
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :email ])
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
