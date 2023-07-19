# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
admin = User.create(email: 'diegoalejandrosilvarodriguez@gmail.com', name: 'Diego Silva', age: '37', password: '1985bufalo', role: :admin)
author = User.create(email: 'diegosilvarodriguez@hotmail.com', name: 'Diego', age: '37', password: '123456', role: :author)
