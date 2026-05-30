# Module 2– Week 2

library(dplyr)
library(readr)
library(ggplot2)
library(scales)

# Import data
df <- read_csv("online_gaming_behavior_dataset.csv")

#  Create a “clean” subset by removing inactive players
df_clean <- df %>%
  filter(PlayTimeHours >= 1, SessionsPerWeek >= 1) %>%
  #  Add AgeGroup variable (bins: 15–24, 25–34, 35–44, 45–49)
  mutate(
    AgeGroup = case_when(
      Age >= 15  & Age <= 24 ~ "15–24",
      Age >= 25  & Age <= 34 ~ "25–34",
      Age >= 35  & Age <= 44 ~ "35–44",
      Age >= 45  & Age <= 49 ~ "45–49",
      TRUE                  ~ NA_character_
    )
  )

# Plot 1: Histogram of Age (All Players)
p1 <- ggplot(df, aes(x = Age)) +
  geom_histogram(
    bins      = 8,
    fill      = "#69b3a2",
    color     = "black",
    alpha     = 0.8
  ) +
  labs(
    title    = "Age Distribution of All Players",
    subtitle = "Most players are between 15 and 49 years old",
    x        = "Age (years)",
    y        = "Number of Players"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 2: Boxplot of Age (All Players)
p2 <- ggplot(df, aes(y = Age)) +
  geom_boxplot(
    fill          = "#4C78A8",
    color         = "black",
    outlier.color = "#E45756",
    outlier.shape = 16
  ) +
  coord_flip() + 
  labs(
    title    = "Boxplot of Player Ages",
    subtitle = "Median age is around mid‐30s; range is 15–49",
    y        = "Age (years)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    axis.title.x     = element_blank(),
    axis.text.x      = element_blank(),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 3: Histogram of PlayTimeHours (All Players)
p3 <- ggplot(df, aes(x = PlayTimeHours)) +
  geom_histogram(
    bins      = 12,
    fill      = "#FFBE7D",
    color     = "black",
    alpha     = 0.8
  ) +
  labs(
    title    = "Daily Playtime (Hours) Distribution",
    subtitle = "Most players report between 6–18 hours/day",
    x        = "Daily PlayTime (Hours)",
    y        = "Number of Players"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 4: Boxplot of PlayTimeHours (All Players)
p4 <- ggplot(df, aes(y = PlayTimeHours)) +
  geom_boxplot(
    fill          = "#B4A8DA",
    color         = "black",
    outlier.color = "#E15759",
    outlier.shape = 16
  ) +
  coord_flip() +
  labs(
    title    = "Boxplot of Daily PlayTime (Hours)",
    subtitle = "Shows median, IQR, and extreme playtime values",
    y        = "Daily PlayTime (Hours)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    axis.title.x     = element_blank(),
    axis.text.x      = element_blank(),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 5: Histogram of SessionsPerWeek (All Players)
p5 <- ggplot(df, aes(x = SessionsPerWeek)) +
  geom_histogram(
    bins      = 10,
    fill      = "#76B7B2",
    color     = "black",
    alpha     = 0.8
  ) +
  labs(
    title    = "Weekly Gaming Sessions Distribution",
    subtitle = "Most players have between 4–14 sessions per week",
    x        = "Sessions per Week",
    y        = "Number of Players"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 6: Boxplot of SessionsPerWeek (All Players)
p6 <- ggplot(df, aes(y = SessionsPerWeek)) +
  geom_boxplot(
    fill          = "#FFA15A",
    color         = "black",
    outlier.color = "#E76F51",
    outlier.shape = 16
  ) +
  coord_flip() +
  labs(
    title    = "Boxplot of Sessions Per Week",
    subtitle = "Median around 9 sessions/week; a few extremes at 0 and 19",
    y        = "Sessions per Week"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    axis.title.x     = element_blank(),
    axis.text.x      = element_blank(),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 7: Scatterplot of PlayTimeHours vs SessionsPerWeek (All Players)
p7 <- ggplot(df, aes(x = SessionsPerWeek, y = PlayTimeHours)) +
  geom_point(alpha = 0.3, color = "#0072B2") +
  geom_smooth(method = "lm", se = FALSE, color = "#D55E00", size = 1.2) +
  labs(
    title    = "Relationship: Weekly Sessions vs Daily Play Time",
    subtitle = "Red line shows linear trend: more sessions ≈ more hours",
    x        = "Sessions per Week",
    y        = "Daily PlayTime (Hours)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 8: Scatterplot of PlayerLevel vs AchievementsUnlocked (All Players)
p8 <- ggplot(df, aes(x = PlayerLevel, y = AchievementsUnlocked)) +
  geom_point(alpha = 0.25, color = "#4C78A8") +
  geom_smooth(method = "lm", se = FALSE, color = "#F58518", size = 1) +
  labs(
    title    = "Player Level vs Achievements Unlocked",
    subtitle = "Linear trend indicates higher‐level players unlock more achievements",
    x        = "Player Level",
    y        = "Achievements Unlocked"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 9: Boxplot of PlayTimeHours by EngagementLevel (All Players)
p9 <- ggplot(df, aes(x = EngagementLevel, y = PlayTimeHours)) +
  geom_boxplot(
    fill          = "#8DD3C7",
    color         = "black",
    outlier.color = "#E15759",
    outlier.shape = 16
  ) +
  labs(
    title    = "Daily PlayTime by Engagement Level",
    subtitle = "Similar medians, but slight variation in IQR across levels",
    x        = "Engagement Level",
    y        = "Daily PlayTime (Hours)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 10: Bar Plot of GameGenre Distribution (All Players)
genre_counts <- df %>%
  count(GameGenre) %>%
  arrange(GameGenre)

p10 <- ggplot(genre_counts, aes(x = GameGenre, y = n)) +
  geom_col(fill = "#FFAAD4", color = "black") +
  labs(
    title    = "Number of Players by Game Genre",
    subtitle = "Each genre (Sports, Action, Strategy, Simulation, RPG) ~20% of sample",
    x        = "Game Genre",
    y        = "Number of Players"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    axis.text.x      = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Calculate PurchaseRate by GameGenre (Cleaned Subset)
purchase_rate <- df_clean %>%
  group_by(GameGenre) %>%
  summarize(PurchaseRate = mean(InGamePurchases)) %>%
  arrange(GameGenre)

# Plot 11: In-Game Purchase Rate by Game Genre (Cleaned Subset)
p11 <- ggplot(purchase_rate, aes(x = GameGenre, y = PurchaseRate)) +
  geom_col(fill = "orange", color = "black") +
  scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1)) +
  labs(
    title    = "In-Game Purchase Rate by Game Genre",
    subtitle = "Proportion of active players who make purchases",
    x        = "Game Genre",
    y        = "Purchase Rate"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", size = 16),
    plot.subtitle    = element_text(color = "gray40"),
    axis.text.x      = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_line(color = "gray85", linetype = "dashed")
  )

# Plot 12: Boxplot of PlayTimeHours by AgeGroup (Cleaned Subset)
p12 <- ggplot(df_clean, aes(x = AgeGroup, y = PlayTimeHours)) +
  geom_boxplot(
    fill          = "lightcyan",
    color         = "black",
    outlier.color = "darkblue",
    outlier.shape = 16
  ) +
  labs(
    title    = "PlayTime by Age Group",
    subtitle = "Comparing daily hours across age brackets",
    x        = "Age Group",
    y        = "Daily PlayTime (Hours)"
  ) +
  theme_minimal(base_size = 14)

# Print all plots to the plotting device (in sequence)
print(p1)
print(p2)
print(p3)
print(p4)
print(p5)
print(p6)
print(p7)
print(p8)
print(p9)
print(p10)
print(p11)
print(p12)
