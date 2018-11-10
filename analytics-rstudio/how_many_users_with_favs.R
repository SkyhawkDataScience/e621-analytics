source('_storage.R')
source('_util.R')

users = read.users()
printf('number of users: %d', length(users$id))

users = subset(users, favorite_count > 0)
printf('number of users with favs: %d', length(users$id))

printf('mean favorite_count: %d', round(mean(users$favorite_count)))

views = sum(ceiling(users$favorite_count / 320))
printf('number of pageviews: %d', views)