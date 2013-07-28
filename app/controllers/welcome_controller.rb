# coding: utf-8
class WelcomeController < ApplicationController
  def index
    @granteds = Wish.granteds.limit(20)
    @pendings = Wish.pendings.limit(20)
  end
end