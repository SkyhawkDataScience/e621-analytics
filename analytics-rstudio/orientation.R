source('_tagged.R')

orientation <- function (listOfTags)
{
    n <- length(listOfTags)
    values <- matrix(,nrow = n, ncol = 6);
    rownames(values) <- names(listOfTags)
    colnames(values) <- c('male', 'female', 'ambiguous_gender', 'male/male', 'male/female', 'female/female')

    for (index in 1:n)
    {
        tagname <- listOfTags[[index]]

        all <- howmanytagged(tagname);
        values[index, 1] <- howmanytagged(c(tagname, 'male')) / all
        values[index, 2] <- howmanytagged(c(tagname, 'female')) / all
        values[index, 3] <- howmanytagged(c(tagname, 'ambiguous_gender')) / all
        values[index, 4] <- howmanytagged(c(tagname, 'male/male')) / all
        values[index, 5] <- howmanytagged(c(tagname, 'male/female')) / all
        values[index, 6] <- howmanytagged(c(tagname, 'female/female')) / all
    }

    return(values)
}

plot_orientation <- function (listOfTags)
{
    values <- orientation(listOfTags)
    nTags <- length(listOfTags)

    par(mfrow=c(2,1), mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)

    barplot(
        height = t(values[,1:3]),
        main = "Gender",
        names.arg = listOfTags,
        args.legend = list(x = 'topright', bty='n', inset=c(-0.2,0)),
        legend = c('male', 'female', 'ambiguous'),
        col = rainbow(nTags)
    )

    barplot(
        height = t(values[,4:6]),
        main = "Interaction",
        names.arg = listOfTags,
        args.legend = list(x = 'topright', bty='n', inset=c(-0.2,0)),
        legend = c('male/male', 'male/female', 'female/female'),
        col = rainbow(nTags)
    )
}