class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

      logger.info "create posts"
      post_names = ['apple', 'banaana', 'kiwi', 'watermelon', 'steak', 'eggs', 'bacon']
      post_names.each do |post_name|
        @post = Post.where(:name => post_name).first_or_create
        @post.save
        logger.info "saved "+post_name
      end

      logger.info "create users"
      user_names = ['Veggie Steve', 'Meety Mike', 'Balanced Berty']
      user_names.each do |user_name|
        @user = User.where(:name => user_name).first_or_create
        @user.save
        logger.info "saved User:  "+ user_name
        logger.info "clear likes"
        @posts = Post.all
        @posts.each do |post|
          @user.unlike(post)
          logger.info "unliking"
        end
      end

      $redis.set('chunky', 'bacon')
      logger.info "Test Redis: "+ $redis.get('chunky')

      b_user = User.where(:name => 'Veggie Steve').first
      b_posts = Post.where(:name => ['apple', 'banaana', 'kiwi', 'watermelon'])
      b_posts.each do |b_post|
        logger.info "User voting: " + b_post.name
        b_user.like(b_post)
      end
      logger.info 'b_user has ' + b_user.likes_count.to_s 

      b_user = User.where(:name => 'Meety Mike').first
      b_posts = Post.where(:name => ['steak', 'eggs', 'bacon'])
      b_posts.each do |b_post|
        logger.info "User voting: " + b_post.name
        b_user.like(b_post)
      end
      logger.info 'b_user has ' + b_user.likes_count.to_s

      b_user = User.where(:name => 'Balanced Berty').first
      b_posts = Post.all
      b_posts.each do |b_post|
        logger.info "User voting: " + b_post.name
        b_user.like(b_post)
      end
      logger.info 'b_user has ' + b_user.likes_count.to_s

      logger.info ''
      rec_user = User.where(:name => 'Veggie Steve').first
      recs = rec_user.recommended_posts
      logger.info 'recommendations' + recs.to_s
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
