# coding: utf-8
class Wisher < ActiveRecord::Base
  belongs_to :user
  belongs_to :wish, counter_cache: true
end
