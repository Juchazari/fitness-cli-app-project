class Exercise < ActiveRecord::Base
    has_many :user_fav_exercise
    has_many :users, through: :user_fav_exercise
    belongs_to :category
end
