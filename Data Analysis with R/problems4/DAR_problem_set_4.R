library(ggplot2)
library(dplyr)
library(gridExtra)
data(diamonds)
str(diamonds)

ggplot(diamonds, aes(x = x, y = price)) +
    xlim(3, 10) +
    geom_point(alpha = 1/10)

with(diamonds, round(cor(price, x), 3))
with(diamonds, round(cor(price, y), 3))
with(diamonds, round(cor(price, z), 3))

ggplot(diamonds, aes(x = depth, y = price)) +
    xlim(quantile(diamonds$depth, probs = c(0.001, 0.999))) +
    geom_point(alpha = 1/10)

ggplot(data = diamonds, aes(x = depth, y = price)) + 
    scale_x_continuous(breaks = seq(min(diamonds$depth), max(diamonds$depth), 2)) +
    geom_point(alpha = 1/100)

with(diamonds, round(cor(price, depth), 3))

ggplot(data = diamonds, aes(x = carat, y = price)) + 
    xlim(0, quantile(diamonds$carat, 0.99)) +
    ylim(0, quantile(diamonds$price, 0.99)) +
    geom_point(alpha = 1/10)

diamonds$volume = diamonds$x * diamonds$y * diamonds$z

ggplot(data = diamonds, aes(x = volume, y = price)) +
    xlim(0, quantile(diamonds$volume, 0.999)) +
    geom_point(alpha = 1/10)

with(filter(diamonds, !(volume == 0 | volume >= 800)), round(cor(price, volume), 2))

ggplot(data = filter(diamonds, !(volume == 0 | volume >= 800)), aes(x = volume, y = price)) +
    geom_point(alpha = 1/10) +
    geom_smooth(method = "lm")

diamondsByClarity <- diamonds %>%
    group_by(clarity) %>%
    summarise(mean_price = mean(price),
              median_price = median(price) * 1,
              min_price = min(price),
              max_price = max(price),
              n = n())

diamonds_by_clarity <- group_by(diamonds, clarity)
diamonds_mp_by_clarity <- summarise(diamonds_by_clarity, mean_price = mean(price))

diamonds_by_color <- group_by(diamonds, color)
diamonds_mp_by_color <- summarise(diamonds_by_color, mean_price = mean(price))

p1 <- ggplot(diamonds_mp_by_clarity, aes(x = clarity, y = mean_price)) +
    geom_bar(stat = "identity", color = "black", aes(fill = clarity))

p2 <- ggplot(diamonds_mp_by_color, aes(x = color, y = mean_price)) +
    geom_bar(stat = "identity", color = "black", aes(fill = color))

grid.arrange(p1, p2, ncol = 1)
