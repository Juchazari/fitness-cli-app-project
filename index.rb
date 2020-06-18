require_relative './config/environment.rb'
ActiveRecord::Base.logger = nil

# Prompt
def prompt
    TTY::Prompt.new(interrupt: :exit, active_color: :cyan)
end

# Title
def title
    Artii::Base.new()
end

# Users Individual Exercise
def user_page_exercise(user, exercise_name)

    puts title.asciify("#{exercise_name}").colorize(:color => :blue, :background => :light_black)
    puts ""

    current_exercise = Exercise.find_by(name: exercise_name)

    puts "Description: #{current_exercise.description}".colorize(:yellow)
    puts "Sets: #{current_exercise.sets}".colorize(:yellow)
    puts "Reps: #{current_exercise.reps}".colorize(:yellow)

    exercise_is_completed = UserFavExercise.find_by(user_id: user.id, exercise_id: current_exercise.id, completed: true)

    selection = nil

    if exercise_is_completed
        selection = prompt.select("Would you like to remove it?", [
            "Remove Exercise",
            "Mark As Not Completed?",
            "Go Back".colorize(:blue)
        ])
    else
        selection = prompt.select("Would you like to remove it?", [
            "Remove Exercise",
            "Mark As Completed?",
            "Go Back".colorize(:blue)
        ])
    end

    case selection
    when "Remove Exercise"
        exercise = UserFavExercise.find_by({user_id: user.id, exercise_id: current_exercise.id})
        UserFavExercise.destroy(exercise.id)
        system "clear"
        user_page_exercises(user)
    when "Mark As Not Completed?"
        exercise_is_completed.completed = false
        exercise_is_completed.save
        system "clear"
        user_page_exercise(user, exercise_name)
    when "Mark As Completed?"
        exercise = UserFavExercise.find_by({user_id: user.id, exercise_id: current_exercise.id})
        exercise.completed = true
        exercise.save
        system "clear"
        user_page_exercise(user, exercise_name)
    when "Go Back".colorize(:blue)
        system "clear"
        user_page_exercises(user)
    end

end

# Users Added Exercises (My Exercises)
def user_page_exercises(user)

    user_exercises_added = UserFavExercise.where(user_id: user.id)

    selection = nil

    exercise_names = ["Go Back".colorize(:blue)]
    
    if user_exercises_added.length > 0

        user_exercises_added.each do |e|
            exercise_names.unshift(e.exercise.name)
        end

        selection = prompt.select(
            "Here are your added exercises! Total: #{exercise_names.length - 1}", 
            exercise_names, 
            per_page: 25
        )

    else
        selection = prompt.select("You have no exercises added!", exercise_names)
    end

    case selection
    when "Go Back".colorize(:blue)
        system "clear"
        user_page(user)
    else
        system "clear"
        user_page_exercise(user, selection)
    end

end

# User Profile Editor
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

# Users Profile (My Profile)
def user_page_profile(user)

    selection = prompt.select(
        "Edit Profile:",
        [
            "Name: #{user.name}",
            "Email: #{user.email}",
            "Weight: #{user.weight}",
            "Height: #{user.height}",
            "Age: #{user.age}",
            "Gender: #{user.gender}",
            "Password: **********",
            "Go Back".colorize(:blue)
        ],
        per_page: 10
    )

    if selection == "Go Back".colorize(:blue)
        system "clear"
        user_page(user)
    else
        user_profile_edit(user, selection)
    end

end

# User page
def user_page(user)

    puts title.asciify("#{user.name}").colorize(:color => :blue, :background => :light_black)
    puts ""

    completed_exercises = UserFavExercise.where(user_id: user.id, completed: true)

    puts "Completed Exercises: #{completed_exercises.length}".colorize(:cyan).underline
    selection = prompt.select("Welcome to your page!", ["My Profile", "My Exercises", "Go Back".colorize(:blue)])

    case selection
    when "My Profile"
        system "clear"
        user_page_profile(user)
    when "My Exercises"
        system "clear"
        user_page_exercises(user)
    when "Go Back".colorize(:blue)
        system "clear"
        app_home(user)
    end

end

# Individual exercise
def app_exercise(user, exercise_name)

    puts title.asciify("#{exercise_name}").colorize(:color => :blue, :background => :light_black)
    puts ""

    current_exercise = Exercise.find_by(name: exercise_name)

    puts "Description: #{current_exercise.description}".colorize(:yellow)
    puts "Sets: #{current_exercise.sets}".colorize(:yellow)
    puts "Reps: #{current_exercise.reps}".colorize(:yellow)

    exercise_is_added = UserFavExercise.find_by(user_id: user.id, exercise_id: current_exercise.id)

    selection = nil
    
    if exercise_is_added 
        selection = prompt.select("Already Added! Would like to remove it?", [
            "Remove Exercise",
            "Go Back".colorize(:blue),
            "Go Home".colorize(:blue)
        ])
    else
        selection = prompt.select("Add this exercise or go back:", [
            "Add Exercise",
            "Go Back".colorize(:blue),
            "Go Home".colorize(:blue)
        ])
    end

    case selection
    when "Add Exercise"
        puts "Added!"
        UserFavExercise.create({user_id: user.id, exercise_id: current_exercise.id})
        system "clear"
        app_exercise(user, exercise_name)
    when "Remove Exercise"
        exercise = UserFavExercise.find_by(exercise_id: current_exercise.id)
        exercise.destroy
        system "clear"
        app_exercise(user, exercise_name)
    when "Go Back".colorize(:blue)
        system "clear"
        app_exercises(user, current_exercise.category.name)
    when "Go Home".colorize(:blue)
        system "clear"
        app_home(user)
    end

end

# List of exercises for a Category
def app_exercises(user, category)

    puts title.asciify("#{category}").colorize(:color => :blue, :background => :light_black)
    puts ""

    select_options = ["Go Back".colorize(:blue), "Go Home".colorize(:blue)]

    Exercise.all.each do | exercise |
        if exercise.category.name == category
            select_options.unshift(exercise.name)
        end
    end

    selection = prompt.select("Choose any exercise to view!", select_options, per_page: 25)

    case selection
    when "Go Back".colorize(:blue)
        system "clear"
        app_categories(user)
    when "Go Home".colorize(:blue)
        system "clear"
        app_home(user)
    else
        system "clear"
        app_exercise(user, selection)
    end

end

# Shows the list of al categories
def app_categories(user)

    puts title.asciify("Workout Categories").colorize(:color => :blue, :background => :light_black)
    puts ""

    select_options = ["Go Back".colorize(:blue)]

    Category.all.each do |c|
        select_options.unshift(c.name)
    end

    selection = prompt.select("Please select any of the following categories", select_options, per_page: 25)

    case selection
    when "Go Back".colorize(:blue)
        system "clear"
        app_home(user)
    else
        system "clear"
        app_exercises(user, selection)
    end

end

# Apps main home page
def app_home(user)

    puts title.asciify("JJ - BUFFS - Fitness").colorize(:color => :blue, :background => :light_black, :mode => :blink)
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

# Sign In Process
def sign_in

    puts "Sing In Process".colorize(:green)
    email = prompt.ask("Please enter your email address:", required: true)

    existing_user = User.find_by(email: email)

    if existing_user
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
    else
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
    end

end

# Account setup - weight, height, etc.
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

# Validations for creating password
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

# Validations for creating email
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

    user = User.create({
        name: name,
        email: email,
        password: bcrypt_password,
        is_logged_in: true
    })

    system "clear"
    message = "Account created!"
    account_setup(user, message)

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

    # Initial startup of the app (Sign In / Sign Up)
    puts title.asciify("JJ - BUFFS - Fitness").colorize(:color => :blue, :background => :light_black)
    puts ""

    message = "Welcome! Select one of the following!"
    selection = prompt.select(message, ["Sign Up", "Sign In", "Exit".colorize(:red)])

    case selection
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