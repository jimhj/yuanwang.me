# coding: utf-8
class UsersController < ApplicationController
  def show
    @user =  User.find params[:id]
    @wishes = @user.wishes.includes('wishers').order('created_at DESC')
  end  
end