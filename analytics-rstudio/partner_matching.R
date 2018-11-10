source('what_is_my_fetish.R')
source('_util.R')

match <- function(usernames)
{
    interests <- list()
    for (username in usernames)
    {
        printf('reading from %s', username)
        interests[[username]] <- interests_of(username)
        interests[[username]][['total']] <- NULL
    }

    matches <- matrix(, nrow = length(usernames), ncol = length(usernames), dimnames = list(usernames, usernames))

    for (i1 in 1:length(usernames))
    {
        for (i2 in i1:length(usernames))
        {
            user1.count <- as.numeric(unlist(interests[[usernames[i1]]]))
            user2.count <- as.numeric(unlist(interests[[usernames[i2]]]))
            matches[usernames[i1], usernames[i2]] <- exp(-mean((user1.count - user2.count)^2) * 10)
        }
    }

    return (matches)
}