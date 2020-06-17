User.destroy_all
Exercise.destroy_all
Category.destroy_all

# julio = User.create({
#     name: "Julio",
#     email: "Julio.chazari@gmail.com",
#     age: 20,
#     height: "5'8",
#     weight: 180,
#     gender: "Male",
#     page_setup_complete: false
# })

# cardio = Category.create({name: "Cardio"})

# running = Exercise.create({
#     name: "Running",
#     description: "Run a mile bud.",
#     sets: nil,
#     reps: nil,
#     category_id: cardio.id,
#     user_id: julio.id
# })

cardio = Category.create({name: "Cardio"})

running = Exercise.create({
    name: "Running",
    description: "Run a mile bud.",
    sets: nil,
    reps: nil,
    category_id: cardio.id
})

jumping = Exercise.create({
    name: "Jumping Jacks",
    description: "Extend your arms out, feet spread apart, and proceed to do Jumping Jacks",
    sets: 1,
    reps: 20,
    category_id: cardio.id
})

burpees = Exercise.create({
    name: "Burpees",
    description: "Stand up straight, jump, fall into a push-up, and get back up",
    sets: 1,
    reps: 20,
    category_id: cardio.id
})

side = Exercise.create({
    name: "Side to Side Jump Squats",
    description: "Feet together, extend one leg, squat, and come together",
    sets: 1,
    reps: 15,
    category_id: cardio.id
})

high = Exercise.create({
    name: "High Knee Runs",
    description: "Run in a straight line, while doing so bring your knees to your chest",
    sets: 1,
    reps: 20,
    category_id: cardio.id
})



strength =  Category.create({name: "Strength Building"})

bicep = Exercise.create({
    name: "Bicep Curls",
    description: "Lift some dumbbells that you’re most comfortable with",
    sets: 2,
    reps: 30,
    category_id: strength.id
})

push = Exercise.create({
name: "Push-Ups",
description: "Lay on the floor with your arms right under your chest and push",
sets: 2,
reps: 20,
category_id: strength.id
})

sit = Exercise.create({
name: "Sit-Ups",
description: "Lay your back on the floor, bend your knees, cross your arms, and use your core to pull yourself up",
sets: 2,
reps: 50,
category_id: strength.id
})

squates = Exercise.create({
    name: "Squates",
    description: "Set the weight that you’re most comfortable with, feet sprid apart, and with your lower-body slowly dip",
    sets: 2,
    reps: 20,
    category_id: strength.id
    })

 tricep = Exercise.create({
name: "Tricep Dips",
description: "Have your back facing a chair, reach behind you and place your hands, extend your legs and dip",
sets: 2,
reps: 25,
category_id: strength.id
})


balance = Category.create({name: "Balance Exercises"})

march = Exercise.create({
    name: "In-Place March",
    description: "March in place while having high-knees",
    sets: 2,
    reps: 40,
    category_id: balance.id
    })

tight = Exercise.create({
name: "TightRope Walk",
description: "Standing up straight, hold your arms straight out from your sides, and slowly walk",
sets: 2,
reps: 20,
category_id: balance.id
})

leg = Exercise.create({
name: "Side Leg Raises",
description: "Stand with your feet hip-width apart, and place your hands on your hips. Then lift your right leg up and to the side of your body and hold for 30 seconds",
sets: 2,
reps: 20,
category_id: balance.id
})

heel = Exercise.create({
name: "Heel Raises",
description: "Stand upright with your feet hip-width apart. Raise both of your heels at the same time, so you’re balancing on your toes, hold for a few seconds and gently lower your heels back to the ground",
sets: 2,
reps: 15,
category_id: balance.id
})

chair = Exercise.create({
name: "Chair Sits",
description: "Stand upright with your back facing a chair and your feet hip-width apart, and slowly lower your hip onto the chair",
sets: 3,
reps: 10,
category_id: balance.id
})




# Cardio Exercises
# Running
# Des: Run for a mile
# Sets: 1
# Reps: 1
# Jumping Jacks
# sets: 1
# reps: 20
# Burpees
# des:
# sets: 1
# reps: 20
# Side to Side Jump Squats
# Sets: 1
# Reps: 15
# High Knee Runs
# Sets: 1
# Reps: 20
# Strength Building
# Bicep Curls
# Des: Lift some dumbbells that you’re most comfortable with
# Sets: 2
# Reps: 30
# Push-ups
# Des: 
# Sets: 2
# Reps: 20
# Sit-ups
# Des:
# Sets: 2
# Reps: 50
# Squotes
# Des: Set the weight that you’re most comfortable with
# Sets: 2
# Reps: 20
# Tricep Dips
# Des: 
# Sets: 2
# Reps: 25
# Balance Exercises
# In-Place Marches
# Des: March in place while having high-knees
# Sets: 2
# Rps: 40
# Tightrope Walk
# Des: Standing up straight, hold your arms straight out from your sides, and slowly walk
# Sets: 2
# Reps: 20
# Side Leg Raises
# Des: Stand with your feet hip-width apart, and place your hands on your hips. Then lift your right leg up and to the side of your body and hold for 30 seconds
# Sets:2
# Reps: 20
# Heel Raises
# Des: Stand upright with your feet hip-width apart. Raise both of your heels at the same time, so you’re balancing on your toes, hold for a few seconds and gently lower your heels back to the ground
# Sets: 2
# Reps: 15
# Chair Sits
# Des: Stand upright with your back facing a chair and your feet hip-width apart, and slowly lower your hip onto the chair
# Sets: 3
# Reps: 10