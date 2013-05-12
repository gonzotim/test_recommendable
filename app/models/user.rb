class User < ActiveRecord::Base
  attr_accessible :name
  recommends :posts
  
end
