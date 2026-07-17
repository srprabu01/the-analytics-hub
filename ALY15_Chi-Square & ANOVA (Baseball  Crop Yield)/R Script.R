# Module 2 Assignment - Chi-Square and ANOVA
# Course : ALY6015 - Intermediate Analytics
# Author : Sri Ram Prabu E
# Date   : 09/28/2025
#
# Each textbook problem follows the five-step hypothesis-testing method:
#   (a) state H0 / H1, (b) find the critical value, (c) compute the test value,
#   (d) make a decision, (e) summarize in context.

# ============================================================
# CHI-SQUARE GOODNESS-OF-FIT TESTS
# ============================================================

# Problem 11-1.6 : Blood Types  (alpha = 0.10, df = 3)
observed_blood <- c(12, 8, 24, 6)
probs_blood    <- c(0.20, 0.28, 0.36, 0.16)
chisq.test(observed_blood, p = probs_blood)
qchisq(1 - 0.10, df = 3)          # critical value = 6.251

# Problem 11-1.8 : On-Time Performance by Airlines  (alpha = 0.05, df = 3)
observed_airline <- c(125, 10, 25, 40)          # On time, NAS, Late, Other
probs_airline    <- c(0.708, 0.082, 0.090, 0.120)
chisq.test(observed_airline, p = probs_airline)
qchisq(1 - 0.05, df = 3)          # critical value = 7.815

# ============================================================
# CHI-SQUARE TESTS OF INDEPENDENCE
# ============================================================

# Problem 11-2.8 : Ethnicity and Movie Admissions  (alpha = 0.05)
movie_data <- matrix(c(724, 335, 174, 107,
                       370, 292, 152, 140), nrow = 2, byrow = TRUE)
colnames(movie_data) <- c("Caucasian", "Hispanic", "African American", "Other")
rownames(movie_data) <- c("2013", "2014")
chisq.test(movie_data)
qchisq(1 - 0.05, df = 3)          # critical value = 7.815

# Problem 11-2.10 : Women in the Military  (alpha = 0.05)
military_data <- matrix(c(10791, 7816,   932, 11819,
                          62491, 42750, 9525, 54344), nrow = 2, byrow = TRUE)
colnames(military_data) <- c("Army", "Navy", "Marine Corps", "Air Force")
rownames(military_data) <- c("Officers", "Enlisted")
chisq.test(military_data)
qchisq(1 - 0.05, df = 3)          # critical value = 7.815

# ============================================================
# ONE-WAY ANOVA
# ============================================================

# Problem 12-1.8 : Sodium Contents of Foods  (alpha = 0.05)
condiments <- c(270, 130, 230, 180, 80, 70, 200)
cereals    <- c(260, 220, 290, 290, 200, 320, 140, 160)
desserts   <- c(100, 180, 250, 250, 300, 360, 300)
sodium_df <- data.frame(
  sodium = c(condiments, cereals, desserts),
  group  = factor(rep(c("Condiments", "Cereals", "Desserts"),
                      times = c(length(condiments), length(cereals), length(desserts)))))
sodium_aov <- aov(sodium ~ group, data = sodium_df)
summary(sodium_aov)
qf(1 - 0.05, df1 = 2, df2 = 19)   # critical value = 3.52

# Problem 12-2.10 : Sales for Leading Companies  (alpha = 0.01)
cereal    <- c(578, 320, 264, 249, 237)
chocolate <- c(311, 106, 109, 125, 173)
coffee    <- c(261, 185, 302, 689)
sales_df <- data.frame(
  sales   = c(cereal, chocolate, coffee),
  company = factor(rep(c("Cereal", "Chocolate", "Coffee"),
                      times = c(length(cereal), length(chocolate), length(coffee)))))
sales_aov <- aov(sales ~ company, data = sales_df)
summary(sales_aov)
qf(1 - 0.01, df1 = 2, df2 = 11)

# Problem 12-2.12 : Per-Pupil Expenditures  (alpha = 0.05)
eastern <- c(4946, 5953, 6202, 7243, 6113)
middle  <- c(6149, 7451, 6000, 6479)
western <- c(5282, 8605, 6528, 6911)
exp_df <- data.frame(
  exp    = c(eastern, middle, western),
  region = factor(rep(c("Eastern", "Middle", "Western"),
                      times = c(length(eastern), length(middle), length(western)))))
exp_aov <- aov(exp ~ region, data = exp_df)
summary(exp_aov)
qf(1 - 0.05, df1 = 2, df2 = 10)

# ============================================================
# TWO-WAY ANOVA
# ============================================================

# Problem 12-3.10 : Increasing Plant Growth  (Light x Food, alpha = 0.05)
growth <- c(9.2, 9.4, 8.9, 7.1, 7.2, 8.5, 8.5, 9.2, 8.9, 5.5, 5.8, 7.6)
light  <- factor(rep(c(1, 1, 2, 2), each = 3))
food   <- factor(rep(c("A", "B", "A", "B"), each = 3))
plant_df <- data.frame(growth, light, food)
plant_aov <- aov(growth ~ light * food, data = plant_df)
summary(plant_aov)
qf(0.95, 1, 8)                    # critical value = 5.32

# ============================================================
# ADVANCED ANALYSIS IN R - BASEBALL DATASET
# ============================================================
library(dplyr)

bb <- read.csv("baseball.csv")

# EDA
summary(bb)
hist(bb$W, main = "Distribution of Wins")
plot(bb$RS, bb$W, main = "Wins vs. Runs Scored",
     xlab = "Runs Scored", ylab = "Wins")

# Chi-Square Goodness-of-Fit: are wins evenly distributed across decades?
bb$Decade <- bb$Year - (bb$Year %% 10)
bb_filtered <- bb %>% filter(Decade >= 1960 & Decade <= 2000)
wins <- bb_filtered %>%
  group_by(Decade) %>%
  summarize(total_wins = sum(W))
chisq.test(wins$total_wins)
qchisq(0.95, df = 4)              # 5 decades - 1

# ============================================================
# ADVANCED ANALYSIS IN R - CROP DATA (TWO-WAY ANOVA)
# ============================================================
crop <- read.csv("crop_data.csv")

crop$fertilizer <- as.factor(crop$fertilizer)
crop$density    <- as.factor(crop$density)
crop$block      <- as.factor(crop$block)

crop_aov <- aov(yield ~ fertilizer * density + block, data = crop)
summary(crop_aov)

interaction.plot(x.factor    = crop$density,
                 trace.factor = crop$fertilizer,
                 response     = crop$yield,
                 fun = mean, type = "b", pch = 19,
                 main = "Interaction Plot of Fertilizer and Density on Yield",
                 xlab = "Planting Density", ylab = "Mean Crop Yield",
                 col = c("red", "blue", "darkgreen"))
