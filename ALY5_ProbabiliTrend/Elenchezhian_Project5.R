library(ggplot2)

ball_data <- read.csv("ball-dataset.csv")

freq_color <- as.data.frame(table(ball_data$color))
names(freq_color) <- c("color", "counts")

freq_label <- as.data.frame(table(ball_data$label))
names(freq_label) <- c("label", "counts")

ggplot(freq_color, aes(x = color, y = counts, fill = color)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  ggtitle("Ball Color Distribution")

ggplot(freq_label, aes(x = label, y = counts, fill = label)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  ggtitle("Ball Label Distribution")

n_total <- nrow(ball_data)

prob6_result <- sum(ball_data$color == "green") / n_total
prob7_result <- sum(ball_data$color %in% c("blue", "red")) / n_total
prob8_result <- sum(ball_data$label %in% c("A", "C")) / n_total
prob9_result <- sum(ball_data$color == "yellow" & ball_data$label == "D") / n_total
prob10_result <- sum(ball_data$color == "yellow" | ball_data$label == "D") / n_total

n_blue <- sum(ball_data$color == "blue")
n_red <- sum(ball_data$color == "red")
prob11_result <- (n_blue / n_total) * (n_red / (n_total - 1))

n_green <- sum(ball_data$color == "green")
prob12_result <- (n_green / n_total) * ((n_green - 1) / (n_total - 1)) * ((n_green - 2) / (n_total - 2)) * ((n_green - 3) / (n_total - 3))

n_red <- sum(ball_data$color == "red")
n_b <- sum(ball_data$label == "B")
prob13_result <- (n_red / n_total) * (n_b / (n_total - 1))

my_factorial <- function(n) {
  if (n == 0) return(1)
  return(prod(1:n))
}


coin_outcomes <- expand.grid(first = c("H", "T"),
                             second = c("H", "T"),
                             third = c("H", "T"),
                             fourth = c("H", "T"))


coin_outcomes$probability <- apply(coin_outcomes, 1, function(row) {
  sum(row == "H")
})


num_heads_prob <- as.data.frame(table(coin_outcomes$probability) / nrow(coin_outcomes))
names(num_heads_prob) <- c("num_heads", "probability")


prob18_result <- sum(coin_outcomes$probability == 3) / nrow(coin_outcomes)
prob19_result <- sum(coin_outcomes$probability %in% c(2, 4)) / nrow(coin_outcomes)
prob20_result <- sum(coin_outcomes$probability <= 3) / nrow(coin_outcomes)

barplot(num_heads_prob$probability, names.arg = num_heads_prob$num_heads, col = rainbow(length(num_heads_prob$num_heads)), main = "Probability of Number of Heads", xlab = "Number of Heads", ylab = "Probability")

ggplot(num_heads_prob, aes(x = as.numeric(num_heads), y = probability)) +
  geom_bar(stat = "identity", fill = "blue") +
  theme_minimal() +
  ggtitle("Probability of Heads for 4 Flips") +
  xlab("Number of Heads") +
  ylab("Probability")

prob22_result <- (0.75^5) * (0.50^5)
prob23_result <- 1 - ((0.25^5) * (0.50^5) + (5 * (0.75^1) * (0.25^4) * (0.50^5)))
prob24_result <- choose(5, 3)

save(freq_color, freq_label, prob6_result, prob7_result, prob8_result, prob9_result, 
     prob10_result, prob11_result, prob12_result, prob13_result, my_factorial, prob18_result, 
     prob19_result, prob20_result, num_heads_prob, file = "project5_results.RData")
