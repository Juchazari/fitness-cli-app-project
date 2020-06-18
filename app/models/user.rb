class User < ActiveRecord::Base
    has_many :user_fav_exercise
    has_many :exercises, through: :user_fav_exercise
    has_many :categories, through: :exercises
end