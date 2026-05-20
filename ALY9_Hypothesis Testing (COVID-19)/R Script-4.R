library(ggplot2)
library(dplyr)
library(scales)

df <- read.csv("Provisional_COVID-19_death_counts__rates__and_percent_of_total_deaths__by_jurisdiction_of_residence.csv")

df_clean <- na.omit(df[, c("COVID_deaths", "crude_COVID_rate")])

# One-sample t-test: Is mean COVID_deaths = 10000?
t_test_deaths <- t.test(df_clean$COVID_deaths, mu = 10000)
print("One-Sample t-Test: COVID_deaths vs 10000")
print(t_test_deaths)

# Visualization 1
ggplot(df_clean, aes(x = COVID_deaths)) +
  geom_histogram(binwidth = 2000, fill = "skyblue", color = "black", alpha = 0.7) +
  geom_vline(xintercept = 10000, color = "red", linetype = "dashed", size = 1) +
  labs(title = "Distribution of COVID-19 Deaths by Jurisdiction",
       subtitle = "Red dashed line = hypothesized mean (10,000 deaths)",
       x = "Number of Deaths",
       y = "Count of Jurisdictions") +
  theme_minimal()

# One-sample t-test: Is mean crude_COVID_rate > 100?
t_test_rate <- t.test(df_clean$crude_COVID_rate, mu = 100, alternative = "greater")
print("One-Sample t-Test: crude_COVID_rate > 100")
print(t_test_rate)

# Visualization 2a
ggplot(df_clean, aes(x = crude_COVID_rate)) +
  geom_histogram(binwidth = 10, fill = "lightgreen", color = "black", alpha = 0.7) +
  geom_vline(xintercept = 100, color = "blue", linetype = "dashed", size = 1) +
  labs(title = "Distribution of Crude COVID-19 Death Rates",
       subtitle = "Blue dashed line = test threshold (100 deaths per 100,000)",
       x = "Crude Death Rate",
       y = "Count of Jurisdictions") +
  theme_minimal()

# Visualization 2b
ggplot(df_clean, aes(y = crude_COVID_rate)) +
  geom_boxplot(fill = "lightgreen") +
  geom_hline(yintercept = 100, color = "blue", linetype = "dashed", size = 1) +
  labs(title = "Boxplot of Crude COVID-19 Death Rates",
       subtitle = "Blue dashed line = 100 deaths per 100,000 threshold",
       y = "Crude Death Rate") +
  theme_minimal()

# Proportion Test: Is a minority of jurisdictions above a 'high' rate (e.g. 200)?
threshold <- 200
n_total <- length(df_clean$crude_COVID_rate)
n_high <- sum(df_clean$crude_COVID_rate > threshold)

print(paste("Proportion of jurisdictions with crude COVID rate >", threshold, ":"))
print(n_high / n_total)

# Proportion test: is proportion of "high" rates < 50%?
prop_test <- prop.test(x = n_high, n = n_total, p = 0.5, alternative = "less")
print("Proportion Test: Is proportion < 50%?")
print(prop_test)

# Visualization 3
df_clean <- df_clean %>%
  mutate(high_death_label = ifelse(crude_COVID_rate > threshold, paste("Above", threshold), paste(threshold, "or Below")))

prop_data <- df_clean %>%
  count(high_death_label) %>%
  mutate(proportion = n / sum(n))

above_label <- paste("Above", threshold)
below_label <- paste(threshold, "or Below")

ggplot(prop_data, aes(x = high_death_label, y = proportion, fill = high_death_label)) +
  geom_bar(stat = "identity", color = "black") +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(title = paste("Proportion of Jurisdictions by Crude Death Rate Category (Threshold =", threshold, ")"),
       x = "Crude Death Rate Category",
       y = "Percentage of Jurisdictions") +
  theme_minimal() +
  scale_fill_manual(values = c(above_label = "tomato", below_label = "steelblue")) +
  theme(legend.position = "none")
