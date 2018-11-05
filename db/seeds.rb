users_data = [
  { name: "hyejin", email: "hyejin@gmail.com" },
  { name: "jane", email: "jane.d@gmail.com" },
  { name: "john", email: "john.d@gmail.com" }
]

users_data.each do |data|
  User.create!(data)
end