# coding: utf-8
class Wish < ActiveRecord::Base
  include UUID
  include QnUploader

  has_many :wishers
  has_one :achiever, class_name: "User", foreign_key: "achiever_id"
  belongs_to :user, counter_cache: true
end
