require 'bcrypt'
require_relative './config/environment.rb'

# password = gets.chomp
# hash_password = BCrypt::Password.create(password)

# puts hash_password == "testing123"

# email = gets.chomp.downcase
# puts "Downcased Email: #{email}"

#===========================================================

prompt = TTY::Prompt.new()

# prompt_response = prompt.ask("What is your name?") do |q|
#     q.required true
#     q.validate /\A\w+\Z/
#     q.modify   :capitalize
# end

# puts prompt_response

# password = prompt.ask('Password:', echo: false)
# confirm_password = prompt.ask('Confirm Password:', echo: false)

# puts password
# puts confirm_password

# email = prompt.ask('What is your email?') do |q|
#     q.required true
#     q.validate(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
#     q.messages[:valid?] = 'Invalid email address'
# end

# puts email

password = BCrypt::Password.create("password123")
hashed_password = BCrypt::Password.new(password)

puts password
puts hashed_password
puts hashed_password == "password123"