class PostsController < ApplicationController
  before_action :authenticate_user!

  def home
    @post = Post.new
    timeline_posts
    @user_timeline = current_user.user_timeline
  end

  def index
    @friends = current_user.friends
    @users = User.all
    # @user = current_user
    @post = Post.new
    timeline_posts
    @user_timeline = current_user.user_timeline
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    @timeline_posts ||= Post.all.ordered_by_most_recent.includes(:user)
  end

  def post_params
    params.require(:post).permit(:content, :image, :image_cache)
  end
end
