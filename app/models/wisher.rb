# coding: utf-8
class Wisher < ActiveRecord::Base
  belongs_to :user
  belongs_to :wish, counter_cache: true

  after_create do
    self.wish.update_attribute :status, "LOCKED"
  end
  
  after_create do
    self.delay(queue: "send_grant_notification", priority: 20).send_grant_notification
  end
  def send_grant_notification
    return if user_id == wish.user_id
    notify = Notification::Grant.new
    notify.user_id = self.user_id
    notify.to_user_id = self.wish.user_id
    notify.model_id = wish_id
    notify.save
  end
end
