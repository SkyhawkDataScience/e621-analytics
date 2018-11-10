library('readr')
library('anytime')

read.csv <- function(filename)
{
  return(read_csv(filename, col_types = cols()))
}

read.posts.kpi <- function(filename = '../data/posts.kpi.csv.gz')
{
  posts <- read_csv(filename, col_types = cols(
    rating = col_factor(c('s', 'q', 'e'), ordered = TRUE)
  ))
  posts$created_at = utctime(posts$created_at)
  return(posts)
}

read.posts.info <- function(filename = '../data/posts.info.csv.gz')
{
  return(read_csv(filename, col_types = cols(
    status = col_factor(c('active', 'pending', 'flagged', 'deleted')),
    has_comments = col_logical(),
    has_notes = col_logical(),
    has_children = col_logical()
  )))
}

read.posts.tags <- function(filename = '../data/posts.tags.csv.gz')
{
  return(read_csv(filename, col_types = cols(
    id = col_integer(),
    tag = col_character()
  )))
}

read.tags <- function(filename = '../data/tags.csv.gz')
{
  return(read_csv(filename, col_types = cols(
    id = col_integer(),
    name = col_character(),
    count = col_integer(),
    type = col_factor(c(0, 1, 2, 3, 4, 5))
  )))
}

read.posts.favs <- function(filename = '../data/posts.favs.csv.gz')
{
  return(read_csv(filename, col_types = cols()))
}

read.posts.content <- function(filename = '../data/posts.content.old.csv.gz')
{
  return(read_csv(filename, col_types = cols(
    file_ext = col_factor(c('jpg', 'gif', 'png', 'swf', 'webm'))
  )))
}

read.posts.artists <- function(filename = '../data/posts.artists.csv.gz')
{
  return(read_csv(filename, col_types = cols()))
}

read.artists.info <- function(filename = '../data/artists.info.csv.gz')
{
  return(read_csv(filename, col_types = cols(
    is_active = col_logical()
  )))
}

read.artists.urls <- function(filename = '../data/artists.urls.csv.gz')
{
    return(read_csv(filename, col_types = cols()))
}

read.users <- function(filename = '../data/users.csv.gz')
{
  users <- read_csv(filename, col_types = cols())
  users$created_at = utctime(users$created_at)
  return(users)
}