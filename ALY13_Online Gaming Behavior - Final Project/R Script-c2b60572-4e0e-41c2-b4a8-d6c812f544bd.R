# Final Project: Module 6 - week 6

library(ggplot2)
library(dplyr)
library(nnet)       
library(cluster)    
library(ggpubr)      

ggplot2::theme_set(theme_minimal())

df <- read.csv("online_gaming_behavior_dataset.csv")

df_clean <- df %>%
  filter(SessionsPerWeek >= 1, PlayTimeHours >= 1)

df_clean$AgeGroup <- cut(df_clean$Age,
                         breaks = c(15, 24, 34, 44, 49),
                         labels = c("15-24", "25-34", "35-44", "45-49"),
                         right = TRUE)

df_clean$Gender <- as.factor(df_clean$Gender)
df_clean$EngagementLevel <- as.factor(df_clean$EngagementLevel)
df_clean$GameGenre <- as.factor(df_clean$GameGenre)
df_clean$GameDifficulty <- as.factor(df_clean$GameDifficulty)


# Q1: Logistic Regression - Predicting InGamePurchases

logit_model <- glm(InGamePurchases ~ Age + Gender + PlayTimeHours +
                     SessionsPerWeek + GameGenre + EngagementLevel,
                   data = df_clean, family = "binomial")
summary(logit_model)

ggplot(df_clean, aes(x = PlayTimeHours, fill = as.factor(InGamePurchases))) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
  labs(title = "Distribution of PlayTimeHours by Purchase Status",
       x = "PlayTimeHours", fill = "Purchased")


# Q2: Two-Way ANOVA - GameGenre x GameDifficulty Effect on PlayTimeHours

anova_difficulty <- aov(PlayTimeHours ~ GameGenre * GameDifficulty, data = df_clean)
summary(anova_difficulty)


interaction.plot(df_clean$GameDifficulty, df_clean$GameGenre, df_clean$PlayTimeHours,
                 fun = mean, col = 1:5, legend = TRUE,
                 xlab = "Game Difficulty", ylab = "Mean PlayTimeHours",
                 main = "Interaction: Genre and Difficulty on PlayTime")

# Q3: Multinomial Regression - Predicting EngagementLevel

engage_model <- multinom(EngagementLevel ~ PlayTimeHours + SessionsPerWeek +
                           InGamePurchases + AvgSessionDurationMinutes + AchievementsUnlocked,
                         data = df_clean)
summary(engage_model)

p1 <- ggplot(df_clean, aes(x = EngagementLevel, y = PlayTimeHours, fill = EngagementLevel)) +
  geom_boxplot() + labs(title = "PlayTime by Engagement Level")

p2 <- ggplot(df_clean, aes(x = EngagementLevel, y = SessionsPerWeek, fill = EngagementLevel)) +
  geom_boxplot() + labs(title = "SessionsPerWeek by Engagement Level")

ggarrange(p1, p2, ncol = 2)


# Q4: K-Means Clustering on Play Behavior

df_cluster <- df_clean %>%
  select(PlayTimeHours, SessionsPerWeek, AvgSessionDurationMinutes, PlayerLevel, AchievementsUnlocked)

# Normalize data for clustering
df_scaled <- scale(df_cluster)

set.seed(123)
km <- kmeans(df_scaled, centers = 3)
df_clean$Cluster <- factor(km$cluster)

ggplot(df_clean, aes(x = SessionsPerWeek, y = PlayTimeHours, color = Cluster)) +
  geom_point(alpha = 0.4) +
  labs(title = "K-Means Clustering of Player Behavior",
       x = "Sessions Per Week", y = "Daily PlayTime (Hours)")

# Q5: Classical Linear Regression - Predicting PlayTimeHours

lm_model <- lm(PlayTimeHours ~ SessionsPerWeek + PlayerLevel + AchievementsUnlocked,
               data = df_clean)
summary(lm_model)

# Visual: Linear Regression Plot
ggplot(df_clean, aes(x = SessionsPerWeek, y = PlayTimeHours)) +
  geom_point(alpha = 0.3, color = "darkblue") +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(title = "Linear Regression: SessionsPerWeek vs PlayTimeHours",
       x = "Sessions Per Week", y = "Daily PlayTime (Hours)")


sink("advanced_model_outputs.txt")
cat("Logistic Regression - InGamePurchases\n")
summary(logit_model)

cat("\nANOVA - GameGenre * GameDifficulty on PlayTime\n")
summary(anova_difficulty)

cat("\nMultinomial Regression - EngagementLevel\n")
summary(engage_model)

cat("\nLinear Regression - PlayTimeHours\n")
summary(lm_model)
sink()
