# coding: utf-8
class AuthController < ApplicationController
  before_action :check_signed_in, only: :weibo_login
  before_action :require_login, only: :sign_out

  def weibo_login
    render_auth_login  
  end

  def sign_out
    clear_login_state
    clear_sign_in_cookie

    redirect_to root_path, warning: "您已登出"    
  end  

  private

  def check_signed_in
    redirect_to :root and return if signed_in?
  end

  def render_auth_login(auth_type = 'weibo')
    auth = request.env["omniauth.auth"]
    @auth_hash = {
      "#{auth_type}_uid"    =>    auth.uid,
      'name'                =>    auth.info.name,
      'avatar_url'          =>    auth.info.avatar_url,
      "#{auth_type}_token"  =>    auth.credentials.token
    }
    user = User.find_by(:"#{auth_type}_uid" => auth.uid)
    unless user.blank?
      user.update_attribute("#{auth_type}_token".to_sym, auth.credentials.token)
      self.current_user = user
      redirect_to root_path, success: "登录成功，欢迎回来"
      return
    end

    begin
      user = User.build_via_weibo(@auth_hash)
      user.save!
      user.update_attributes(last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
      self.current_user = user
      redirect_to root_path, success: "授权注册成功"
    rescue => e
      raise e
      redirect_to root_path, alert: "授权注册失败"
    end
  end

end