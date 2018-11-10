library('igraph')
library('Matrix')
library('readr')
library('fastmatch')
library('stringr')

source('_storage.R')

print('loading data')
tags <- read.tags();
posts <- merge(read.posts.kpi(), read.posts.content())[c('id', 'rating', 'score', 'fav_count', 'file_ext')];
posts.tags <- read.posts.tags();

print('filtering entries')
tagnames <- factor(posts.tags$tag)
counts <- table(tagnames)
counts <- counts[order(counts, decreasing = TRUE)[1:5000]]
tagnames <- factor(posts.tags$tag, levels = names(counts))
reduced.posts <- data.frame(
    post = posts.tags$id[!is.na(tagnames)],
    tag = tagnames[!is.na(tagnames)]
)

print('building relations matrix')
relations <- sparseMatrix(
    i = as.numeric(factor(reduced.posts$post)),
    j = as.numeric(factor(reduced.posts$tag)),
    x = rep(1, length(reduced.posts$post))
)
colnames(relations) <- levels(factor(reduced.posts$tag))

print('building graph')
# get weighted relations
adj <- tcrossprod(t(relations))
# normalize
adj <- adj / diag(adj)
# filter relations by importance
adj <- apply(adj, 1, function(row) {

    # option 1) discard all BUT the strongest 4 edges
    edges <- order(row, decreasing = TRUE)
    row[edges[-(1:4)]] <- 0

    # option 2) discard all BUT the strongest 2% of edges
    #nonzero <- row > 1
    #edges <- order(row[nonzero])
    #row[nonzero][edges[1:floor(length(edges) * 0.98)]] <- 0
    #row[!nonzero] <- 0

    return(row)
})
# we plot an undirected graph, which is based on a symmetric matrix
adj <- symmpart(adj)
# build the undirected graph
g <- graph.adjacency(adj, mode = 'undirected', weighted = TRUE, diag = FALSE)
# remove some loops
g <- simplify(g)

print('writing graph edges')
edges <- data.frame(
    Source = get.edgelist(g)[,1],
    Target = get.edgelist(g)[,2],
    Type = rep('Undirected', length(E(g)$weight)),
    Weight = E(g)$weight
)
write_csv(edges, '../results/graph_edges.csv')

print('writing graph nodes')
nodes <- V(g)$name
join <- match(reduced.posts$post, posts$id)

annotated.mean <- aggregate(cbind(rating, score, favs) ~ tagname, data.frame(
    tagname = reduced.posts$tag,
    rating = as.numeric(posts$rating[join]),
    score = posts$score[join],
    favs = posts$fav_count[join]
), mean)
annotated.common <- aggregate(cbind(rating, file_ext) ~ tagname, data.frame(
    tagname = reduced.posts$tag,
    rating = posts$rating[join],
    file_ext = posts$file_ext[join]
), function(x) { names(which.max(table(x))) })
annotated.common$rating <- levels(posts$rating)[as.numeric(annotated.common$rating)]
annotated.common$file_ext <- levels(posts$file_ext)[as.numeric(annotated.common$file_ext)]

nodes <- data.frame(
    Id = nodes,
    Label = nodes,
    Type = tags$type[match(nodes, tags$name)],
    Count = as.integer(counts[nodes]),
    MeanRating = annotated.mean$rating[match(nodes, annotated.mean$tagname)],
    MeanScore = annotated.mean$score[match(nodes, annotated.mean$tagname)],
    MeanFavs = annotated.mean$favs[match(nodes, annotated.mean$tagname)],
    CommonRating = annotated.common$rating[match(nodes, annotated.common$tagname)],
    CommonFileExt = annotated.common$file_ext[match(nodes, annotated.common$tagname)]
)
write_csv(nodes, '../results/graph_nodes.csv')