class CommentsController < ApplicationController
  before_action :set_memo
  before_action :set_comment, only: [:destroy]
  before_action :check_ownership!, only: [:destroy]

  def create
    @comment = @memo.comments.new(comment_params)
    @comment.save
    redirect_to @memo
  end

  def destroy
    @comment.destroy
    redirect_to @memo
  end

  private
  def set_memo
    @memo = Memo.find(params[:memo_id])
  end

  def set_comment
    @comment = @memo.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
  
  def check_ownership! 
    @comment = Comment.find_by(id: params[:id]) 
    redirect_to root_path if @comment.user.id != current_user.id 
  end
end
