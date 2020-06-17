class User < ActiveRecord::Base
    has_many :user_fav_exercise
    has_many :exercises, through: :user_fav_exercise
    has_many :categories, through: :exercises

    def self.create_account(user_info)
        User.create({
            name: user_info[:name],
            email: user_info[:email],
            password: user_info[:password],
            is_logged_in: true
        })
    end

end