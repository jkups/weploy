# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Timesheet.destroy_all
User.destroy_all

u1 = User.create!(
  first_name: 'John',
  last_name: 'Smith',
  admin: false,
  email: 'john@smith.com',
  password: 'chicken'
)

u2 = User.create!(
  first_name: 'Jane',
  last_name: 'Doe',
  admin: false,
  email: 'jane@doe.com',
  password: 'chicken'
)

t1 = Timesheet.new(
  date_of_entry: '2021-02-21',
  start_time: '2020-02-21 15:30:00',
  finish_time: '2020-02-21 20:00:00',
  user_id: u1.id,
  status: 'pending'
)
t1.calculated_amount
t1.save

t2 = Timesheet.new(
  date_of_entry: '2021-01-05',
  start_time: '2021-01-05 12:00:00',
  finish_time: '2021-01-05 20:15:00',
  user_id: u1.id,
  status: 'pending'
)
t2.calculated_amount
t2.save

t3 = Timesheet.new(
  date_of_entry: '2021-03-17',
  start_time: '2021-03-17 04:00:00',
  finish_time: '2021-03-17 21:30:00',
  user_id: u2.id,
  status: 'pending'
)
t3.calculated_amount
t3.save
