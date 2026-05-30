#Final Project: Milestone 2

library(dplyr)
library(ggplot2)
library(scales)

set.seed(42)
n_players <- 32235
df_simulated <- data.frame(PlayerID = 1:n_players)

df_simulated$PlayTimeHours <- rnorm(n_players, mean = 12.2024, sd = 6.7410)
df_simulated$SessionsPerWeek <- round(rnorm(n_players, mean = 10.0249, sd = 5.6101))
df_simulated$AvgSessionDurationMinutes <- round(rnorm(n_players, mean = 96.4123, sd = 48.9051))
df_simulated$PlayerLevel <- round(rnorm(n_players, mean = 50.4231, sd = 28.2648))
df_simulated$GameGenre <- sample(c("Action", "RPG", "Simulation", "Sports", "Strategy"), n_players, replace = TRUE, prob = c(0.2019, 0.2009, 0.1999, 0.1991, 0.1982))
df_simulated$GameDifficulty <- sample(c("Easy", "Medium", "Hard"), n_players, replace = TRUE, prob = c(0.4973, 0.3502, 0.1554))

purchase_prob <- case_when(
  df_simulated$GameGenre == "RPG" ~ 0.240,
  df_simulated$GameGenre == "Sports" ~ 0.225,
  df_simulated$GameGenre == "Action" ~ 0.211,
  df_simulated$GameGenre == "Simulation" ~ 0.199,
  df_simulated$GameGenre == "Strategy" ~ 0.180
)
df_simulated$InGamePurchases <- rbinom(n_players, 1, purchase_prob)

cat("Dataset simulation complete.\n\n")

cat("TEST 1: One-Sample t-Test: Is mean daily playtime > 10 hrs?\n")

hypothesized_mean <- 10
sample_mean <- mean(df_simulated$PlayTimeHours)
t_test1 <- t.test(df_simulated$PlayTimeHours, mu = hypothesized_mean, alternative = "greater")

print(t_test1)

plot1 <- ggplot(df_simulated, aes(x = PlayTimeHours)) +
  geom_density(fill = "#2E86C1", alpha = 0.6) +
  geom_vline(aes(xintercept = sample_mean, color = "Sample Mean"), linetype = "dashed", size = 1) +
  geom_vline(aes(xintercept = hypothesized_mean, color = "Hypothesized Mean"), linetype = "solid", size = 1) +
  scale_color_manual(name = "Legend", values = c("Sample Mean" = "#3498DB", "Hypothesized Mean" = "#E74C3C")) +
  labs(
    title = "Daily Playtime Distribution vs. Benchmark (10 hrs)",
    subtitle = paste("t =", round(t_test1$statistic, 2), "| p =", signif(t_test1$p.value, 3)),
    x = "Average Daily PlayTime (Hours)", y = "Density"
  ) +
  theme_minimal(base_size = 14) + theme(legend.position = "bottom")

cat("\n TEST 2: Chi-Square Test: Do RPG players buy more than Strategy players?\n")

genre_sub <- df_simulated %>% filter(GameGenre %in% c("RPG", "Strategy"))
table_genre <- table(genre_sub$GameGenre, genre_sub$InGamePurchases)
chi_result <- chisq.test(table_genre)

print(chi_result)

purchase_rate_data <- genre_sub %>%
  group_by(GameGenre) %>%
  summarise(PurchaseRate = mean(InGamePurchases))

plot2 <- ggplot(purchase_rate_data, aes(x = GameGenre, y = PurchaseRate, fill = GameGenre)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = percent(PurchaseRate, accuracy = 0.1)), vjust = -0.5, size = 5) +
  scale_fill_manual(values = c("RPG" = "#F39C12", "Strategy" = "#3498DB")) +
  scale_y_continuous(labels = percent_format(), limits = c(0, 0.30)) +
  labs(
    title = "In-Game Purchase Rate: RPG vs. Strategy",
    subtitle = paste("Chi-sq =", round(chi_result$statistic, 2), "| p =", signif(chi_result$p.value, 3)),
    x = "Game Genre", y = "Purchase Rate"
  ) +
  theme_minimal(base_size = 14) + theme(legend.position = "none")


cat("\n TEST 3: Two-Sample t-Test: Do 25–34 players play more than 15–24?\n")

mean_age_25_34 <- 12.3210
n_age_25_34 <- 9840
mean_age_15_24 <- 11.4575
n_age_15_24 <- 7775
sd_shared <- 6.7410

age_playtime_data <- data.frame(
  PlayTimeHours = c(rnorm(n_age_15_24, mean_age_15_24, sd_shared),
                    rnorm(n_age_25_34, mean_age_25_34, sd_shared)),
  AgeGroup = c(rep("15-24", n_age_15_24), rep("25-34", n_age_25_34))
)

t_test3 <- t.test(PlayTimeHours ~ AgeGroup, data = age_playtime_data, alternative = "less")

print(t_test3)

plot3 <- ggplot(age_playtime_data, aes(x = AgeGroup, y = PlayTimeHours, fill = AgeGroup)) +
  geom_boxplot() +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 4, fill = "white", stroke = 1) +
  scale_fill_manual(values = c("15-24" = "#58D68D", "25-34" = "#5DADE2")) +
  labs(
    title = "Daily Playtime by Age Group",
    subtitle = paste("t =", round(t_test3$statistic, 2), "| p =", signif(t_test3$p.value, 3)),
    x = "Age Group", y = "Daily PlayTime (Hours)"
  ) +
  theme_minimal(base_size = 14) + theme(legend.position = "none")


print(plot1)
print(plot2)
print(plot3)
