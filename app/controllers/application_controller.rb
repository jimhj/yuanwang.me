# coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?
  add_flash_types :warning, :success, :error

  def signed_in?
    current_user.present?
  end
  
  def require_login
    unless signed_in?
      clear_login_state
      redirect_to root_path, error: "请登录后继续"
    end
  end  

  def current_user    
    @current_user ||= begin
      login_from_session || login_from_cookie
    end
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || nil
  end

  def login_from_session
    self.current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_from_cookie
    if session[:user_id].blank? && cookies.signed[:remember_me].present?
      session[:user_id] = cookies.signed[:remember_me].split('--')[1]
      self.current_user = User.find_by(id: session[:user_id])
    end
  end

  def set_sign_in_cookie
    cookies.signed[:remember_me] = {
      :value => "#{Time.now.to_i}--#{current_user.id}",
      :expires => 1.week.from_now
    }
  end

  def clear_sign_in_cookie
    cookies.delete(:remember_me)
  end

  def clear_login_state
    current_user = nil
    session[:user_id] = nil
    session.clear
  end

  def set_seo_meta(title = nil, meta_keywords = nil, meta_description = nil)
    default_keywords = "愿望清单"
    default_description = %Q(愿望清单)
    @page_title = "#{title}" if title.present?      
    @keywords = meta_keywords || default_keywords
    @description = meta_description || default_description
  end  

end
