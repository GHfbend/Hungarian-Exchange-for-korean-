class MemosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_memo, only: [:show, :edit, :update, :destroy]
  before_action :is_owner?, only: [:edit, :update, :destroy]
  before_action :log_impression, only: [:show]
  load_and_authorize_resource
  
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
    1.times { @memo.hashtags.new }
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
  
  def quiz
    
  end
  
  def intro
    
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
  
  def is_owner?
    redirect_to root_path unless current_user == @memo.user or :admin
  end
  
  def log_impression
    @hit_memo = Memo.find(params[:id])
    @hit_memo.impressions.create(ip_address: request.remote_ip, user_id:current_user.id)
  end
end