require_relative './config/environment.rb'
ActiveRecord::Base.logger = nil

# let's you go back
def prompt
    prompt = TTY::Prompt.new()
end

# Individual exercise page, shows description, sets, reps
def app_exercise(user, exercise)

    page_title = Artii::Base.new()

    exercise = Exercise.find_by(name: exercise)
    puts page_title.asciify("#{exercise.name}").colorize(:color => :blue, :background => :light_black)
    puts "Description: #{exercise.description}".colorize(:yellow)
    puts "Sets: #{exercise.sets}".colorize(:yellow)
    puts "Reps: #{exercise.reps}".colorize(:yellow)

    existing_exercise = UserFavExercise.find_by(exercise_id: exercise.id)

    selection = nil
    
    if existing_exercise 
        selection = prompt.select("Already Added! Would like to remove it?", [
            "Remove Exercise",
            "Go Back",
            "Go Home"
        ])
    else
        selection = prompt.select("Add this exercise or go back:", [
            "Add Exercise",
            "Go Back",
            "Go Home"
        ])
    end

    case selection
    when "Add Exercise"
        puts "Added!"
        UserFavExercise.create({user_id: user.id, exercise_id: exercise.id})
        system "clear"
        app_exercises(user, exercise.category.name)
    when "Remove Exercise"
        remove_exercise = UserFavExercise.find_by(exercise_id: exercise.id)
        remove_exercise.destroy
        system "clear"
        app_exercises(user, exercise.category.name)
    when "Go Back"
        system "clear"
        app_exercises(user, exercise.category.name)
    when "Go Home"
        system "clear"
        app_home(user)
    end

end

# Shows the list of all exercises within a category
def app_exercises(user, category)

    page_title = Artii::Base.new()
    puts page_title.asciify("#{category}").colorize(:color => :blue, :background => :light_black)

    exercise_list_for_category = ["Go Back", "Go Home"]

    Exercise.all.each do | exercise |
        if exercise.category.name == category
            exercise_list_for_category.unshift(exercise.name)
        end
    end

    picked_exercise = prompt.select("Choose any exercise to view!", exercise_list_for_category)

    if picked_exercise == "Go Back"
        system "clear"
        app_categories(user)
    elsif picked_exercise == "Go Home"
        system "clear"
        app_home(user)
    end

    system "clear"
    app_exercise(user, picked_exercise)
end

# Shows the list of al categories
def app_categories(user)

    page_title = Artii::Base.new()
    puts page_title.asciify("Workout Categories").colorize(:color => :blue, :background => :light_black)

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
    app_exercises(user, workout_categories)

end

def descript_favs(user, exercise)

    page_title = Artii::Base.new()
    puts page_title.asciify("#{exercise}").colorize(:color => :blue, :background => :light_black)
    puts ""

    current_exercise = Exercise.find_by(name: exercise)

    puts "Description: #{current_exercise.description}".colorize(:yellow)
    puts "Sets: #{current_exercise.sets}".colorize(:yellow)
    puts "Reps: #{current_exercise.reps}".colorize(:yellow)

    exercise_completed = UserFavExercise.find_by(user_id: user.id, exercise_id: current_exercise.id, completed: true)

    selection = nil

    if exercise_completed
        selection = prompt.select("Would you like to remove it?", [
            "Remove Exercise",
            "Mark As Not Completed?",
            "Go Back"
        ])
    else
        selection = prompt.select("Would you like to remove it?", [
            "Remove Exercise",
            "Mark As Completed?",
            "Go Back"
        ])
    end

    case selection
    when "Remove Exercise"
        remove_fav = UserFavExercise.find_by({user_id: user.id, exercise_id: current_exercise.id})
        UserFavExercise.destroy(remove_fav.id)
        system "clear"
        user_page_workouts(user)
    when "Mark As Not Completed?"
        exercise_completed.completed = false
        exercise_completed.save
        system "clear"
        user_page_workouts(user)
    when "Mark As Completed?"
        user_update_completed = UserFavExercise.find_by({user_id: user.id, exercise_id: current_exercise.id})
        user_update_completed.completed = true
        user_update_completed.save
        system "clear"
        user_page_workouts(user)
    when "Go Back"
        system "clear"
        user_page_workouts(user)
    end

end

def user_page_workouts(user)

    user_exercises_added = UserFavExercise.where(user_id: user.id)

    selection = nil

    exercise_names = ["Go Back"]
    
    if user_exercises_added.length > 0

        user_exercises_added.each do | fav_exercise |
            exercise_names.unshift(fav_exercise.exercise.name)
        end

        selection = prompt.select("Here are your exercises!", exercise_names)

    else
        selection = prompt.select("You have no exercises added!", exercise_names)
    end

    case selection
    when "Go Back"
        system "clear"
        user_page(user)
    else
        system "clear"
        descript_favs(user, selection)
    end

end

def user_profile_edit(user, info)
    update_column = info.split.shift
    case update_column
    when "Name:"
        name = prompt.ask("Enter your new name:") do |q|
            q.required true
            q.validate /^[a-zA-Z\-\`]++(?: [a-zA-Z\-\`]++)?$/
            q.messages[:valid?] = 'Please enter a valid name'
            q.modify :capitalize
        end
        user.name = name
        user.save
        system "clear"
        user_page_profile(user)
    when "Email:"
        email = create_account_email
        user.email = email
        user.save
        system "clear"
        user_page_profile(user)
    when "Weight:"
        weight = prompt.ask("Please enter your weight:", required: true)
        user.weight = weight
        user.save
        system "clear"
        user_page_profile(user)
    when "Height:"
        height = prompt.ask("Please enter your height:", required: true)
        user.height = height
        user.save
    when "Age:"
        age = prompt.ask("Please enter your age:", required: true)
        user.age = age
        user.save
        system "clear"
        user_page_profile(user)
    when "Gender:"
        gender = prompt.ask("Please enter your gender:", required: true)
        user.gender = gender
        user.save
        system "clear"
        user_page_profile(user)
    when "Password:"
        password = create_account_password
        bcrypt_password = BCrypt::Password.create(password)
        user.password = bcrypt_password
        user.save
        system "clear"
        user_page_profile(user)
    end

end

def user_page_profile(user)
    selection = prompt.select("Edit Profile:", [
        "Name: #{user.name}",
        "Email: #{user.email}",
        "Weight: #{user.weight}",
        "Height: #{user.height}",
        "Age: #{user.age}",
        "Gender: #{user.gender}",
        "Password: **********",
        "Go Back"
    ])
    if selection == "Go Back"
        system "clear"
        user_page(user)
    else
        user_profile_edit(user, selection)
    end
end

#Show fav. wokrout
def user_page(user)

    user_page_title = Artii::Base.new()
    puts user_page_title.asciify("#{user.name}").colorize(:color => :blue, :background => :light_black)
    puts ""
    completed_exercises = UserFavExercise.where(user_id: user.id, completed: true)

    puts "Completed Workouts: #{completed_exercises.length}".colorize(:cyan).underline
    selection = prompt.select("Welcome to your page!", ["My Profile", "My Workouts", "Go Back"])

    case selection
    when "My Profile"
        system "clear"
        user_page_profile(user)
    when "My Workouts"
        system "clear"
        user_page_workouts(user)
    when "Go Back"
        system "clear"
        app_home(user)
    end

end

# Main page for user -- browse workouts, go to my page, logout
def app_home(user)
    welcome_title = Artii::Base.new()
    puts welcome_title.asciify("JJ - BUFFS - Fitness").colorize(:color => :blue, :background => :light_black, :mode => :blink)
    puts ""
    puts "Signed In: #{user.name}".colorize(:color => :cyan).underline
    selection = prompt.select("Please select an option:", [
        "Browse Workouts",
        "My Page",
        "Exit".colorize(:red),
        "Logout".colorize(:light_red)
    ])

    case selection
    when "Browse Workouts"
        system "clear"
        app_categories(user)
    when "My Page"
        system "clear"
        user_page(user)
    when "Exit".colorize(:red)
        system "clear"
        exit
    when "Logout".colorize(:light_red)
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
    email = prompt.ask("Please enter a email address:") do |q|
        q.required true
        q.validate(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
        q.messages[:valid?] = 'Invalid email address'
    end
    existing_user = User.find_by(email: email)
    if existing_user
        system "clear"
        message =  "A user with this email address already exists!"
        selection = prompt.select(message, ["Try Again"])
        if selection == "Try Again"
            system "clear"
            create_account_email
        end
    else
        return email
    end
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

    puts "Sing In Process".colorize(:green)
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
    puts app_title.asciify("JJ - BUFFS - Fitness").colorize(:color => :blue, :background => :light_black)
    puts ""
    message = "Welcome! Select one of the following!"
    response = prompt.select(message, ["Sign Up", "Sign In", "Exit".colorize(:red)])

    case response
    when "Sign Up"
        system "clear"
        create_account
    when "Sign In"
        system "clear"
        sign_in
    when "Exit".colorize(:red)
        system "clear"
        exit
    end
end

system "clear"
run