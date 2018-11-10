library('fastmatch')
source('_tagged.R')
source('_util.R')
library(VennDiagram)

venn2d <- function(tag1, tag2)
{
  count1 <- howmanytagged(tag1)
  count2 <- howmanytagged(tag2)
  count12 <- howmanytagged(c(tag1, tag2))

  draw.pairwise.venn(area1 = count1, area2 = count2, cross.area = count12, category = c(tag1, tag2))
}