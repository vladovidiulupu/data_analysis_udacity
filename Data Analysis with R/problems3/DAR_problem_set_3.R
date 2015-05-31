library(ggplot2)
library(dplyr)
library(readxl)
library(downloader)

data(diamonds)
summary(diamonds)

summary(diamonds$color)

# Create a histogram of the price of
# all the diamonds in the diamond data set.

ggplot(diamonds, aes(x = price)) +
    geom_histogram(binwidth = 500, color = 'black', fill = '#5760AB')

summary(diamonds$price)
sd(diamonds$price)

nrow(filter(diamonds, price < 500))
nrow(filter(diamonds, price < 250))
nrow(filter(diamonds, price >= 15000))

ggplot(diamonds, aes(x = price)) +
    geom_histogram(binwidth = 50, color = 'black', fill = '#5760AB') +
    scale_x_continuous(limits = c(400, 2000))

ggplot(diamonds, aes(x = price)) +
    geom_histogram(binwidth = 500, color = 'black', fill = '#5760AB') +
    facet_wrap(~ cut)

filter(diamonds, price == max(price))
filter(diamonds, price == min(price))
diamonds %>%
    group_by(cut) %>%
    summarise(medianPrice = median(price))

ggplot(diamonds, aes(x = price)) +
    geom_histogram(color = 'black', fill = '#5760AB') +
    facet_wrap(~ cut, scales = "free")

# Create a histogram of price per carat
# and facet it by cut. You can make adjustments
# to the code from the previous exercise to get
# started.

ggplot(diamonds, aes(x = price / carat)) +
    geom_histogram(, binwidth = 0.05, color = 'black', fill = '#5760AB') +
    scale_x_log10() +
    facet_wrap(~ cut, scales = "free")

# Investigate the price of diamonds using box plots,
# numerical summaries, and one of the following categorical
# variables: cut, clarity, or color.

ggplot(diamonds, aes(x = cut, y = price)) +
    geom_boxplot(color = 'black', aes(fill = cut)) + 
    coord_cartesian(ylim = c(0, 12000))

ggplot(diamonds, aes(x = clarity, y = price)) +
    geom_boxplot(color = 'black', aes(fill = clarity)) + 
    coord_cartesian(ylim = c(0, 12000))

ggplot(diamonds, aes(x = color, y = price)) +
    geom_boxplot(color = 'black', aes(fill = color)) + 
    coord_cartesian(ylim = c(0, 15000))

# By looking only at price, it seems that the diamonds with the best colors have lower prices,
# because the median is lower, but we see a lot of outliers for the better colors. Adjusting by
# carats, we see that those outliers influence the mean for the better colors.

diamonds %>%
    group_by(color) %>%
    summarise(medianPrice = median(price / carat) * 1.0, meanPrice = mean(price / carat))

by(diamonds$price, diamonds$color, summary)

# Investigate the price per carat of diamonds across
# the different colors of diamonds using boxplots.

ggplot(diamonds, aes(x = color, y = price / carat)) +
    geom_boxplot(color = 'black', aes(fill = color)) + 
    coord_cartesian(ylim = c(1200, 13000))

# Investigate the weight using a frequency polygon

ggplot(diamonds, aes(x = carat, y = ..count..)) +
    geom_freqpoly(aes(color = as.factor(carat))) +
    scale_x_continuous() +
    coord_cartesian(ylim = c(1500, 3000))

which(table(diamonds$carat) > 2000)

# The Gapminder website contains over 500 data sets with information about
# the world's population. Your task is to download a data set of your choice
# and create 2-5 plots that make use of the techniques from Lesson 3.

if (!file.exists("indicator CDIAC carbon_dioxide_cumulative_emissions.csv"))
    download.file(url = "http://spreadsheets.google.com/pub?key=pyj6tScZqmEed4UamoiNCFA&output=xls",
                  destfile = "indicator CDIAC carbon_dioxide_cumulative_emissions.csv")
emissions <- read.csv("indicator CDIAC carbon_dioxide_cumulative_emissions.csv")

CO2emissions <- data.frame(CO2in2009 = emissions$X2009,
                           CO2in2008 = emissions$X2008,
    Country = emissions$CO2.emissions.from.fossil.fuels.since.1751..metric.tons.)

ggplot(CO2emissions, aes(x = CO2in2008)) +
    geom_histogram(color = 'black', fill = '#CC6666')

# This is long tailed data and it has outliers as well, so we would better see 
# the distribution if we got rid of the outliers

ggplot(CO2emissions, aes(x = CO2in2008)) +
    geom_histogram(color = 'black', fill = '#CC6666') +
    scale_x_continuous(limits = c(0, 1e+9))

# A histogram of the increase of CO2 emissions from 2008 to 2009.
# We see that no country reduced its CO2 emissions and this data is also long tailed

ggplot(CO2emissions, aes(x = CO2in2009 - CO2in2008)) +
    geom_histogram(color = 'black', fill = '#CC6666') +
    scale_x_continuous(limits = c(0, 5e+8))

# Your task is to investigate the distribution of your friends'
# birth months and days.

# Here some questions you could answer, and we hope you think of others.

# **********************************************************************

library(lubridate)

birthdays <- read.csv("birthdaysExample.csv", stringsAsFactors = FALSE)

birthdays <- mutate(birthdays, date = mdy(dates))

birthdays <- birthdays %>%
    mutate(month = month(date, label = TRUE),
           day = day(date),
           yday = yday(date))

# How many people share your birthday? Do you know them?
# (Reserve time with them or save money to buy them a gift!)

filter(birthdays, date == dmy("12/06/2014"))

# Which month contains the most number of birthdays?

birthdays %>%
    group_by(month) %>%
    summarize(total = n()) %>%
    arrange(desc(total))

# How many birthdays are in each month?

ggplot(birthdays, aes(x = month)) +
    geom_bar(color = 'black', aes(fill = month))

birthdays %>%
    group_by(month) %>%
    summarize(total = n()) %>%
    arrange(desc(total))

# Which day of the year has the most number of birthdays?

birthdays %>%
    group_by(yday) %>%
    summarize(total = n()) %>%
    arrange(desc(total)) %>%
    mutate(date = ymd("2014/01/01") + days(yday - 1))


# Do you have at least 365 friends that have birthdays on everyday
# of the year?

length(unique(birthdays$date))
