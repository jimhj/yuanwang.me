# coding: utf-8
class Wisher < ActiveRecord::Base
  belongs_to :user
  belongs_to :wish, counter_cache: true

  after_create do
    self.wish.update_attribute :status, "LOCKED"
  end

end
