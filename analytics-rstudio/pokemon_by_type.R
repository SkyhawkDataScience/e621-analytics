if (!exists('pokemon_by_name'))
{
  source('pokemon_by_name.R')
}

posts.count <- aggregate(count ~ identifier.x, pokemon_by_name, sum)
posts.min <- aggregate(cbind(rating.min, fav_count.min, score.min) ~ identifier.x, pokemon_by_name, min)
posts.max <- aggregate(cbind(rating.max, fav_count.max, score.max) ~ identifier.x, pokemon_by_name, max)
posts.sum <- aggregate(cbind(rating.sum, fav_count.sum, score.sum) ~ identifier.x, pokemon_by_name, sum)
posts.sum$rating.mean <- posts.sum$rating.sum / posts.count$count
posts.sum$fav_count.mean <- posts.sum$fav_count.sum / posts.count$count
posts.sum$score.mean <- posts.sum$score.sum / posts.count$count

pokemon_by_type <- merge(
    merge(posts.min, posts.max),
    merge(posts.sum, posts.count)
)

remove(posts.min, posts.max, posts.sum, posts.count)