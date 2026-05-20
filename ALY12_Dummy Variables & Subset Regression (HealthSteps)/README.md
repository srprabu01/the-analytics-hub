<div align="center">

# Module 6 — Dummy Variables & Subset Regression

### *Heart Rate as a Moderator: When the Effect of Steps Depends on Intensity*

[![Module](https://img.shields.io/badge/Module-6-1a3a6e?style=for-the-badge)](#)
[![Course](https://img.shields.io/badge/Course-ALY6010-2b6cb0?style=for-the-badge)](#)
[![Topic](https://img.shields.io/badge/Topic-Dummy%20Variables%20%26%20Subsets-success?style=for-the-badge)](#)
[![Dataset](https://img.shields.io/badge/Dataset-Apple%20Health-orange?style=for-the-badge)](#)

</div>

---

> [!NOTE]
> **Module 6 closes the course arc with the most analytically rich technique
> yet — using a categorical variable to expose interaction effects.** A single
> "average" regression line can hide the fact that *the effect of X on Y
> depends on the level of a third variable Z*. This module demonstrates that
> a step taken at low heart rate is not the same as a step taken at high heart
> rate, even though both are recorded identically by the wearable.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Dataset Overview](#2-dataset-overview)
3. [Creating the Dummy Variable](#3-creating-the-dummy-variable)
4. [Approach 1 — Visual Hypothesis (Multiple Regression Lines)](#4-approach-1--visual-hypothesis-multiple-regression-lines)
5. [Approach 2 — Separate Subset Regressions (Quantitative Proof)](#5-approach-2--separate-subset-regressions-quantitative-proof)
6. [Comparing the Two Approaches](#6-comparing-the-two-approaches)
7. [Why Split at the Median?](#7-why-split-at-the-median)
8. [Key Insights & Conclusion](#8-key-insights--conclusion)
9. [R Script](#9-r-script)
10. [References](#10-references)

---

## 1. Introduction

A simple linear regression assumes one slope describes the relationship
across the entire dataset. But what if the relationship **differs by group**?
A single regression line forced through all data hides this structure.

This module solves that problem two complementary ways:

1. **Approach 1** — Create a dummy variable, plot both groups on the same
   scatterplot with separate fitted lines. *Fast visual diagnosis.*
2. **Approach 2** — Run separate regression models on each subset. *Hard
   numbers for inference.*

The substantive question: **Does heart-rate intensity moderate the
relationship between step count and outcomes like energy burned and walking
speed?**

> [!IMPORTANT]
> **Assignment objectives:**
> 1. Create dummy variables to subset the dataset. Re-run regression for the
>    dependent variable. **How many subsets did you create? How many lines?**
>    Create a scatterplot with multiple regression lines. **How does this
>    impact your understanding of the categorical variable's effect?**
> 2. Using the subsetted data, create separate regression lines for each
>    subset. **How do these regression lines differ from the lines in step 1?
>    How does this method impact your understanding?**

---

## 2. Dataset Overview

**Source:** Personal Apple Health export — `Health.csv` — 1,668 daily records
of wearable-tracked health metrics, spanning roughly 4 years.

### Variables of Interest

| Variable | Description | Mean | SD | Median |
|:---------|:------------|-----:|---:|-------:|
| `StepCount` | Steps recorded per day | 118.08 | 77.88 | 104.43 |
| `ActiveEnergyBurned` | Calories burned through movement (kcal) | 2.62 | 2.20 | 2.62 |
| `WalkingSpeed` | Average walking speed (m/s) | 2.36 | 0.26 | 2.36 |
| `HeartRate` | Heart rate (bpm) — used as moderator | 88.06 | 5.24 | 88.06 |
| `DistanceWalkingRunning` | Distance covered (km) | 0.044 | 0.031 | 0.038 |
| `WalkingStepLength` | Step length (cm) | 25.61 | 2.12 | 25.61 |

After dropping rows with `NA`, n = 1,664 daily records.

```r
library(ggplot2); library(dplyr)

health <- read.csv("Health.csv")
health$date <- as.Date(health$date, format = "%d-%m-%Y")
health <- na.omit(health)
```

---

## 3. Creating the Dummy Variable

### The Code

```r
median_hr <- median(health$HeartRate)   # = 88.06 bpm
health$HR_Group <- ifelse(health$HeartRate <= median_hr, "LowHR", "HighHR")
```

### How Many Subsets and Lines?

> [!IMPORTANT]
> **Two subsets** are created (`LowHR` and `HighHR`). When plotting, **two
> regression lines** are drawn — one for each subset.

| Group | n | Heart Rate Range |
|:------|--:|:-----------------|
| LowHR | 1,533 | ≤ 88.06 bpm |
| HighHR | 131 | > 88.06 bpm |

### Figure 3 — Heart Rate Distribution with Median Split

![HR distribution with median split](images/m6_fig3_hr_split.png)

> [!NOTE]
> **The HR distribution is heavily skewed toward the median (88.06 bpm).**
> Most days, the average heart rate falls just at or below the median —
> typical for a person whose data mostly captures resting/walking periods.
> The right tail (HighHR group) represents days with more intense exercise,
> producing the modest n = 131 imbalance. This imbalance matters for
> interpretation and is discussed in Section 7.

---

## 4. Approach 1 — Visual Hypothesis (Multiple Regression Lines)

Plot both groups on a single scatterplot, with separate `geom_smooth(method="lm")`
fits per group. This is the **dummy-variable visualization** — the dummy
encodes color, and `ggplot2` draws a fit per color group.

### Figure 1 — Active Energy Burned vs. Step Count by HR Group

![Energy vs steps by HR](images/m6_fig1_energy_vs_steps.png)

**What the plot reveals:**

- The **LowHR (teal) line is dramatically steeper** than the HighHR (orange) line.
- The teal cloud spreads across the full step-count range; orange clusters
  in the lower step range.
- For any given increase in steps, a person in the **LowHR group burns
  substantially more cumulative calories** than someone in the HighHR group.

> [!NOTE]
> **Why is LowHR steeper, not HighHR?** This is counterintuitive at first
> glance — surely high heart rate means more calories per step?
>
> The answer is **observation length**: LowHR days are longer continuous
> walks (steady, sustained activity), accumulating many steps and many
> calories. HighHR days are short, intense bursts — fewer total steps and a
> calorie baseline already elevated by the intensity. The slope captures
> the *marginal* calorie per step, which in the HighHR bursts flattens
> because the steps don't dominate the calorie story.

### Figure 2 — Walking Speed vs. Step Count by HR Group

![Speed vs steps by HR](images/m6_fig2_speed_vs_steps.png)

A similar pattern but **far weaker**: both lines barely tilt upward. Step
count is not strongly predictive of walking speed — daily *average* walking
speed depends more on terrain, urgency, and step length than on step volume.

### Impact on Understanding (Approach 1)

> [!TIP]
> The dual-line plot is the **fastest possible** diagnostic for "does the
> relationship between X and Y depend on Z?" — and the answer here is
> unambiguously **yes**. The two lines have visibly different slopes,
> immediately suggesting an interaction effect.

The visualization is **descriptive, not inferential**. We see slopes
*differ* but cannot yet say *by how much*, *with what uncertainty*, or
*whether the difference is statistically significant*. That's Approach 2's job.

---

## 5. Approach 2 — Separate Subset Regressions (Quantitative Proof)

Run `lm()` separately for each subset.

### The Code

```r
# Full dataset baselines
model_energy <- lm(ActiveEnergyBurned ~ StepCount, data = health)
model_speed  <- lm(WalkingSpeed       ~ StepCount, data = health)

# Subset models
model_energy_low  <- lm(ActiveEnergyBurned ~ StepCount,
                        data = subset(health, HR_Group == "LowHR"))
model_energy_high <- lm(ActiveEnergyBurned ~ StepCount,
                        data = subset(health, HR_Group == "HighHR"))

model_speed_low   <- lm(WalkingSpeed ~ StepCount,
                        data = subset(health, HR_Group == "LowHR"))
model_speed_high  <- lm(WalkingSpeed ~ StepCount,
                        data = subset(health, HR_Group == "HighHR"))
```

### Subset Regression Results

#### Active Energy Burned ~ StepCount

| Model | n | Intercept | StepCount β | StepCount p | R² |
|:------|--:|:---------:|:-----------:|:-----------:|:--:|
| **Full** | 1,664 | 0.350 | **0.0193** | < 2e-16 | 0.464 |
| **LowHR** | 1,533 | 0.358 | **0.0209** | < 2e-16 | **0.557** |
| **HighHR** | 131 | 0.255 | **0.0029** | 6.5e-05 | 0.117 |

#### Walking Speed ~ StepCount

| Model | n | Intercept | StepCount β | StepCount p | R² |
|:------|--:|:---------:|:-----------:|:-----------:|:--:|
| **Full** | 1,664 | 2.257 | **0.000851** | < 2e-16 | 0.067 |
| **LowHR** | 1,533 | 2.256 | **0.000860** | < 2e-16 | 0.070 |
| **HighHR** | 131 | 2.259 | **0.000758** | 0.027 | 0.038 |

### Figure 4 — R² Comparison Across Models

![R-squared comparison](images/m6_fig4_r2.png)

The R² bars expose a striking pattern:

- For **energy**, splitting by HR Group **increases the LowHR R² to 0.557**
  (compared to the pooled 0.464). The HighHR R² drops to 0.117 — step
  count poorly predicts energy in that subset.
- For **speed**, R² barely changes — speed is poorly predicted by steps
  in either group.

### Figure 5 — Coefficient Comparison by Group

![Coefficient comparison](images/m6_fig5_coefs.png)

The dual-axis bar chart makes the slope difference visceral:

- **Energy slope (left axis, blue):** LowHR = 0.0209 vs. HighHR = 0.0029 —
  a **7× difference**. The LowHR group burns 7 times more calories per
  marginal step than the HighHR group.
- **Speed slope (right axis, purple):** LowHR = 0.00086 vs. HighHR = 0.00076 —
  essentially identical. **Heart rate does not meaningfully moderate** the
  speed-step relationship.

### Figure 6 — Step Count Distribution by HR Group

![Step count distribution](images/m6_fig6_steps_hist.png)

The histograms show the **structural difference between the two groups**:
LowHR days span the full range of step counts (resting days through long
walks), while HighHR days cluster in the lower step range (short, intense
sessions). This explains *why* the LowHR slope is steeper — there's simply
more data spanning a wider range of activity volumes.

### Impact on Understanding (Approach 2)

> [!TIP]
> Approach 2 lets us move from *"the lines look different"* to **"the LowHR
> energy slope is 7× the HighHR slope, the difference is statistically
> significant, and R² jumps from 0.46 to 0.56 when we subset."** This is
> the leap from visual hypothesis to quantitative conclusion.

We can also see that **the speed relationship is NOT moderated** by heart
rate — the two slopes are nearly identical. Approach 1's visual is much less
clear about this because both lines look "flat-ish." Approach 2's coefficient
table reveals the truth.

---

## 6. Comparing the Two Approaches

| Question | Approach 1 (Dummy in `ggplot`) | Approach 2 (Subset `lm()`) |
|:---------|:-------------------------------|:---------------------------|
| **Speed** | Very fast — one plot call | Slower — multiple models |
| **Visual intuition** | Excellent | Limited |
| **Quantitative inference** | None | Full (coefficient + SE + p + R²) |
| **Standard errors** | Hidden | Explicit |
| **Statistical comparison of slopes** | Not direct | Requires interaction term |
| **Best use** | Initial diagnosis | Confirmation & reporting |

> [!CAUTION]
> **Neither approach gives a formal test of *whether slopes differ*** by
> default. For that, fit a single interaction model:
> ```r
> interaction_model <- lm(ActiveEnergyBurned ~ StepCount * HR_Group,
>                          data = health)
> summary(interaction_model)
> ```
> The coefficient on `StepCount:HR_Group` directly tests whether the slope
> in the HighHR group differs significantly from the LowHR slope.

---

## 7. Why Split at the Median?

The split point matters. Median split is the most common choice — but it
has tradeoffs:

| Choice | Pros | Cons |
|:-------|:-----|:-----|
| **Median** | Equal n per group (in theory); robust to outliers | Hides real cutpoints; n becomes unequal when distribution is skewed (as here) |
| **Mean** | Familiar | Sensitive to outliers |
| **Theoretical threshold** (e.g., 100 bpm for "exercise zone") | Substantively meaningful | Requires domain knowledge |
| **Tertiles / quartiles** | More groups → finer interaction | Loses statistical power per group |

> [!NOTE]
> **Why our subsets are imbalanced (1,533 vs 131).** Our data has many
> repeated values at the median (HR = 88.06 was likely the device's default
> imputation for several quiet periods). The `ifelse(HR ≤ median, ...)`
> assignment sends all of those to LowHR, producing the lopsided split.
> A **strict less-than** would split differently:
> ```r
> health$HR_Group <- ifelse(health$HeartRate < median_hr, "LowHR", "HighHR")
> ```
> The "right" choice depends on the analytical question — for moderation
> tests, the precise cutpoint matters less than ensuring there's enough
> data in each group to fit a stable regression.

---

## 8. Key Insights & Conclusion

### The Six Takeaways

1. **Step count is a strong predictor of energy burned** — both at the full-dataset level (R² = 0.464) and within the LowHR subset (R² = 0.557).
2. **Heart rate moderates this relationship.** A step in the LowHR context contributes ~7× more marginal calories than a step in the HighHR context.
3. **The moderation is *energy-specific*.** Walking speed is *not* meaningfully moderated by heart rate — the two slopes are nearly identical.
4. **Visual + statistical methods complement each other.** Figures 1 and 2 give instant diagnosis; Figures 4 and 5 give the precise numbers.
5. **Pooled models hide subgroup effects.** The full-dataset energy slope (0.0193) is a *weighted average* of the LowHR and HighHR slopes — and matches neither group's actual relationship.
6. **Splits are arbitrary unless justified.** The median split here was a default; a theoretically motivated threshold (e.g., 100 bpm or anaerobic threshold) would tell a different story.

### The Big Lesson

> [!TIP]
> A regression coefficient is a *summary* — it averages the relationship
> across whatever data you give the model. If the relationship genuinely
> differs by group, that average **misrepresents both groups simultaneously**.
> Dummy variables and subset regression are the basic tools for catching
> and quantifying this — and they should be a routine diagnostic step in
> any applied analysis, not an advanced afterthought.

---

## 9. R Script

```r
# Module 6: R Practice Assignment
library(ggplot2); library(dplyr)

health <- read.csv("Health.csv")
health$date <- as.Date(health$date, format = "%d-%m-%Y")
health <- na.omit(health)

# Create dummy variable (median split on HeartRate)
median_hr <- median(health$HeartRate)
health$HR_Group <- ifelse(health$HeartRate <= median_hr, "LowHR", "HighHR")

cat("Median HR:", median_hr, "\n")
cat("LowHR n:", sum(health$HR_Group == "LowHR"), "\n")
cat("HighHR n:", sum(health$HR_Group == "HighHR"), "\n")

# Full dataset baselines
model_energy <- lm(ActiveEnergyBurned ~ StepCount, data = health)
model_speed  <- lm(WalkingSpeed       ~ StepCount, data = health)

# Subset models
model_energy_low  <- lm(ActiveEnergyBurned ~ StepCount,
                        data = subset(health, HR_Group == "LowHR"))
model_energy_high <- lm(ActiveEnergyBurned ~ StepCount,
                        data = subset(health, HR_Group == "HighHR"))

model_speed_low   <- lm(WalkingSpeed ~ StepCount,
                        data = subset(health, HR_Group == "LowHR"))
model_speed_high  <- lm(WalkingSpeed ~ StepCount,
                        data = subset(health, HR_Group == "HighHR"))

# Print summaries
summary(model_energy)
summary(model_speed)
summary(model_energy_low)
summary(model_energy_high)
summary(model_speed_low)
summary(model_speed_high)

# Visualization 1: Energy vs Steps by HR Group
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

# Visualization 2: Walking Speed vs Steps by HR Group
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

# OPTIONAL: Formal interaction test
interaction_model <- lm(ActiveEnergyBurned ~ StepCount * HR_Group,
                        data = health)
summary(interaction_model)
```

---

## 10. References

- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2021). *An introduction to statistical learning: With applications in R* (2nd ed.). Springer. https://doi.org/10.1007/978-1-0716-1418-1
- Aiken, L. S., & West, S. G. (1991). *Multiple regression: Testing and interpreting interactions*. Sage. *(canonical reference for moderation analysis)*
- MacCallum, R. C., Zhang, S., Preacher, K. J., & Rucker, D. D. (2002). On the practice of dichotomization of quantitative variables. *Psychological Methods, 7*(1), 19–40. *(critique of median splits)*
- Wickham, H., Chang, W., Henry, L., et al. (2024). *ggplot2: Create elegant data visualisations using the grammar of graphics*. https://ggplot2.tidyverse.org
- R Core Team. (2024). *R: A language and environment for statistical computing*. https://www.R-project.org/
- Prabu, S. R. E. (2024). *Apple Health data export* [Unpublished raw data].

---

<div align="center">

[← Module 5](Module5_CorrelationRegression.md) &nbsp;•&nbsp; [Back to Portfolio](README.md)

### 🎓 *End of the ALY6010 R Practice Portfolio* 🎓

</div>
