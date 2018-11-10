source('_storage.R')
source('_util.R')

users = read.users()

users$year = year(users$created_at)
users$month = floor((month(users$created_at) + 2) / 3)

users = aggregate(favorite_count ~ year + month, users, mean)

users$created_at = ymd(users$year * 10000 + (users$month * 3 - 2) * 100 + 1)

plot(
    x=users$created_at,
    xlab="User account created",
    y=users$favorite_count,
    ylab="Mean favorite count",
    type="h"
)