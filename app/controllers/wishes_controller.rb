# coding: utf-8
class WishesController < ApplicationController
  before_action :require_login, except: [:index, :show]

  def index
    
  end

  def show
    @wish = Wish.find params[:id]
    @wisher = @wish.current_wisher
  end

  def new
    @wish = current_user.wishes.new
  end

  def create
    @wish = current_user.wishes.build wish_params
    if @wish.save
      redirect_to wish_path(@wish), success: "刚刚成功的许下了心愿"
    else
      redirect_to :back, alert: @wish.errors.full_message.first
    end
  end

  def upload
    wish = Wish.new
    wish.photo = params[:upload]
    render :text => { preview: wish.photo_url(:small), photo: wish.photo }.to_json
  end

  def grant
    @wish = Wish.find params[:id]
    if @wish.user == current_user
      message = { error: "不能认领自己的愿望" }
    else
      @wish.wishers.create(user_id: current_user.id, current: true)
      message = { notice: "刚刚认领了 #{@wish.user.name} 的愿望" }
    end
    redirect_to :back, message
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