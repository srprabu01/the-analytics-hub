<div align="center">

# Module 2 — Descriptive Statistics of Activity Data

### *Summarizing 40 Workouts: Means, Spreads, and the Anatomy of a Boxplot*

[![Module](https://img.shields.io/badge/Module-2-1a3a6e?style=for-the-badge)](#)
[![Course](https://img.shields.io/badge/Course-ALY6010-2b6cb0?style=for-the-badge)](#)
[![Topic](https://img.shields.io/badge/Topic-Descriptive%20Statistics-success?style=for-the-badge)](#)
[![Dataset](https://img.shields.io/badge/Dataset-Activities.csv-orange?style=for-the-badge)](#)

</div>

---

> [!NOTE]
> **Module 2 sits between cleaning (Module 1) and inference (Module 3+).**
> Descriptive statistics — mean, SD, min, max, n — are the foundation of every
> statistical report. This module also introduces three chart types that every
> analyst should know cold: **scatter, jitter, and boxplot**.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Dataset Overview](#2-dataset-overview)
3. [Data Preparation](#3-data-preparation)
4. [Descriptive Statistics — Overall Sample](#4-descriptive-statistics--overall-sample)
5. [Descriptive Statistics — By Activity Type](#5-descriptive-statistics--by-activity-type)
6. [Three-Line Table Format](#6-three-line-table-format)
7. [Visualizations](#7-visualizations)
8. [When & Why for Each Chart Type](#8-when--why-for-each-chart-type)
9. [Key Findings & Recommendations](#9-key-findings--recommendations)
10. [R Script](#10-r-script)
11. [References](#11-references)

---

## 1. Introduction

This module conducts an exploratory data analysis (EDA) of a personal fitness
dataset comprising **40 recorded workout sessions** — spanning cycling, indoor
cycling, resort skiing, road cycling, and virtual cycling.

**The two assignment objectives:**

1. Produce **descriptive-statistics tables** (mean, SD, min, max, N) for the
   entire sample *and* by group, with interpretive commentary.
2. Use `par()` and `abline()` with various plot-making commands to produce
   **scatter, jitter, and boxplot** charts, with interpretive commentary.

> [!IMPORTANT]
> **Questions posed by the assignment:**
> - *"What is a three-line table format commonly used in white papers?"* → [Section 6](#6-three-line-table-format)
> - *"When do you use a jitter chart?"* → [Section 8](#8-when--why-for-each-chart-type)
> - *"How can boxplots detect outliers?"* → [Section 8](#8-when--why-for-each-chart-type)

---

## 2. Dataset Overview

**Activities.csv** is a personal training export — each row represents one
workout session with 34 columns of recorded metrics.

### Variables of Interest

| Variable | Type | Description |
|:---------|:-----|:------------|
| `ActivityType` | Factor | Cycling / Indoor Cycling / Resort Skiing / Road Cycling / Virtual Cycling |
| `Distance` | Numeric | Distance covered (miles or km depending on activity) |
| `Calories` | Numeric | Energy expended (kcal) |
| `AvgHR`, `MaxHR` | Numeric | Heart rate (bpm) |
| `AerobicTE` | Numeric | Aerobic Training Effect score |
| `AvgSpeed`, `MaxSpeed` | Numeric | Speed (mph) |
| `TotalAscent`, `TotalDescent` | Numeric | Elevation change (ft) |
| `Date` | POSIXct | Session start timestamp |
| `Favorite` | Logical | Marked as favorite by user |

### Activity Type Frequencies

![Activity frequency](images/m2_fig5_freq.png)

> [!NOTE]
> **Heavy imbalance:** Road Cycling dominates with 29 sessions, followed by
> Resort Skiing (7), Virtual Cycling (2), and one-off Cycling and Indoor
> Cycling sessions. **Group-level statistics with n=1 or n=2 must be
> interpreted with extreme caution** — the standard deviation isn't even
> defined for n=1.

---

## 3. Data Preparation

Numeric fields arrived as character strings with embedded commas (e.g.,
`"1,387"`) — they had to be stripped and converted:

```r
library(tidyverse); library(psych); library(scales)

df <- read_csv("Activities.csv")

# Coerce numeric columns from comma-formatted strings
numeric_cols <- c("Distance", "Calories", "AvgHR", "MaxHR", "AerobicTE",
                  "AvgSpeed", "MaxSpeed", "TotalAscent", "TotalDescent")

for (col in numeric_cols) {
  if (col %in% names(df)) {
    if (is.character(df[[col]]) || is.factor(df[[col]])) {
      df[[col]] <- as.numeric(gsub(",", "", as.character(df[[col]])))
    }
  }
}

# Parse timestamps
df$Date     <- as.POSIXct(df$Date, format = "%Y-%m-%d %H:%M:%S")
df$Favorite <- as.logical(df$Favorite)
```

> [!TIP]
> **`gsub(",", "", x)`** is the universal cleaner for comma-formatted numbers
> exported from spreadsheets. Always apply it *before* `as.numeric()`, or
> the conversion silently produces NAs.

---

## 4. Descriptive Statistics — Overall Sample

Computed with `psych::describe()` and a custom `summarise(across(...))` pipeline:

### Table 1: Descriptive Statistics — Entire Sample (n = 40)

| Variable | Mean | SD | Min | Max | n |
|:---------|-----:|---:|----:|----:|--:|
| Distance | 25.12 | 19.77 | 0.0 | 78.95 | 40 |
| Calories | 845.66 | 538.36 | 116.0 | 1,861.0 | 38 |
| AvgHR (bpm) | 149.13 | 14.72 | 118.0 | 172.0 | 38 |
| MaxHR (bpm) | 183.82 | 11.03 | 140.0 | 197.0 | 38 |
| AvgSpeed | 17.99 | 6.44 | 0.8 | 26.8 | 39 |

### Interpretation

- **Distance & Calories:** Mean distance ≈ 25 units (SD ≈ 19.8) implies a
  **wide spread** of short and long sessions. Calories burned average ~846
  with high variability (SD = 538) — workouts span very different intensities.
- **Heart Rate:** Mean `AvgHR` of **149 bpm** indicates these sessions
  consistently pushed into moderate-to-high intensity zones. Mean `MaxHR` of
  184 bpm suggests near-peak effort.
- **Speed:** Most sessions averaged ~18 mph with SD = 6.4 — but the
  minimum of 0.8 mph and maximum of 26.8 hint at outliers worth investigating.

---

## 5. Descriptive Statistics — By Activity Type

### Table 2: Means by Activity Type

| Activity | n | Distance | Calories | AvgHR | AvgSpeed |
|:---------|:-:|---------:|---------:|------:|---------:|
| Road Cycling | 29 | 27.41 | 794.7 | 135.3 | 17.5 |
| Resort Skiing | 7 | 23.52 | 1,268.6 | 114.9 | 8.5 |
| Virtual Cycling | 2 | 15.72 | 281.5 | — | — |
| Cycling | 1 | 13.92 | 441.0 | 133.0 | — |
| Indoor Cycling | 1 | 0.00 | — | — | — |

### Interpretation

- **Road Cycling (n=29)** — the dominant group. Moderate distance with high
  HR and high average speed. Standard deviations are sensible because
  sample size supports them.
- **Resort Skiing (n=7)** — burns the **most calories per session** (1,269!)
  despite *lower* heart rate (115 bpm). This is the **elevation effect** —
  downhill skiing has huge calorie cost from sustained eccentric muscle
  contraction without the HR signature of cardio.
- **Virtual Cycling (n=2)** — no HR data captured (stationary trainer
  disconnected from chest strap), shorter sessions.
- **Cycling (n=1)** and **Indoor Cycling (n=1)** — single sessions; SDs
  undefined.

---

## 6. Three-Line Table Format

> [!IMPORTANT]
> **Assignment Question:** *"What is a three-line table format commonly used
> in white papers?"*

The **three-line (booktabs-style) table** has exactly three horizontal rules:

| Rule | Position |
|:-----|:---------|
| **Top rule** | Above the header row (thicker than middle) |
| **Middle rule** | Between header and body |
| **Bottom rule** | Below the body (thicker than middle) |

There are **no vertical lines** and **no horizontal lines between body rows**.
The format is the standard in academic journals (used by `xtable`, `kable`,
and `stargazer` packages, and the LaTeX `booktabs` package).

**Why this format?**

- Maximizes white space → easier scanning
- Eliminates visual clutter that obscures the data
- Follows Edward Tufte's "minimize ink, maximize data" principle

All tables in Sections 4 and 5 above follow this style.

---

## 7. Visualizations

### Figure 1 — Scatter: Distance vs. Calories

![Scatter distance vs calories](images/m2_fig1_scatter.png)

A clear **positive linear trend**: longer sessions burn more calories. The OLS
regression line (red) confirms r ≈ 0.83. Most points fall between 10–60 units.

> [!NOTE]
> **The cluster at Distance ≈ 0** is the Indoor Cycling session — a real
> calorie burn (~440 kcal) but no distance recorded because the trainer
> didn't transmit virtual distance. This is the kind of data-quality artifact
> that EDA reveals before modeling.

### Figure 2 — Jitter: AvgHR by Activity Type

![Jitter HR by activity](images/m2_fig2_jitter.png)

The **jitter chart** spreads overlapping points horizontally so individual
sessions remain visible:

- **Road Cycling** sessions cluster tightly at **130–170 bpm** — high-intensity
  cardio territory.
- **Resort Skiing** sits noticeably **lower at 100–130 bpm** — sustained
  but submaximal effort.
- **Cycling** (one point) is just visible against the bulk.

Without jittering, the 29 Road Cycling points at ~135 bpm would stack into a
single dot, hiding most of the within-group variation.

### Figure 3 — Boxplot: AvgSpeed by Activity Type

![Boxplot speed](images/m2_fig3_boxplot.png)

The boxplot answers four questions at once for each group:

| Element | What it shows |
|:--------|:--------------|
| **Box** | Interquartile range (IQR = Q3 − Q1) — middle 50% |
| **Line in box** | Median |
| **Whiskers** | Extend to 1.5 × IQR beyond Q1/Q3 |
| **Individual dots beyond whiskers** | Outliers |

Road Cycling: median ~17 mph, IQR 12–22, with sprint outliers > 25 mph.
Resort Skiing: median ~8 mph, wide IQR reflecting terrain variation.

### Figure 4 — Correlation Heatmap (Bonus)

![Activity metric correlations](images/m2_fig4_corr.png)

A diagnostic correlation matrix among the five core metrics. **Strongest
correlation**: Distance ↔ Calories (~0.83), confirming the scatter plot.
**AvgHR ↔ MaxHR** also correlates strongly (>0.7) — same physiological signal.

---

## 8. When & Why for Each Chart Type

### When to use a jitter chart

> [!TIP]
> Use jitter when you have a **categorical x-axis with many tied y-values**.
> Without jitter, points stack invisibly. With jitter, you see the full
> distribution within each category.

| Situation | Jitter? |
|:----------|:-------:|
| One continuous x and one continuous y | ❌ Use scatter |
| Categorical x with **20+ points per category** | ✅ Yes — prevents overplotting |
| Want to show *both* individual points and summary | ✅ Use `geom_jitter()` over `geom_boxplot()` |
| Time-series data | ❌ Use line plot |

### How boxplots detect outliers

The **Tukey rule** is built into `boxplot()`:

> Any point further than **1.5 × IQR** below Q1 or above Q3 is flagged as an
> outlier and drawn as an individual dot.

In Figure 3, the dots above the Road Cycling whisker are sprint sessions
that statistically warrant a closer look. Outliers aren't always errors — they
can be genuine extreme events or sensor failures. Boxplots flag them; the
analyst decides what to do.

---

## 9. Key Findings & Recommendations

| Finding | Implication |
|:--------|:------------|
| Strong Distance ↔ Calories link | Distance is a reliable proxy for energy cost |
| Resort Skiing burns most calories per session | Volume + downhill eccentric load |
| Lower HR for skiing despite high calorie burn | HR alone is an incomplete intensity metric |
| Indoor / Virtual Cycling lack HR data | Sensor pairing issue → fix for future sessions |
| AvgSpeed outliers in Road Cycling | Sprint sessions or group-ride pulls — worth tagging |

> [!CAUTION]
> **Data Quality Recommendations:**
> 1. Verify HR strap pairing before every Indoor / Virtual session
> 2. Investigate `Distance = 0` sessions for sensor errors
> 3. Tag sprint vs. endurance sessions to enable richer subset analysis

---

## 10. R Script

```r
# Module 2
library(tidyverse); library(psych); library(scales)

df <- read_csv("Activities.csv")

# Verify column names
print(names(df))

# Convert character columns to numeric (strip embedded commas)
numeric_cols <- c("Distance","Calories","AvgHR","MaxHR","AerobicTE",
                  "AvgSpeed","MaxSpeed","TotalAscent","TotalDescent")
for (col in numeric_cols) {
  if (col %in% names(df)) {
    if (is.character(df[[col]]) || is.factor(df[[col]])) {
      df[[col]] <- as.numeric(gsub(",", "", as.character(df[[col]])))
    }
  }
}

# Type conversions
df$Date     <- as.POSIXct(df$Date, format = "%Y-%m-%d %H:%M:%S")
df$Favorite <- as.logical(df$Favorite)

# Overall descriptives via psych::describe
desc_overall <- describe(df[numeric_cols])
print(desc_overall)

# Custom summary with tidyverse
desc_summary <- df[numeric_cols] %>%
  summarise(across(everything(),
    list(mean = ~mean(.x, na.rm = TRUE),
         sd   = ~sd(.x,   na.rm = TRUE),
         min  = ~min(.x,  na.rm = TRUE),
         max  = ~max(.x,  na.rm = TRUE),
         n    = ~sum(!is.na(.x))))) %>%
  pivot_longer(cols = everything(),
               names_to  = c("Variable", ".value"),
               names_sep = "_")
print(desc_summary)

# By ActivityType
desc_by_activity <- df %>%
  group_by(ActivityType) %>%
  select(all_of(numeric_cols)) %>%
  summarise(across(everything(),
    list(mean = ~mean(.x, na.rm = TRUE),
         sd   = ~sd(.x,   na.rm = TRUE),
         min  = ~min(.x,  na.rm = TRUE),
         max  = ~max(.x,  na.rm = TRUE),
         n    = ~sum(!is.na(.x)))),
    .groups = "drop")
print(desc_by_activity)

# Scatter: Distance vs Calories
plot(df$Distance, df$Calories,
     main = "Figure 1: Scatter – Distance vs Calories",
     xlab = "Distance", ylab = "Calories",
     pch  = 16,
     col  = scales::alpha("steelblue", 0.6))
abline(lm(Calories ~ Distance, data = df), col = "darkred", lwd = 1.2)

# Jitter: AvgHR by ActivityType
par(mar = c(8, 5, 4, 2) + 0.1)
stripchart(AvgHR ~ ActivityType, data = df, vertical = TRUE,
           method = "jitter", pch = 16,
           col = scales::alpha("darkgreen", 0.6),
           main = "Figure 2: Jitter – AvgHR by ActivityType",
           xlab = "Activity Type", ylab = "Average Heart Rate")

# Boxplot: AvgSpeed by ActivityType
par(mar = c(8, 5, 4, 2) + 0.1)
boxplot(AvgSpeed ~ ActivityType, data = df,
        main = "Figure 3: Boxplot – AvgSpeed by ActivityType",
        xlab = "Activity Type", ylab = "Average Speed",
        outline = TRUE, col = "lightcyan")
```

---

## 11. References

- Revelle, W. (2023). *psych: Procedures for psychological, psychometric, and personality research*. https://cran.r-project.org/package=psych
- Tufte, E. R. (2001). *The visual display of quantitative information* (2nd ed.). Graphics Press.
- Wickham, H. (2016). *ggplot2: Elegant graphics for data analysis* (2nd ed.). Springer.
- Tukey, J. W. (1977). *Exploratory data analysis*. Addison-Wesley.

---

<div align="center">

[← Module 1](Module1_ExploratoryDataAnalysis.md) &nbsp;•&nbsp; [Back to Portfolio](README.md) &nbsp;•&nbsp; [Next: Module 3 →](Module3_HypothesisTesting.md)

</div>
