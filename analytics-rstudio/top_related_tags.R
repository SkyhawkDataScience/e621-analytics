library('fastmatch')
source('_storage.R')

if (!exists('posts.tags'))
{
    posts.tags <- read.posts.tags();
}

top_related_tags <- function(tagname)
{
    filtered <- posts.tags[posts.tags$id %in% posts.tags$id[posts.tags$tag == tagname],]
    filtered <- aggregate(id ~ tag, filtered, length)

    filtered <- merge(filtered, read.tags(), by.x = 'tag', by.y = 'name')
    filtered <- filtered[,c(1, 2, 5)]
    colnames(filtered) <- c('name', 'count', 'type')

    filtered <- filtered[order(filtered$count, decreasing = TRUE),]
    return(filtered);
}