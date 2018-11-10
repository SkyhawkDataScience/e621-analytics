suppressPackageStartupMessages(library('lubridate'))
library('Matrix')

popvar = function(items)
{
    return(sum((items - mean(items))^2) / length(items))
}

printf = function(...)
{
    print(sprintf(...))
}