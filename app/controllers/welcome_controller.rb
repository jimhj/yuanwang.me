# coding: utf-8
class WelcomeController < ApplicationController
  def index
    @granteds = Wish.granteds.limit(20)
    @pendings = Wish.where.not(status: "GRANTED").order('created_at DESC').limit(20)
  end
end