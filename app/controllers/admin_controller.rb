# Render無料枠でrails cが使えないので一時的な記述。admninユーザーが本番で作成できたら削除すること！

class AdminController < ApplicationController
  before_action :restrict_ip_address, only: [:set_admin]

  def set_admin
    user = User.find(ENV['ADMIN_USER_ID'].to_i)
    user.admin = true
    if user.save
      flash[:success] = "#{user.name}にadmnin権限を付与しました"
    else
      flash[:error] = "admin権限付与に失敗しました"
    end
    puts request.remote_ip
    p request.remote_ip

    redirect_to login_path
  end

  private

  def restrict_ip_address
    allowed_ips = ENV['ALLOWED_IPS'].split(',')  # 環境変数からIPアドレスを取得
    remote_ip = request.remote_ip

    unless allowed_ips.include?(remote_ip)
      render plain: "アクセスが許可されていません", status: :unauthorized
    end
  end
end
