library(MASS)
library(ggplot2)

cat("\n========== PART 1: Cats Dataset T-Test ==========\n")

# Question: Do male and female cat samples have the same bodyweight (“Bwt”)?

data(cats)

male_bwt <- subset(cats, subset = (cats$Sex == "M"))$Bwt
female_bwt <- subset(cats, subset = (cats$Sex == "F"))$Bwt

# Visualization 1: Generate a boxplot to visually compare the body weights
boxplot(Bwt ~ Sex, data = cats,
        main = "Comparison of Body Weight between Male and Female Cats",
        xlab = "Sex",
        ylab = "Body Weight (kg)",
        col = c("pink", "lightblue"), # Matches 'F' then 'M' factor levels
        names = c("Female", "Male"))

bwt_test <- t.test(male_bwt, female_bwt, var.equal = FALSE)

print(bwt_test)

# Visualization 2: Check normality with Q-Q Plots
par(mfrow = c(1, 2)) # Set up a 1x2 grid to show plots side-by-side
qqnorm(female_bwt, main = "Q-Q Plot: Female Cat Bwt")
qqline(female_bwt)
qqnorm(male_bwt, main = "Q-Q Plot: Male Cat Bwt")
qqline(male_bwt)
par(mfrow = c(1, 1)) # Reset the plotting grid to 1x1

cat("\n========== PART 2: Sleep Quality Paired T-Test ==========\n")

# Question: Does meditation improve sleeping quality?

# Null Hypothesis (H0): The mean difference in sleep scores (after - before) is <= 0.
# Alternative Hypothesis (Ha): The mean difference in sleep scores (after - before) is > 0.

before_scores <- c(4.6, 7.8, 9.1, 5.6, 6.9, 8.5, 5.3, 7.1, 3.2, 4.4)
after_scores  <- c(6.6, 7.7, 9.0, 6.2, 7.8, 8.3, 5.9, 6.5, 5.8, 4.9)

sleep_test <- t.test(after_scores, before_scores, paired = TRUE, alternative = "greater")

print(sleep_test)

# --- Visualization 2A: Boxplot of Differences ---
cat("\n--- Now generating visualizations for Part 2 ---\n")
score_differences <- after_scores - before_scores

boxplot(score_differences,
        main = "Distribution of Sleep Quality Improvement (After - Before)",
        ylab = "Difference in Sleep Score",
        col = "lightgreen",
        horizontal = TRUE)
abline(v = 0, col = "red", lty = 2)


# --- Visualization 2B: Paired Line Plot with ggplot2 and Legend ---
student_id <- 1:10
sleep_data <- data.frame(
  ID = rep(student_id, 2),
  Time = factor(rep(c("Before", "After"), each = 10), levels = c("Before", "After")),
  Score = c(before_scores, after_scores)
)
sleep_data$Student <- paste("Student", sleep_data$ID)

revised_paired_plot <- ggplot(sleep_data, aes(x = Time, y = Score, group = ID)) +
  geom_line(aes(color = Student)) + # Map color to the "Student" column
  geom_point(size = 3, aes(color = Student)) +
  labs(title = "Individual Sleep Quality Scores Before and After Meditation",
       x = "Time of Measurement",
       y = "Sleep Quality Score (0–10)") +
  theme_minimal() +
  theme(legend.title = element_blank()) # Hides the legend title for a cleaner look

print(revised_paired_plot)


# --- Visualization: Alternative Line Plot ---
plot(1:10, before_scores,
     type = "b", # 'b' for both points and lines
     col = "blue",
     pch = 16,    # Solid circle point style
     ylim = c(min(c(before_scores, after_scores)) - 0.5, max(c(before_scores, after_scores)) + 0.5),
     ylab = "Sleep Quality Score",
     xlab = "Subject ID",
     main = "Sleep Quality Before and After Meditation (Alternative View)")

lines(1:10, after_scores,
      type = "b",
      col = "green",
      pch = 17) # Solid triangle point style

legend("bottomright",
       legend = c("Before", "After"),
       col = c("blue", "green"),
       pch = c(16, 17),
       lty = 1)

cat("\n--- Script finished ---\n")