# coding: utf-8
class Notification::ConfirmGrant < Notification::Base
  belongs_to :wish, class_name: "Wish", foreign_key: "model_id"
end