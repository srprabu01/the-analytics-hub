# Module 5 Assignment - Nonparametric Methods and Sampling
# Course : ALY6015 - Intermediate Analytics
# Author : Sri Ram Prabu E
# Date   : 10/19/2025
#
# Sign tests, Wilcoxon rank-sum, Wilcoxon signed-rank criticals, Kruskal-Wallis,
# Spearman rank correlation, and Monte-Carlo simulations. Each hypothesis test
# follows: state H0/H1, find critical value, compute test value, decide, summarize.

library(BSDA)

# ============================================================
# Section 13-2 : SIGN TESTS
# ============================================================

# 6) Game Attendance  (H0: median = 3000, two-sided, alpha = 0.05)
# binom.test performs the same calculation as the Sign Test.
attendance <- c(6210, 3150, 2700, 3012, 4875, 3540, 6127, 2581,
                2642, 2573, 2792, 2800, 2500, 3700, 6030, 5437,
                2758, 3490, 2851, 2720)
n_6 <- length(attendance)
x_6 <- sum(attendance > 3000)                 # 10 above (10 below)
cat("\n--- Section 13-2, Problem 6 (Game Attendance) ---\n")
binom_test_6 <- binom.test(x = x_6, n = n_6, p = 0.5, alternative = "two.sided")
print(binom_test_6)

# 10) Lottery Ticket Sales  (H0: median >= 200, left-tailed, alpha = 0.05)
# n = 40 days, x = 15 days with sales < 200.
n_10 <- 40
x_10 <- 15
cat("\n--- Section 13-2, Problem 10 (Lottery Sales) ---\n")
binom_test_10 <- binom.test(x = x_10, n = n_10, p = 0.5, alternative = "greater")
print(binom_test_10)

# ============================================================
# Section 13-3 : WILCOXON RANK-SUM (Mann-Whitney)
# ============================================================

# 4) Prison Sentence Lengths  (H0: no difference [claim], two-sided)
males   <- c(8, 12, 6, 14, 22, 27, 32, 24, 26, 19, 15, 13)
females <- c(7, 5, 2, 3, 21, 26, 30, 9, 4, 17, 23, 12, 11, 16)
cat("\n--- Section 13-3, Problem 4 (Prison Sentences) ---\n")
wilcox_test_4 <- wilcox.test(males, females, alternative = "two.sided", correct = TRUE)
print(wilcox_test_4)

# 8) Winning Baseball Games  (H0: no difference, two-sided)
nl <- c(89, 96, 88, 101, 90, 91, 92, 96, 108, 100, 95)
al <- c(108, 86, 91, 97, 100, 102, 95, 104, 95, 89, 88, 101)
cat("\n--- Section 13-3, Problem 8 (Baseball Wins) ---\n")
wilcox_test_8 <- wilcox.test(nl, al, alternative = "two.sided", correct = TRUE)
print(wilcox_test_8)

# ============================================================
# Section 13-4 : WILCOXON SIGNED-RANK CRITICALS (Table K)
# ============================================================
# Decisions use Table K; for n > 25 (Problem 6) we use the z-approximation.
n_13_4_6  <- 28
ws_13_4_6 <- 32
mu_w    <- (n_13_4_6 * (n_13_4_6 + 1)) / 4
sigma_w <- sqrt((n_13_4_6 * (n_13_4_6 + 1) * (2 * n_13_4_6 + 1)) / 24)
z_test  <- (ws_13_4_6 - mu_w) / sigma_w
z_crit  <- qnorm(0.025)
cat("\n--- Section 13-4, Problem 6 (Z-Test Approx) ---\n")
cat(paste("Mean (mu_w):", mu_w, "\n"))
cat(paste("Std Dev (sigma_w):", round(sigma_w, 3), "\n"))
cat(paste("Test Statistic (z):", round(z_test, 3), "\n"))
cat(paste("Critical Value (z_crit):", round(z_crit, 3), "\n"))

# ============================================================
# Section 13-5 : KRUSKAL-WALLIS TEST
# ============================================================

# 2) Mathematics Literacy Scores  (H0: no difference in means [claim])
scores <- c(527, 406, 474, 381, 411,      # Western Hemisphere
            520, 510, 513, 548, 496,      # Europe
            523, 547, 547, 391, 549)      # Eastern Asia
groups <- factor(c(rep("WH", 5), rep("Europe", 5), rep("EAsia", 5)))
cat("\n--- Section 13-5, Problem 2 (Math Scores) ---\n")
kruskal_test_2 <- kruskal.test(scores ~ groups)
print(kruskal_test_2)
df_k       <- kruskal_test_2$parameter
crit_val_H <- qchisq(p = 0.95, df = df_k)
cat(paste("Critical Value (H):", round(crit_val_H, 3), "\n"))

# ============================================================
# Section 13-6 : SPEARMAN RANK CORRELATION
# ============================================================

# 6) Subway and Commuter Rail Passengers  (H0: rho_s = 0)
subway <- c(845, 494, 425, 313, 108, 41)
rail   <- c(39, 291, 142, 103, 33, 38)
cat("\n--- Section 13-6, Problem 6 (Transit) ---\n")
cor_test_6 <- cor.test(subway, rail, method = "spearman", exact = TRUE)
print(cor_test_6)

# ============================================================
# Section 14-3 : SIMULATION TECHNIQUES
# ============================================================
set.seed(123)

# 16) Prizes in Caramel Corn Boxes - avg boxes to collect all 4 prizes (40 trials)
trials_16 <- 40
get_boxes <- function() {
  prizes_found <- logical(4)
  count <- 0
  while (!all(prizes_found)) {
    count <- count + 1
    prize_won <- sample(1:4, 1)
    prizes_found[prize_won] <- TRUE
  }
  return(count)
}
results_16 <- replicate(trials_16, get_boxes())
mean_boxes <- mean(results_16)
cat("\n--- Section 14-3, Problem 16 (Prizes) ---\n")
cat(paste("Mean boxes to get all 4 prizes (40 trials):", mean_boxes, "\n"))

# 18) Lottery Winner - avg tickets to spell "big"  (P(b)=0.6, P(i)=0.3, P(g)=0.1; 30 trials)
trials_18 <- 30
get_letters <- function() {
  letters_found <- c(b = FALSE, i = FALSE, g = FALSE)
  count <- 0
  while (!all(letters_found)) {
    count <- count + 1
    ticket <- sample(c("b", "i", "g"), 1, prob = c(0.6, 0.3, 0.1))
    letters_found[ticket] <- TRUE
  }
  return(count)
}
results_18 <- replicate(trials_18, get_letters())
mean_tickets <- mean(results_18)
cat("\n--- Section 14-3, Problem 18 (Lottery) ---\n")
cat(paste("Mean tickets to spell 'big' (30 trials):", mean_tickets, "\n"))

cat("\n--- Script Completed ---\n")
