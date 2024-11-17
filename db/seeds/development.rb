# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Example:

#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# users

if Rails.env.development? || Rails.env.test?
  31.times do
    User.create!(name: Faker::Games::Overwatch.unique.hero,
                password: "password",
                password_confirmation: "password")
  end

  user_ids = User.ids

  # programs
  50.times do |index|
    user = User.find(user_ids.sample)
    user.programs.create!(title: "タイトル#{index}",
                          body: "本文#{Faker::Games::Overwatch.quote}")
  end

  program_ids = Program.ids

  # letterboxes
  100.times do |index|
    program = Program.find(program_ids.sample)
    program.letterboxes.create!(title: "タイトル#{index}",
                                body: "本文#{Faker::Games::Overwatch.quote}")
  end

  letterbox_ids = Letterbox.ids

  # letters
  100.times do |index|
    letterbox = Letterbox.find(letterbox_ids.sample)
    letterbox.letters.create!(title: "タイトル#{index}",
                              body: "本文#{Faker::Games::Overwatch.quote}",
                              user_id: user_ids.sample )
  end
end