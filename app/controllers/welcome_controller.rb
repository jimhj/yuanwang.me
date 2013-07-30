# coding: utf-8
class WelcomeController < ApplicationController
  def index
    @users = User.includes(:wishes).order('wishes.created_at DESC').limit(30)
  end
end