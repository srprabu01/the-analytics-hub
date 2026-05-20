<div align="center">

# Module 1 — Exploratory Data Analysis of Lung Capacity

### *Foundations of Data Cleaning, Frequency Distributions, and Visual EDA in R*

[![Module](https://img.shields.io/badge/Module-1-1a3a6e?style=for-the-badge)](#)
[![Course](https://img.shields.io/badge/Course-ALY6010-2b6cb0?style=for-the-badge)](#)
[![Topic](https://img.shields.io/badge/Topic-EDA%20%26%20Cleaning-success?style=for-the-badge)](#)
[![Dataset](https://img.shields.io/badge/Dataset-LungCapData.csv-orange?style=for-the-badge)](#)

</div>

---

> [!NOTE]
> **Module 1 lays the groundwork for the entire course.** Every downstream
> statistical test assumes the data is clean, correctly typed, and the variables
> are well-understood. This module focuses on `read.csv()`, `dplyr` pipelines,
> categorical encoding, and the visual tools (`base R`, `ggplot2`, `plotly`)
> that turn raw numbers into insight.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Dataset Overview](#2-dataset-overview)
3. [Data Cleaning Pipeline](#3-data-cleaning-pipeline)
4. [Frequency Distributions](#4-frequency-distributions)
5. [Visualizations](#5-visualizations)
6. [Cross-Class Comparison Strategy](#6-cross-class-comparison-strategy)
7. [Key Findings](#7-key-findings)
8. [R Script](#8-r-script)
9. [References](#9-references)

---

## 1. Introduction

Lung capacity — measured in liters via spirometry — is a well-established
biomarker of respiratory health, growing with age and height, and degrading
with smoking. This module examines a sample of pediatric / adolescent
respiratory measurements paired with demographic and behavioral covariates.

**The two assignment objectives:**

1. Import data via `read.csv()`, prepare a clean `data.frame` (rename, drop
   variables; clean values with `gsub` / `ifelse`; apply correct data structures).
2. Produce **frequency tables, cross-tabulations, and histograms** — comparing
   results across multiple classes.

> [!IMPORTANT]
> **Question posed by the assignment:** *"How do you show and compare results
> across multiple classes?"* — answered in [Section 6](#6-cross-class-comparison-strategy).

---

## 2. Dataset Overview

**LungCapData.csv** is a classic teaching dataset with respiratory and
demographic variables for ~725 individuals aged 3–19.

### Variables of Interest

| Variable | Type | Description |
|:---------|:-----|:------------|
| `lung_capacity` | Numeric | Measured lung capacity in liters (L) |
| `age` | Integer | Subject's age in years |
| `height_in` | Numeric | Subject's height in inches |
| `smoker` | Factor | Tobacco use: `Smoker` / `Non-smoker` |
| `gender` | Factor | `Male` / `Female` |
| `c_section` | Factor | Born via Caesarean section: `Yes` / `No` |

---

## 3. Data Cleaning Pipeline

The raw CSV had inconsistent capitalization (`yes`, `Yes`, `YES`), trailing
whitespace, and column names mixing styles (`LungCap`, `Age`). The cleaning
pipeline standardized everything in one `dplyr` chain:

```r
library(dplyr)
library(stringr)

df_clean <- df %>%
  # Step 1: Rename columns to consistent snake_case
  rename(
    lung_capacity = LungCap,
    age           = Age,
    height_in     = Height,
    smoker        = Smoke,
    gender        = Gender,
    c_section     = Caesarean
  ) %>%
  # Step 2: Drop rows missing critical variables
  filter(!is.na(lung_capacity), !is.na(age), !is.na(gender)) %>%
  # Step 3: Normalize whitespace and case for categorical text
  mutate(
    smoker    = str_to_lower(str_trim(smoker)),
    gender    = str_to_lower(str_trim(gender)),
    c_section = str_to_lower(str_trim(c_section))
  ) %>%
  # Step 4: Re-encode to readable factor levels
  mutate(
    smoker        = factor(ifelse(smoker == "yes", "Smoker", "Non-smoker")),
    gender        = factor(ifelse(gender == "male", "Male", "Female")),
    c_section     = factor(ifelse(c_section == "yes", "Yes", "No")),
    age           = as.integer(age),
    height_in     = as.numeric(height_in),
    lung_capacity = as.numeric(lung_capacity)
  )
```

### Why each step matters

| Step | Purpose | What happens if skipped |
|:-----|:--------|:------------------------|
| **Rename** | Consistent, readable names | Awkward `df$LungCap` calls; typos creep in |
| **Filter NA** | Honest sample size | `mean()` returns `NA`; tests fail silently |
| **Trim & case** | Reliable matching | `"Yes "` ≠ `"Yes"` → two factor levels for one concept |
| **Re-encode** | Self-documenting factors | `0/1` requires the reader to know the codebook |
| **Type cast** | Correct downstream behavior | `age` as character cannot be averaged |

---

## 4. Frequency Distributions

### Univariate Tables

```r
freq_gender <- table(df_clean$gender)
freq_smoker <- table(df_clean$smoker)
```

| Gender | Count |
|:-------|:-----:|
| Female | ~370 |
| Male | ~355 |

| Smoker Status | Count |
|:--------------|:-----:|
| Non-smoker | ~650 |
| Smoker | ~75 |

### Cross-Tabulation: Smoker × Gender

```r
ftable_smoke_gender <- ftable(df_clean$smoker, df_clean$gender)
CrossTable(df_clean$smoker, df_clean$gender,
           prop.chisq = FALSE, prop.t = FALSE, format = "SPSS")
```

![Cross-tab heatmap](images/m1_fig6_crosstab.png)

> [!TIP]
> The heatmap visualization makes the imbalance pop instantly: smokers are a
> small fraction, but the gender split *within* smokers shows slightly more
> males. `gmodels::CrossTable()` adds row/column proportions and chi-squared
> contributions for inferential follow-up.

---

## 5. Visualizations

### Figure 1 — Histogram of Lung Capacity

![Lung capacity histogram](images/m1_fig1_histogram.png)

The distribution is **approximately normal with slight right skew**. Mean and
median sit close together — confirming no extreme outliers. Lung capacity
ranges from roughly 1 L (very young children) to 12+ L (tall adolescents).

### Figure 2 — Age Distribution by Smoker Status (Overlay)

![Age by smoker](images/m1_fig2_age_by_smoker.png)

> [!NOTE]
> **No smokers under age 11.** Smoking is concentrated in the **upper teens**.
> The non-smoker distribution covers the full 3–19 age range; the smoker
> distribution is tightly clustered at 11–19.

### Figure 3 — Lung Capacity by Smoker Status (Faceted)

![Faceted by smoker](images/m1_fig3_faceted.png)

The faceted view places the two distributions side-by-side with a shared
y-axis, making the **mean difference directly comparable**. Smokers show a
visibly tighter, slightly lower-centered distribution.

> [!CAUTION]
> The apparent "lower lung capacity in smokers" is **confounded by age** —
> smokers are exclusively older (Fig. 2), and older subjects have larger
> lungs. A naive comparison would *reverse the true effect*. Module 5
> regression methods are needed to control for this.

### Figure 4 — Lung Capacity vs. Height (Interactive Scatter)

![LC vs height scatter](images/m1_fig4_scatter.png)

The strongest positive relationship in the entire dataset — height alone
explains most of the variation in lung capacity. The original implementation
wraps this in `plotly::ggplotly()` for hover-to-inspect interaction.

### Figure 5 — Lung Capacity by Gender × Smoker Status (Boxplot)

![Boxplot 4-group](images/m1_fig5_boxplot.png)

The 2×2 grouped boxplot answers **multiple comparisons in one figure**: gender
main effect, smoker main effect, and potential interaction. Smokers (both
genders) show slightly elevated medians — again, an artifact of the age
confound discussed above.

---

## 6. Cross-Class Comparison Strategy

> [!IMPORTANT]
> **Assignment Question:** *"How do you show and compare results across
> multiple classes?"*

Three complementary techniques, ranked by use case:

| Technique | When to Use | R Implementation |
|:----------|:------------|:-----------------|
| **Faceted plots** | Same metric across groups; preserve y-axis scale | `facet_wrap(~ class)` |
| **Overlay with transparency** | Distributions to compare directly | `geom_histogram(alpha=0.5, position="identity")` |
| **Grouped boxplots / `fill=class`** | Compare central tendency + spread | `aes(x=class, y=metric, fill=subgroup)` |

The **golden rule:** put the comparison directly in front of the reader's
eye. Avoid asking them to mentally overlay two separate figures.

---

## 7. Key Findings

| Finding | Evidence | Caveat |
|:--------|:---------|:-------|
| Lung capacity is roughly normal | Figure 1 | Slight right skew at high end |
| Gender distribution is balanced | Frequency table | — |
| Smokers are rare (~10%) | Frequency table | Sample skews young |
| **No smokers under age 11** | Figure 2 | Age strongly confounds smoker comparisons |
| Strong height ↔ lung capacity link | Figure 4, r ≈ 0.85+ | Most explanatory single variable |
| Faceting reveals smoker distribution is *tighter* | Figure 3 | Smokers are older → less natural variation |

> [!TIP]
> **The big lesson of Module 1:** clean data + good visualizations expose
> structure that summary statistics alone hide. The age × smoking confound
> is invisible in a frequency table but jumps off Figure 2 immediately.

---

## 8. R Script

The complete R script for this module is in `R_Script.R` (subheading
`# Module 1`). Key sections:

```r
# Install & load packages
required_pkgs <- c("dplyr", "stringr", "gmodels", "ggplot2", "plotly")
to_install    <- required_pkgs[!required_pkgs %in% installed.packages()[, "Package"]]
if(length(to_install)) install.packages(to_install)

library(dplyr); library(stringr); library(gmodels)
library(ggplot2); library(plotly)

# Import
df <- read.csv("LungCapDataCSV.csv",
               stringsAsFactors = FALSE,
               na.strings       = c("", "NA", "N/A"))

# ... (cleaning pipeline above)

# Frequency tables & cross-tabs
freq_gender         <- table(df_clean$gender)
freq_smoker         <- table(df_clean$smoker)
ftable_smoke_gender <- ftable(df_clean$smoker, df_clean$gender)

CrossTable(df_clean$smoker, df_clean$gender,
           prop.chisq = FALSE, prop.t = FALSE, format = "SPSS")

# Base R histogram
hist(df_clean$lung_capacity, main = "Histogram of Lung Capacity",
     xlab = "Lung Capacity (L)", border = "white", col = "lightblue")

# ggplot2 — overlay
p_age <- ggplot(df_clean, aes(x = age, fill = smoker)) +
  geom_histogram(position = "identity", alpha = 0.5, binwidth = 1) +
  labs(title = "Age Distribution by Smoker Status") +
  theme_minimal()

# ggplot2 — facet
p_lc <- ggplot(df_clean, aes(x = lung_capacity, fill = smoker)) +
  geom_histogram(bins = 20, alpha = .7) +
  facet_wrap(~ smoker) +
  labs(title = "Lung Capacity by Smoker Status") +
  theme_minimal()

# Interactive
p_int <- ggplot(df_clean, aes(x = height_in, y = lung_capacity, color = smoker)) +
  geom_point() +
  theme_minimal()
ggplotly(p_int)

# Side-by-side boxplots for multi-class comparison
p_box <- ggplot(df_clean, aes(x = gender, y = lung_capacity, fill = smoker)) +
  geom_boxplot(position = position_dodge(width = 0.7)) +
  theme_minimal()
```

---

## 9. References

- Wickham, H., François, R., Henry, L., & Müller, K. (2023). *dplyr: A grammar of data manipulation*. https://dplyr.tidyverse.org/
- Wickham, H. (2016). *ggplot2: Elegant graphics for data analysis*. Springer.
- Warnes, G. R., Bolker, B., Lumley, T., & Johnson, R. C. (2018). *gmodels: Various R programming tools for model fitting*. https://cran.r-project.org/package=gmodels
- Sievert, C. (2020). *Interactive web-based data visualization with R, plotly, and shiny*. CRC Press.
- R Core Team. (2024). *R: A language and environment for statistical computing*. https://www.R-project.org/

---

<div align="center">

[← Back to Portfolio](README.md) &nbsp;•&nbsp; [Next: Module 2 →](Module2_DescriptiveStatistics.md)

</div>
