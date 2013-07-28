# coding: utf-8
class WishesController < ApplicationController
  before_action :require_login, except: [:index, :show]

  def index
    
  end

  def show
    @wish = Wish.find params[:id]
    @wisher = @wish.wishers.current.try(:user)
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

  def grant
    @wish = Wish.find params[:id]
    @wish.wishers.create(user_id: current_user.id, current: true)
    redirect_to :back, notice: "认领了#{@wish.user.name}的愿望"
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