# coding: utf-8
class WelcomeController < ApplicationController
  def index
    @users = User.includes(:wishes).order('wishes.created_at DESC').limit(30)
    # @granteds = Wish.granted.limit(20)
    # @pendings = Wish.where.not(status: "GRANTED").order('created_at DESC').limit(20)
  end
end