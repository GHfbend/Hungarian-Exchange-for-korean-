class MemosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_memo, only: [:show, :edit, :update, :destroy]
  
  def index
    @memos = Memo.all
    if params[:search]
        @memos = Memo.search(params[:search]).order("created_at DESC").page(params[:page]).per(10)
    else
      @memos = Memo.all.order('created_at DESC').page(params[:page]).per(10)
    end
  end

  def new
    @memo = Memo.new
    3.times { @memo.hashtags.new }
  end
  
  def show
  end

  def create
    @memo = Memo.new(memo_params)
      1.times do |h|
      tag = hashtag_params[:hashtags_attributes]["#{h}"]["title"]
      a = Hashtag.find_or_create_by(title: tag)
      @memo.hashtags << a
    end
    
    if @memo.save
      redirect_to @memo
    else
      render :new
    end
  end

  def edit
  end

  def update
    @memo.update(memo_params)
    
    redirect_to @memo
  end

  def destroy
    @memo.destroy
    
    redirect_to memos_path
  end
  
  private
  def set_memo
    @memo = Memo.find(params[:id])
  end
  
  def memo_params
    params.require(:memo).permit(:title, :content, :user_id)
  end
  
  def hashtag_params
    params.require(:memo).permit(hashtags_attributes: [:title])
  end
end