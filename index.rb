require_relative './config/environment.rb'
ActiveRecord::Base.logger = nil

# let's you go back
def prompt
    prompt = TTY::Prompt.new()
end

# Individual exercise page, shows description, sets, reps
def exercise_page(user, exercise)
    exercise = Exercise.find_by(name: exercise)
    puts "#{exercise.name}".upcase
    puts "Description: #{exercise.description}"
    puts "Sets: #{exercise.sets}"
    puts "Reps: #{exercise.reps}"
    #prompt = TTY::Prompt.new()
    add_or_back = prompt.select("Add this exercise or go back:", [
        "Add Exercise",
        "Go Back"
    ])
    if add_or_back == "Go Back"
        system "clear"
        exercises_page(user, exercise.category.name)
    elsif add_or_back == "Add Exercise"
        puts "Added!"
        UserFavExercise.create({user_id: user.id, exercise_id: exercise.id})
    end
end

# Shows the list of all exercises within a category
def exercises_page(user, category)
    #prompt = TTY::Prompt.new()

    page_title = Artii::Base.new()
    puts page_title.asciify("#{category}").colorize(:blue)

    exercise_list_for_category = ["Go Back"]
    Exercise.all.each do | exercise |
        if exercise.category.name == category
            exercise_list_for_category.unshift(exercise.name)
        end
    end

    picked_exercise = prompt.select("Choose any exercise to view!", exercise_list_for_category)

    if picked_exercise == "Go Back"
        system "clear"
        categories_page(user)
    end

    system "clear"
    exercise_page(user, picked_exercise)
end

# Shows the list of al categories
def categories_page(user)

    page_title = Artii::Base.new()
    puts page_title.asciify("Workout Categories").colorize(:blue)

    workout_category_array = ["Go Back"]
    Category.all.each do | category |
        workout_category_array.unshift(category.name)
    end

    workout_categories = prompt.select("Please select any of the following categories", workout_category_array)

    if workout_categories == "Go Back"
        system "clear"
        app_home(user)
    end

    system "clear"
    exercises_page(user, workout_categories)

end

def descript_favs(user, exercise)

    page_title = Artii::Base.new()
    puts page_title.asciify("#{exercise}").colorize(:blue)

    some_exer = Exercise.find_by(name: exercise)
    puts "Description: #{some_exer.description}"
    puts "Sets: #{some_exer.sets}"
    puts "Reps: #{some_exer.reps}"

    #prompt = TTY::Prompt.new()
    prompt_response = prompt.select("Would you like to remove it?", [
        "Remove Exercise",
        "Go Back"
    ])

    if prompt_response == "Remove Exercise"
        remove_fav = UserFavExercise.find_by({user_id: user.id, exercise_id: some_exer.id})
        UserFavExercise.destroy(remove_fav.id)
        system "clear"
        user_page(user)
    elsif prompt_response == "Go Back"
        system "clear"
        user_page(user)
    end
end


#Show fav. wokrout
def user_page(user)
    user_page_title = Artii::Base.new()
    puts user_page_title.asciify("#{user.name}").colorize(:blue)

    user_exercises_added = UserFavExercise.where(user_id: user.id)
    exercise_names = ["Go Back"]

    if user_exercises_added.length > 0
        user_exercises_added.each do | fav_exercise |
            exercise_names.unshift(fav_exercise.exercise.name)
        end
    end

    if exercise_names.length > 1
        prompt_select = prompt.select("Here are your exercises!", exercise_names)

        if prompt_select == "Go Back"
            system "clear"
            app_home(user)
        end

        system "clear"
        descript_favs(user, prompt_select)
    else
        prompt_select = prompt.select("You have no exercises added.", exercise_names)

        if prompt_select == "Go Back"
            system "clear"
            app_home(user)
        end
    end

end

# Main page for user -- browse workouts, go to my page, logout
def app_home(user)
    welcome_title = Artii::Base.new()
    puts welcome_title.asciify("JJ - BUFFS - Fitness").colorize(:blue)

    puts "Signed In: #{user.name}"
    selection = prompt.select("Please select an option:", [
        "Browse Workouts",
        "My Page",
        "Exit",
        "Logout"
    ])

    case selection
    when "Browse Workouts"
        system "clear"
        categories_page(user)
    when "My Page"
        system "clear"
        user_page(user)
    when "Exit"
        system "clear"
        exit
    when "Logout"
        system "clear"
        puts "Goodbye!"
        user.is_logged_in = false
        user.save
        run
    end

end

# Account setup (weight, height, age, etc.) after acount creation
def account_setup(user, message)
    puts "#{message} Please proceed setting up your account:"

    weight = prompt.ask("What is your weight?", required: true)
    user.weight = weight

    height = prompt.ask("What is your height?", required: true)
    user.height = height

    age = prompt.ask("What is your age?", required: true)
    user.age = age

    gender = prompt.ask("What is your gender?", required: true)
    user.gender = gender

    user.account_setup_complete = true
    user.save

    system "clear"
    app_home(user)
end

def create_account_email
    email = prompt.ask("Please enter your email address:") do |q|
        q.required true
        q.validate(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
        q.messages[:valid?] = 'Invalid email address'
    end
    existing_user = User.find_by(email: email)
    if existing_user
        system "clear"
        message =  "A user with this email address already exists! Would you like to sign in?"
        selection = prompt.select(message, ["Yes", "Try Again"])
        if selection == "Yes"
            system "clear"
            sign_in
        elsif selection == "Try Again"
            system "clear"
            create_account_email
        end
    end
    email
end

def create_account_password
    password = prompt.ask("Please enter a password:", echo: false) do |q|
        q.required true
        q.validate { |input| input.length > 4 }
        q.messages[:valid?] = "Please enter a password that has more than 4 characters!"
    end
    confirm_password = prompt.ask("Please confirm your password:", echo: false) do |q|
        q.required true
        q.validate { |input| input == password }
        q.messages[:valid?] = "Passwords do not match!"
    end
    password
end

# Sign Up Process
def create_account

    puts "Sing Up Process"
    name = prompt.ask("Please enter your full name:") do |q|
        q.required true
        q.validate /^[a-zA-Z\-\`]++(?: [a-zA-Z\-\`]++)?$/
        q.messages[:valid?] = 'Please enter a valid name'
        q.modify :capitalize
    end

    email = create_account_email()

    password = create_account_password()
    bcrypt_password = BCrypt::Password.create(password)

    user = User.create_account({
        name: name,
        email: email,
        password: bcrypt_password
    })

    system "clear"
    message = "Account created!"
    account_setup(user, message)

end

# Sign In Process
def sign_in

    puts "Sing In Process"
    email = prompt.ask("Please enter your email address:", required: true)
    existing_user = User.find_by(email: email)

    case existing_user
    when nil
        message = "Couldn't find your Account. Would you like to create one?"
        selection = prompt.select(message, ["Yes", "Retry", "Go Home"])
        case selection
        when "Yes"
            create_account
        when "Retry"
            system "clear"
            sign_in
        when "Go Home"
            system "clear"
            run
        end
    else
        check_password = BCrypt::Password.new(existing_user.password)
        password = prompt.ask("Please enter your password:", echo: false) do |q|
            q.required true
            q.validate { |input| check_password == input }
            q.messages[:valid?] = "Please type in the correct password"
        end
        if existing_user.account_setup_complete
            existing_user.is_logged_in = true
            existing_user.save
            system "clear"
            app_home(existing_user)
        else
            message = "Continue setting up!"
            account_setup(existing_user, message)
        end
    end

end

# Beginning of program
def run
    # Checks if a user is logged in, sends to "Home Page" (app_home)
    user_logged_in = User.find_by(is_logged_in: true)
    if user_logged_in
        if user_logged_in.account_setup_complete
            system "clear"
            return app_home(user_logged_in)
        else
            system "clear"
            message = "Continue setting up!"
            return account_setup(user_logged_in, message)
        end
    end

    # If no user is logged in, will begin as the first startup of the app
    app_title = Artii::Base.new()
    puts app_title.asciify("JJ - BUFFS - Fitness").colorize(:blue)

    message = "Welcome! Select one of the following!"
    response = prompt.select(message, ["Sign Up", "Sign In", "Exit"])

    case response
    when "Sign Up"
        system "clear"
        create_account
    when "Sign In"
        system "clear"
        sign_in
    when "Exit"
        system "clear"
        exit
    end
end

system "clear"
run