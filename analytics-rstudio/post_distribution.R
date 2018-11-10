source('_storage.R')
source('_util.R')

posts = read.posts.kpi()
posts = posts[order(posts$created_at),]

posts$created_at.year = year(posts$created_at)
posts$created_at.month = month(posts$created_at)
posts$created_at.dow = weekdays(posts$created_at)
posts$created_at.hour = hour(posts$created_at)

posts.byyear <- aggregate(id ~ created_at.year, posts, length)
posts.bymonth <- aggregate(id ~ created_at.month, posts, length)
posts.bydow <- aggregate(id ~ created_at.dow, posts, length)
posts.byhour <- aggregate(id ~ created_at.hour, posts, length)

barplot(
  posts.byyear$id,
  names.arg = posts.byyear$created_at.year,
  xlab = 'Year',
  main = "User Accounts Created per Year"
)
barplot(
  posts.bymonth$id,
  names.arg = posts.bymonth$created_at.month,
  xlab = 'Month',
  main = "User Accounts Created per Month"
)
barplot(
  posts.byhour$id,
  names.arg = posts.byhour$created_at.hour,
  xlab = 'Hour of the day',
  main = "User Accounts Created per Hour"
)
