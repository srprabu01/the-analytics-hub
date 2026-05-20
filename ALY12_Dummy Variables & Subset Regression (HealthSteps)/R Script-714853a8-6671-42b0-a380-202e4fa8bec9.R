# Module 6: R Practice Assignment

library(ggplot2)
library(dplyr)

health <- read.csv("Health.csv")
health$date <- as.Date(health$date, format = "%d-%m-%Y")
health <- na.omit(health)

# HeartRate group (dummy variable)
median_hr <- median(health$HeartRate)
health$HR_Group <- ifelse(health$HeartRate <= median_hr, "LowHR", "HighHR")

# Full dataset regressions
model_energy <- lm(ActiveEnergyBurned ~ StepCount, data = health)
model_speed <- lm(WalkingSpeed ~ StepCount, data = health)

# Subset regressions
model_energy_low <- lm(ActiveEnergyBurned ~ StepCount, data = subset(health, HR_Group == "LowHR"))
model_energy_high <- lm(ActiveEnergyBurned ~ StepCount, data = subset(health, HR_Group == "HighHR"))

model_speed_low <- lm(WalkingSpeed ~ StepCount, data = subset(health, HR_Group == "LowHR"))
model_speed_high <- lm(WalkingSpeed ~ StepCount, data = subset(health, HR_Group == "HighHR"))

summary(model_energy)
summary(model_speed)
summary(model_energy_low)
summary(model_energy_high)
summary(model_speed_low)
summary(model_speed_high)


# Active Energy Burned vs Step Count by HR Group
ggplot(health, aes(x = StepCount, y = ActiveEnergyBurned, color = HR_Group)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linetype = "solid", size = 1.2) +
  labs(
    title = "Active Energy Burned vs. Step Count by Heart Rate Group",
    subtitle = "Regression lines show variation in energy burn with physical activity",
    x = "Step Count",
    y = "Active Energy Burned (kcal)",
    color = "Heart Rate Group"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")

# Walking Speed vs Step Count by HR Group
ggplot(health, aes(x = StepCount, y = WalkingSpeed, color = HR_Group)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linetype = "solid", size = 1.2) +
  labs(
    title = "Walking Speed vs. Step Count by Heart Rate Group",
    subtitle = "Heart rate moderates the relationship between step count and walking speed",
    x = "Step Count",
    y = "Walking Speed (m/s)",
    color = "Heart Rate Group"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")
