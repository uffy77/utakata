# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create update destroy my_search]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    tanka = @post.tanka
    tanka = Post.add_html_tag(tanka)
    @post.tanka = tanka
    if @post.save
      redirect_to posts_path, notice: '短歌を投稿しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = @post.errors.full_messages
    end
  end

  def index
    @posts = Post.all.order('created_at DESC').page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
  end

  def edit
    @post = Post.find(params[:id])
    @post.tanka = Post.remove_html_tag(@post.tanka)
  end

  def update
    @post = Post.find(params[:id])
    # 変数に代入しないと中身を変更できない
    pp = post_params
    tanka = pp[:tanka]
    tanka = Post.add_html_tag(tanka)
    pp[:tanka] = tanka
    if @post.update(pp)
      redirect_to post_path(id: @post.id), notice: '短歌を更新しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = '更新できませんでした'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to timeline_user_path(id: current_user.id), notice: '短歌を削除しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = '削除できませんでした'
    end
  end

  def search
    redirect_to users_path if params[:search].blank?
    @search = params[:search]
    @posts = Post.search(@search).order('created_at DESC').page(params[:page])
  end

  def my_search
    @search = params[:search]
    @posts = current_user.posts.search(params[:search]).order('created_at DESC').page(params[:page])
  end

  def followers
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    followers = Follow.where(followable_type: 'Post', followable_id: @post.id).order('created_at DESC').pluck(:follower_id)
    @users = followers.present? ?
      User.where(id: followers).order_by_ids(followers).page(params[:page]) :
      User.none.page(params[:page])
  end

  def popular
    popular_posts = Follow.where(['followable_type = :type and created_at >= :time', { type: 'Post', time: (Time.now - 1.days) }]).group(:followable_id).count(:followable_id)
    if popular_posts.present?
      popular_posts_ids = Hash[popular_posts.sort_by { |_, v| -v }].keys
      @posts = Post.where(id: popular_posts_ids).order_by_ids(popular_posts_ids).page(params[:page])
    else
      @posts = Post.none.page(params[:page])
    end
  end

  private

  def post_params
    params.require(:post).permit(:tanka)
  end
end
