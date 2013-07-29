# coding: utf-8
class Notification::Base < ActiveRecord::Base
  self.table_name = "notifications"

  validates_presence_of :user_id, :to_user_id

  belongs_to :user
  belongs_to :to_user, :class_name => "User", :foreign_key => :to_user_id

  scope :unread, -> { where(readed: false) }
end