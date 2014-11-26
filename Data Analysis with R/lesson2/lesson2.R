# Read and Subset Data

statesInfo <- read.csv("stateData.csv")

stateSubset <- subset(statesInfo, state.region == 1)
head(stateSubset)
dim(stateSubset)

# Factor variables

reddit <- read.csv("reddit.csv")
str(reddit)

table(reddit$employment.status)
levels(reddit$age.range)

library(ggplot2)
qplot(data = reddit, x = age.range)
qplot(data = reddit, x = income.range)

# Reorder factor
age.levels <- levels(reddit$age.range)
nlevels <- length(age.levels)
ordered.levels <- c(age.levels[nlevels], age.levels[1:(nlevels-1)])
reddit$age.range.ordered <- ordered(reddit$age.range, levels = ordered.levels)

qplot(data = reddit, x = age.range.ordered)

income.levels <- levels(reddit$income.range)
nlevels <- length(income.levels)
ordered.levels <- c("Under $20,000", "$20,000 - $29,999", "$30,000 - $39,999", "$40,000 - $49,999", "$50,000 - $69,999", "$70,000 - $99,999", "$100,000 - $149,999", "$150,000 or more")   
reddit$income.range.ordered <- ordered(reddit$income.range, levels = ordered.levels)

qplot(data = reddit, x = income.range.ordered)