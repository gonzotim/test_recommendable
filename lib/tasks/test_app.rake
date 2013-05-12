task :test_app  => :environment do
  namespace :user  do
    puts "create posts"
    post_names = ['apple', 'banaana', 'kiwi', 'watermelon', 'steak', 'eggs', 'bacon']
    post_names.each do |post_name|
      @post = Post.where(:name => post_name).first_or_create
      @post.save
      puts "saved "+post_name
    end
    
    puts "create users"
    user_names = ['Veggie Steve', 'Meety Mike', 'Balanced Berty']
    user_names.each do |user_name|
      @user = User.where(:name => user_name).first_or_create
      @user.save
      puts "saved User:  "+ user_name
      puts "clear likes"
      @posts = Post.all
      @posts.each do |post|
        @user.unlike(post)
        puts "unliking"
      end
    end

    $redis.set('chunky', 'bacon')
    puts "Test Redis: "+ $redis.get('chunky')

    b_user = User.where(:name => 'Veggie Steve').first
    b_posts = Post.where(:name => ['apple', 'banaana', 'kiwi', 'watermelon'])
    b_posts.each do |b_post|
      puts "User voting: " + b_post.name
      b_user.like(b_post)
    end
    puts 'b_user has ' + b_user.likes_count.to_s 
    
    b_user = User.where(:name => 'Meety Mike').first
    b_posts = Post.where(:name => ['steak', 'eggs', 'bacon'])
    b_posts.each do |b_post|
      puts "User voting: " + b_post.name
      b_user.like(b_post)
    end
    puts 'b_user has ' + b_user.likes_count.to_s

    b_user = User.where(:name => 'Balanced Berty').first
    b_posts = Post.all
    b_posts.each do |b_post|
      puts "User voting: " + b_post.name
      b_user.like(b_post)
    end
    puts 'b_user has ' + b_user.likes_count.to_s
      
    puts ''
    rec_user = User.where(:name => 'Veggie Steve').first
    recs = rec_user.recommended_posts
    puts 'recommendations' + recs.to_s
    
    
        # 
        # 
        # puts "Set up users"
        # @post
        # @user = User.where(:name => 'persona_oh_shit').first_or_create
        # @posts = Post.find([5, 15, 16, 19, 20, 21, 26, 30, 39])
        # @gifs.each do |gif|
        #   @user.like(gif)
        #   puts "user " + @user.name.to_s + "likes gif " + gif.id.to_s
        # end
  end
   
end