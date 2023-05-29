# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

p "User Creation Started"
10.times do |i|
  user = User.create(name:Faker::Name.unique.name)
  p "id: #{user.id} name:#{user.name}"
end
p "User Creation Ended"