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
    require 'number_to_cn'
    @wish = current_user.wishes.new
    @current_count = (current_user.wishes_count + 1).to_cn_words
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
      message = { success: "刚刚认领了 #{@wish.user.name} 的愿望，说到就要做到" }
    end
    redirect_to :back, message
  end

  def confirm_grant
    @wish = Wish.find params[:id]
    @wish.update_attribute(:status, "GRANTED")
    redirect_to :back, success: "恭喜你实现了这个愿望"
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