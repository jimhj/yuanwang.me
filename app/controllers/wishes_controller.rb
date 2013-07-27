# coding: utf-8
class WishesController < ApplicationController
  before_action :require_login

  def index
    
  end

  def show
    
  end

  def new
    @wish = current_user.wishes.new
  end

  def create
    @wish = current_user.wishes.create wish_params
    redirect_to :back
  end

  def upload
    wish = Wish.new
    wish.photo = params[:upload]
    render :text => { preview: wish.photo_url(:small), photo: wish.photo }.to_json
  end

  def edit
    
  end

  def update
    
  end

  def patch
    
  end

  def destroy
    
  end

  private

  def wish_params
    params.require(:wish).permit(:content, :photo, :deadline, :refer_link)
  end
end