# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Page.create!(name: 'Home', body: '# Welcome to Paint and Sip', publish: true)
Page.create!(name: 'Gallery', publish: true)

User.create!(username: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password')
