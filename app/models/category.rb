class Category < ActiveRecord::Base
    has_many :exercises
    belongs_to :user
end