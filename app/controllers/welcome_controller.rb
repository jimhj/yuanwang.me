# coding: utf-8
class WelcomeController < ApplicationController
  def index
    @granteds = Wish.granted.limit(20)
    @pendings = Wish.where.not(status: "GRANTED").order('created_at DESC').limit(20)
  end
end