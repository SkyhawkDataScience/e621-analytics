source('_storage.R')
source('_util.R')

users = read.users()
users = users[order(users$created_at),]
users = users[-(1:2),] # there are two invalid users

users$created_at.year = year(users$created_at)
users$created_at.month = month(users$created_at)
users$created_at.dow = weekdays(users$created_at)
users$created_at.hour = hour(users$created_at)

users.byyear <- aggregate(id ~ created_at.year, users, length)
users.bymonth <- aggregate(id ~ created_at.month, users, length)
users.bydow <- aggregate(id ~ created_at.dow, users, length)
users.byhour <- aggregate(id ~ created_at.hour, users, length)

barplot(
  users.byyear$id,
  names.arg = users.byyear$created_at.year,
  xlab = 'Year',
  main = "User Accounts Created per Year"
)
barplot(
  users.bymonth$id,
  names.arg = users.bymonth$created_at.month,
  xlab = 'Month',
  main = "User Accounts Created per Month"
)
barplot(
  users.bydow$id,
  names.arg = as.character(users.bydow$created_at.dow),
  xlab = 'Day of Week',
  main = "User Accounts Created per Day of Week"
)
barplot(
  users.byhour$id,
  names.arg = users.byhour$created_at.hour,
  xlab = 'Month',
  main = "User Accounts Created per Month"
)
