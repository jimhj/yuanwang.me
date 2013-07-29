# coding: utf-8
class NotificationsController < ApplicationController
  before_action :require_login
  after_action :read_notifications, only: :index

  def index
    @notifications = current_user.received_notifications.order('created_at DESC')
  end

  def destroy
  end

  private

  def read_notifications
    current_user.read_notifications @notifications
  end
end