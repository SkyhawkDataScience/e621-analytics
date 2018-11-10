source('_storage.R')
source('_util.R')

users = read.users()
users = users[order(-users$favorite_count), c('id', 'name', 'created_at', 'favorite_count')]

users = head(users, 20)

plot(y=users$favorite_count, x=users$created_at, type="h")