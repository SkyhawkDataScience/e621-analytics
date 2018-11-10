library('fastmatch')
source('_storage.R')
source('_util.R')

if (!exists('posts'))
{
    users <- read.users();
    posts <- read.posts.kpi();
    posts.tags <- read.posts.tags();
    posts.favs <- read.posts.favs();
    posts.content <- read.posts.content()[c('id', 'file_ext', 'source')]
    posts.artists <- read.posts.artists();
}

tagged <- function(tags)
{
  return(subset(posts, id %in% taggedids(tags)))
}

howmanytagged <- function(tags)
{
  return(length(taggedids(tags)))
}

taggedids <- function(tags)
{
  ids = posts$id

  for (tag in tags)
  {
    if (negate <- substring(tag, 1, 1) == '-') {
      tag <- substring(tag, 2)
    }

    if (substring(tag, 1, 7) == 'rating:') {
      pids <- posts$id[posts$rating == tolower(substring(tag, 8))]
    } else if (substring(tag, 1, 5) == 'type:') {
      pids <- posts.content$id[posts.content$file_ext == substring(tag, 6)]
    } else if (substring(tag, 1, 7) == 'artist:') {
      pids <- posts.artists$id[posts.artists$artist == substring(tag, 8)]
    } else if (substring(tag, 1, 4) == 'fav:') {
      pids <- posts.favs$id[posts.favs$user_id == users$id[users$name == substring(tag, 5)]]
    } else if (substring(tag, 1, 7) == 'source:') {
      pids <- posts.content$id[grep(substring(tag, 8), post.content$source)]
    } else {
      pids <- posts.tags$id[posts.tags$tag == tag]
    }

    ids <- if(negate) setdiff(ids, pids) else intersect(ids, pids)
  }

  return(ids)
}
