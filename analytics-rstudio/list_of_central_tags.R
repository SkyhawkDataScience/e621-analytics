source('_storage.R')
source('_util.R')

# extract top 5000 tags
posts.tags = read.posts.tags()
tagNames = factor(posts.tags$tag)
tagCount = table(tagNames)
tagCount = tagCount[order(tagCount, decreasing = TRUE)[1:5000]]
tagNames = factor(posts.tags$tag, levels = names(tagCount))
posts.tags = data.frame(
    id = posts.tags$id[!is.na(tagNames)],
    tag = tagNames[!is.na(tagNames)]
)

# annotate rating
posts.kpi = read.posts.kpi()
posts.kpi = posts.kpi[,c('id', 'rating', 'fav_count')]
posts.tags = merge(posts.tags, posts.kpi)
posts.tags$rating = as.numeric(posts.tags$rating)
means = aggregate(cbind(rating, fav_count) ~ tag, posts.tags, mean)

# find relations between posts and tags
relations = sparseMatrix(
    i = as.numeric(factor(posts.tags$id)),
    j = as.numeric(factor(posts.tags$tag)),
    x = posts.tags$rating
)
colnames(relations) = levels(factor(posts.tags$tag))

# find relations between tags
adj = tcrossprod(t(relations))
adj = adj / diag(adj)
filteredAdj = apply(t(adj), 1, function(row) {
    return(sum(row))
})
filteredAdj = filteredAdj[order(-filteredAdj)]

# annotate
centralTags = as.data.frame(as.table(filteredAdj))
colnames(centralTags) = c('tag', 'score')
tagInfo = read.tags()
centralTags = merge(centralTags, tagInfo, by.x = 'tag', by.y = 'name')
centralTags = merge(centralTags, means, by = 'tag')
centralTags$score2 = centralTags$score * centralTags$rating^2
centralTags$score3 = centralTags$score * centralTags$fav_count

head(subset(centralTags[order(-centralTags$fav_count),], type == 0), 20)
head(subset(centralTags[order(-centralTags$fav_count),], type == 5), 20)

head(subset(centralTags[order(-centralTags$score),], type == 0), 20)
head(subset(centralTags[order(-centralTags$score),], type == 5), 20)

head(subset(centralTags[order(-centralTags$count),], type == 0), 20)
head(subset(centralTags[order(-centralTags$count),], type == 5), 20)

head(subset(centralTags[order(-centralTags$score2),], type == 0), 20)
head(subset(centralTags[order(-centralTags$score2),], type == 5), 20)

head(subset(centralTags[order(-centralTags$score3),], type == 0), 20)
head(subset(centralTags[order(-centralTags$score3),], type == 5), 20)