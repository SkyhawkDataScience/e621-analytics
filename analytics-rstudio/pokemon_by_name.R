source('_storage.R')
source('_util.R')

if (!exists('posts'))
{
  print('Reading CSV')
  posts.kpi <- read.posts.kpi()
  posts.tags <- read.posts.tags()
  pkmn <- read.csv('../data/pokedex.pkmn.csv.gz')
  pkmn.types <- read.csv('../data/pokedex.pkmn.types.csv.gz')
  types <- read.csv('../data/pokedex.types.csv.gz')

  print('Dropping irrelevant samples')
  posts <- subset(posts.tags, tag %in% pkmn$identifier)
  posts <- merge(posts, posts.kpi[,c('id', 'rating', 'score', 'fav_count')])
}

print('Calculating statistics')
posts.count <- aggregate(id ~ tag, posts, length)
colnames(posts.count) <- c('tag', 'count')
posts.min <- aggregate(cbind(score, fav_count, rating) ~ tag, posts, min)
colnames(posts.min) <- c('tag', 'score.min', 'fav_count.min', 'rating.min')
posts.mean <- aggregate(cbind(score, fav_count, rating) ~ tag, posts, mean)
colnames(posts.mean) <- c('tag', 'score.mean', 'fav_count.mean', 'rating.mean')
posts.max <- aggregate(cbind(score, fav_count, rating) ~ tag, posts, max)
colnames(posts.max) <- c('tag', 'score.max', 'fav_count.max', 'rating.max')
posts.var <- aggregate(cbind(score, fav_count, rating) ~ tag, posts, popvar)
colnames(posts.var) <- c('tag', 'score.var', 'fav_count.var', 'rating.var')
posts.sum <- aggregate(cbind(score, fav_count, rating) ~ tag, posts, sum)
colnames(posts.sum) <- c('tag', 'score.sum', 'fav_count.sum', 'rating.sum')

print('Merging results')
pokemon_by_name <- merge(
  merge(
    merge(
      pkmn.types, types, by.x = 'type_id', by.y = 'id'
    ),
    pkmn, by.x = 'pokemon_id', by.y = 'id'
  ),
  merge(
    merge(posts.min, posts.max),
    merge(
      merge(posts.mean, posts.var),
      merge(posts.count, posts.sum)
    )
  ),
  by.x = 'identifier.y',
  by.y = 'tag'
)

remove(posts.kpi, posts.tags, pkmn, pkmn.types, types, posts.count, posts.min, posts.mean, posts.max, posts.var, posts.sum)