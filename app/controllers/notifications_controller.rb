# coding: utf-8
class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.received_notifications.order('created_at DESC')  
  end

  def destroy
  end
end