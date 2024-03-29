# coding: utf-8
class UsersController < ApplicationController
  def show
    @user =  User.find params[:id]
    if params[:list] == 'grant'
      @wishes = @user.grant_wishes.includes('wishers')
    else
      @wishes = @user.wishes.includes('wishers')
      @wishes = @wishes.send(params[:list]) unless params[:list].blank?
    end     
    @wishes = @wishes.order('wishes.created_at DESC')
    set_seo_meta("#{@user.name}的愿望清单", "愿望清单", "愿望清单")
  end

end