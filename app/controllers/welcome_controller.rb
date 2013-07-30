# coding: utf-8
class WelcomeController < ApplicationController
  def index
    @users = User.includes(:wishes).order('wishes.created_at DESC')
    unless params[:list].blank?
      @users = @users.where("wishes.status = ?", params[:list])
    end
    @users = @users.limit(30)
  end
end