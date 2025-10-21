library(tibble)
library(palmerpenguins)
library(ggplot2)

prob1_result <- dbinom(5, size = 7, prob = 0.65)

wins <- 0:7
probabilities <- dbinom(wins, size = 7, prob = 0.65)
prob2_result <- tibble(wins, probability = probabilities)

prob3_result <- pbinom(4, size = 7, prob = 0.65)

prob4_result <- pbinom(5, size = 7, prob = 0.65) - pbinom(2, size = 7, prob = 0.65)

prob5_result <- 1 - pbinom(4, size = 7, prob = 0.65)

prob6_result <- 7 * 0.65

prob7_result <- 7 * 0.65 * (1 - 0.65)

set.seed(10)
random_wins <- rbinom(1000, size = 7, prob = 0.65)

prob9_result <- mean(random_wins)

prob10_result <- var(random_wins)

prob11_result <- dpois(6, lambda = 7)

prob12_result <- ppois(40, lambda = 7 * 8)

prob13_result <- 1 - ppois(274, lambda = 5 * 7 * 8)

prob14_result <- 1 - ppois(274, lambda = 4 * 7 * 8)

prob15_result <- qpois(0.9, lambda = 7 * 8)

set.seed(15)
random_calls <- rpois(1000, lambda = 7 * 8)

prob17_result <- mean(random_calls)

prob18_result <- var(random_calls)

prob19_result <- pnorm(2200, mean = 2000, sd = 100) - pnorm(1800, mean = 2000, sd = 100)

prob20_result <- 1 - pnorm(2500, mean = 2000, sd = 100)

prob21_result <- ceiling(qnorm(0.1, mean = 2000, sd = 100))

set.seed(25)
random_lifespans <- rnorm(10000, mean = 2000, sd = 100)

prob22_result <- random_lifespans

prob23_result <- mean(random_lifespans)

prob24_result <- sd(random_lifespans)

set.seed(1)
sample_means <- replicate(1000, mean(sample(random_lifespans, 100, replace = TRUE)))

prob25_result <- sample_means

hist(prob25_result, main="Histogram of Sample Means", xlab="Sample Means", col="blue")

prob27_result <- mean(sample_means)

adelie_penguins <- subset(penguins, species == "Adelie")

hist(adelie_penguins$flipper_length_mm, main = "Histogram of Flipper Lengths for Adélie Penguins", xlab = "Flipper Length (mm)", col = "blue", border = "black")

shapiro_test <- shapiro.test(adelie_penguins$flipper_length_mm)
prob28_result <- list(histogram = "Generated", shapiro_p_value = shapiro_test$p.value)

gentoo_penguins <- subset(penguins, species == "Gentoo")

plot(gentoo_penguins$flipper_length_mm, gentoo_penguins$bill_depth_mm, main = "Flipper Length vs. Beak Depth for Gentoo Penguins", xlab = "Flipper Length (mm)", ylab = "Beak Depth (mm)", col = "red", pch = 19)

correlation <- cor(gentoo_penguins$flipper_length_mm, gentoo_penguins$bill_depth_mm, use = "complete.obs")
prob29_result <- list(correlation_coefficient = correlation)

list(
  prob1_result = prob1_result,
  prob2_result = prob2_result,
  prob3_result = prob3_result,
  prob4_result = prob4_result,
  prob5_result = prob5_result,
  prob6_result = prob6_result,
  prob7_result = prob7_result,
  prob9_result = prob9_result,
  prob10_result = prob10_result,
  prob11_result = prob11_result,
  prob12_result = prob12_result,
  prob13_result = prob13_result,
  prob14_result = prob14_result,
  prob15_result = prob15_result,
  prob17_result = prob17_result,
  prob18_result = prob18_result,
  prob19_result = prob19_result,
  prob20_result = prob20_result,
  prob21_result = prob21_result,
  prob22_result = prob22_result,
  prob23_result = prob23_result,
  prob24_result = prob24_result,
  prob25_result = prob25_result,
  prob27_result = prob27_result,
  prob28_result = prob28_result,
  prob29_result = prob29_result
)

