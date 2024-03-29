# coding: utf-8
class User < ActiveRecord::Base
  include UUID
  include QnUploader

  validates :name, presence: true, length: { maximum: 40, minimum: 2 }
  validates :email, presence: true, uniqueness: true
  validates_uniqueness_of :weibo_uid, allow_blank: true

  has_secure_password
  mount_uploader :avatar

  has_many :wishes, -> { order('created_at DESC') }
  has_many :wishers
  has_many :received_notifications, class_name: "Notification::Base", foreign_key: "to_user_id"

  def self.build_via_weibo(auth)
    user = User.new
    user.name = auth['name']
    user.password_confirmation = user.password = SecureRandom.hex(4)
    auth['avatar_url'] << "/sample.jpg" unless auth['avatar_url'].end_with?('.jpg')
    user.avatar = auth['avatar_url']
    user.email = "#{auth['weibo_uid']}@weibo.com"
    user.weibo_uid = auth['weibo_uid']
    user.weibo_token = auth['weibo_token']
    user   
  end

  def unread_notifies_count
    self.received_notifications.where(readed: false).count
  end

  def grant_wishes
    Wish.where(id: self.wishers.map(&:wish_id))
  end

  def read_notifications(notifications)
    unread_ids = notifications.where(readed: false).pluck(:id)
    if unread_ids.any?
      Notification::Base.where({ id: unread_ids, readed: false }).update_all(readed: true)
    end    
  end  
end
