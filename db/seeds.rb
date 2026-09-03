# db/seeds.rb

# --- Admin ---
admin = User.find_or_create_by!(username: "admin") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
end

# --- Regular users ---
usernames = %w[CoolGuy12 Leem buckboarflen pixelqueen retro_gamer night.owl]

users = usernames.map do |username|
  User.find_or_create_by!(username: username) do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end
end

# --- Games ---
games_data = [
  { name: "Marathon", developer: "Bungie", release_date: Date.new(1994, 12, 21) },
  { name: "Minecraft", developer: "Mojang Studios", release_date: Date.new(2011, 11, 18) },
  { name: "Balatro", developer: "LocalThunk", release_date: Date.new(2024, 2, 20) },
  { name: "Binding of Isaac: Rebirth", developer: "Nicalis", release_date: Date.new(2014, 11, 4) },
  { name: "Old School RuneScape", developer: "Jagex", release_date: Date.new(2013, 2, 22) },
  { name: "Hollow Knight", developer: "Team Cherry", release_date: Date.new(2017, 2, 24) },
  { name: "Stardew Valley", developer: "ConcernedApe", release_date: Date.new(2016, 2, 26) },
  { name: "Celeste", developer: "Maddy Makes Games", release_date: Date.new(2018, 1, 25) }
]

games = games_data.map do |data|
  Game.find_or_create_by!(name: data[:name], developer: data[:developer], release_date: data[:release_date])
end

# --- User games (collection entries, some with scores/reviews, some without) ---
reviews = [
  "Absolutely loved this one, couldn't put it down.",
  "Solid game, a few rough edges but worth it.",
  "Not really my style, but I get the appeal.",
  "One of the best I've played this year.",
  nil,
  nil
]

users.each do |user|
  # each user adds a handful of random games to their collection
  games.sample(rand(3..6)).each do |game|
    next if UserGame.exists?(user: user, game: game)

    UserGame.find_or_create_by!(user: user, game: game) do |user_game|
      # some entries get a score/review, some are left unreviewed on purpose
      if [true, false].sample
        user_game.score = rand(0..10)
        user_game.review = reviews.sample
      end
    end
  end
end

# --- Friendships (a mix of accepted, pending sent, pending received) ---
def create_friendship(user, friend, status)
  Friendship.find_or_create_by!(user: user, friend: friend) do |friendship|
    friendship.status = status
  end
end

coolguy, leem, buck, pixel, retro, night_owl = users

# accepted friendships
create_friendship(coolguy, leem, "accepted")
create_friendship(coolguy, buck, "accepted")
create_friendship(leem, pixel, "accepted")

# pending: retro_gamer has sent requests out
create_friendship(retro, coolguy, "pending")
create_friendship(retro, night_owl, "pending")

# pending: night_owl has an incoming request from pixelqueen
create_friendship(pixel, night_owl, "pending")

# buckboarflen and admin are friends, so admin isn't totally isolated
create_friendship(admin, buck, "accepted")

puts "Seeded #{User.count} users, #{Game.count} games, #{UserGame.count} collection entries, #{Friendship.count} friendships."
