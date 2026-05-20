<div align="center">

# Module 3 — Hypothesis Testing on COVID-19 Mortality

### *From Sample to Inference: One-Sample t-Tests and Proportion Tests in Practice*

[![Module](https://img.shields.io/badge/Module-3-1a3a6e?style=for-the-badge)](#)
[![Course](https://img.shields.io/badge/Course-ALY6010-2b6cb0?style=for-the-badge)](#)
[![Topic](https://img.shields.io/badge/Topic-Hypothesis%20Testing-success?style=for-the-badge)](#)
[![Dataset](https://img.shields.io/badge/Dataset-COVID--19%20Mortality-orange?style=for-the-badge)](#)

</div>

---

> [!NOTE]
> **Module 3 is the bridge from describing data to drawing inferences about
> the world.** Hypothesis tests let us decide whether a sample provides
> sufficient evidence against a claim about the population. This module
> applies one-sample t-tests and a proportion test to U.S. COVID-19 mortality
> data — answering substantive public-health questions with formal statistics.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Dataset Overview](#2-dataset-overview)
3. [Test 1 — One-Sample t-Test on Total Deaths](#3-test-1--one-sample-t-test-on-total-covid-19-deaths)
4. [Test 2 — One-Sample t-Test on Crude Death Rate](#4-test-2--one-sample-t-test-on-crude-death-rate)
5. [Test 3 — Proportion Test on Extreme Rates](#5-test-3--proportion-test-on-extreme-rates)
6. [Normality Diagnostics](#6-normality-diagnostics)
7. [Overall Insight & Public-Health Implications](#7-overall-insight--public-health-implications)
8. [R Script](#8-r-script)
9. [References](#9-references)

---

## 1. Introduction

The COVID-19 pandemic generated an unprecedented public dataset on
jurisdiction-level mortality. This module uses **inferential statistics** —
moving past description into formal claim-testing — to evaluate three
substantive hypotheses:

| Test | Claim |
|:-----|:------|
| 1 | The mean number of COVID-19 deaths per jurisdiction equals 10,000 |
| 2 | The mean crude COVID-19 death rate exceeds 100 deaths per 100,000 |
| 3 | Fewer than 50% of jurisdictions exceed a "very high" rate of 200/100k |

**Why these specific claims?** Each is a benchmark that policymakers and
journalists have invoked when describing the pandemic. Formal testing turns
intuition ("it felt like a lot of deaths") into evidence.

> [!IMPORTANT]
> **Assignment objectives:**
> 1. Conduct a one-sample t-test for the **mean** using `t.test()`, with stated
>    hypotheses and interpretation.
> 2. Conduct hypothesis testing for a **proportion (p-value)**, with stated
>    hypotheses and interpretation.

---

## 2. Dataset Overview

**Source:** *Provisional COVID-19 Death Counts, Rates, and Percent of Total
Deaths by Jurisdiction of Residence* — published by the U.S. Department of
Health and Human Services on data.gov.

**Key variables:**

| Variable | Description |
|:---------|:------------|
| `Jurisdiction_Residence` | U.S. region or state (65 unique jurisdictions) |
| `COVID_deaths` | Recorded COVID-19 deaths in the period |
| `crude_COVID_rate` | Deaths per 100,000 population (unadjusted) |
| `aa_COVID_rate` | Age-adjusted COVID rate |
| `data_period_start/end` | Reporting window |

**After dropping rows with `NA` in `COVID_deaths` or `crude_COVID_rate`:**
**30,276 records** across **65 jurisdictions** spanning the full pandemic
period (January 2020 onward).

```r
library(ggplot2); library(dplyr); library(scales)

df <- read.csv("Provisional_COVID-19_death_counts....csv")
df_clean <- na.omit(df[, c("COVID_deaths", "crude_COVID_rate")])
```

---

## 3. Test 1 — One-Sample t-Test on Total COVID-19 Deaths

### Hypotheses

- **H₀:** μ = 10,000 (mean COVID-19 deaths equals 10,000)
- **H₁:** μ ≠ 10,000 (two-tailed)

### Why a one-sample t-test?

- We have **one sample** (`COVID_deaths`) and want to compare its mean to a
  **single hypothesized value** (10,000).
- The population standard deviation is unknown → t-distribution, not z.
- Sample size is large (n = 30,276) → CLT applies even if individual records
  are non-normal.

### R Code

```r
t_test_deaths <- t.test(df_clean$COVID_deaths, mu = 10000)
print(t_test_deaths)
```

### Results

```
        One Sample t-test

data:  df_clean$COVID_deaths
t ≈ 26.67     df = 30,275     p-value < 2.2e-16
alternative hypothesis: true mean is not equal to 10000
sample estimate (mean of x): ≈ 24,770 deaths
```

### Visualization

![Figure 1: COVID Deaths Histogram](images/m3_fig1_deaths_hist.png)

The red dashed line marks the hypothesized 10,000. The observed mean of
**~24,770 deaths** sits more than 14,000 deaths to the right, with a long
right tail extending into the hundreds of thousands.

### Interpretation

> [!TIP]
> **Reject H₀ decisively.** The mean number of COVID-19 deaths across
> jurisdiction-periods is significantly different from 10,000. The observed
> mean of ~24,770 reflects a **severe mortality toll** — the pandemic's true
> burden was roughly **2.5× the hypothesized benchmark**.

The p-value of < 2.2e-16 means: *if H₀ were true and the population mean
really were 10,000, the probability of observing this sample mean (or one
more extreme) by chance alone would be essentially zero.*

---

## 4. Test 2 — One-Sample t-Test on Crude Death Rate

### Hypotheses

- **H₀:** μ ≤ 100 deaths per 100,000 population
- **H₁:** μ > 100 (one-tailed, "greater than")

### Why one-tailed here?

The substantive claim is *directional* — that the crude rate exceeded a
high-burden threshold. A one-tailed test allocates all of α = 0.05 to the
upper tail, giving more statistical power for detecting upward departures.

### R Code

```r
t_test_rate <- t.test(df_clean$crude_COVID_rate,
                      mu = 100, alternative = "greater")
print(t_test_rate)
```

### Results

```
        One Sample t-test

data:  df_clean$crude_COVID_rate
t ≈ 56.52     df = 30,275     p-value ≈ 0
alternative hypothesis: true mean is greater than 100
sample mean: ≈ 152.88 per 100,000
```

### Visualization

![Figure 2a: Crude Rate Histogram](images/m3_fig2a_rate_hist.png)

The distribution is **heavily right-skewed**, with mass between 0 and 300/100k
and a long tail of jurisdictions experiencing higher rates. The blue dashed
line at 100/100k cuts through the *left side* of the bulk of the
distribution — visually corroborating the test result.

![Figure 2b: Crude Rate Boxplot](images/m3_fig2b_rate_box.png)

The boxplot makes the same point quantitatively: the **median sits above
100** and the entire interquartile range (Q1 to Q3) is above the threshold.
Many outliers extend beyond 400/100k — these are heavily impacted
jurisdictions and time periods.

### Interpretation

> [!TIP]
> **Reject H₀.** The mean crude COVID-19 death rate is **significantly
> greater than 100 per 100,000**. The observed sample mean (~152.88) means
> that, on average, jurisdictions saw roughly **1.5× the threshold rate**.

---

## 5. Test 3 — Proportion Test on Extreme Rates

### Hypotheses

- **H₀:** p ≥ 0.50 (at least half of records exceed 200/100k)
- **H₁:** p < 0.50 (less than half exceed it)

### Why a proportion test?

Tests 1 and 2 asked about *averages*. This test asks about a **count
proportion**: of all records, what fraction breaches the "very high" 200/100k
threshold? `prop.test()` uses a normal approximation to the binomial.

### R Code

```r
threshold <- 200
n_total <- length(df_clean$crude_COVID_rate)
n_high  <- sum(df_clean$crude_COVID_rate > threshold)

prop_test <- prop.test(x = n_high, n = n_total,
                       p = 0.5, alternative = "less")
print(prop_test)
```

### Results

```
        1-sample test for given proportion

data:  n_high out of n_total
n_high = 11,942     n_total = 30,276
observed proportion: 0.3944
X-squared with continuity correction
p-value < 2.2e-16
95% CI: [0.000, 0.399]
```

### Visualization

![Figure 3: Proportion above 200](images/m3_fig3_proportion.png)

**39.4%** of records exceed 200/100k — well below the 50% null hypothesis,
shown by the dashed reference line. The remaining **60.6%** fall at or below.

### Interpretation

> [!TIP]
> **Reject H₀.** Fewer than 50% of records exceed the "very high"
> threshold of 200/100k. Severe mortality was **concentrated in a minority
> of regions and periods** — striking evidence of geographic and temporal
> disparity in the pandemic's impact.

---

## 6. Normality Diagnostics

The COVID rate data is heavily right-skewed. Does the t-test still apply?

![Figure 4: Q-Q Plot diagnostics](images/m3_fig4_qq.png)

The **left panel (untransformed)** shows pronounced curvature in the upper
tail — points fall far above the reference line, confirming right-skew.

The **right panel (log-transformed)** shows points falling much closer to the
line — log transformation substantially improves normality.

> [!CAUTION]
> **Why this still matters even with n = 30,276.** With samples this large,
> the **Central Limit Theorem** ensures that the *sampling distribution of
> the mean* is approximately normal regardless of the underlying data
> distribution. The t-test is robust here. But for *small samples* with
> this kind of skew, log-transformation before testing would be advisable.

---

## 7. Overall Insight & Public-Health Implications

### Combined Findings

| Test | Conclusion | Implication |
|:-----|:-----------|:------------|
| 1 | Mean deaths >> 10,000 (~24,770) | Pandemic burden far exceeded round-number benchmarks |
| 2 | Mean crude rate > 100/100k | Rate-based burden also high on average |
| 3 | < 50% above 200/100k (~39%) | Severe burden concentrated in a minority |

### Bringing it together

> [!IMPORTANT]
> **The pandemic was severe on average, but the burden was not evenly
> distributed.** Public-health strategies should consider *both* the national
> picture (Tests 1 and 2) *and* the regional concentration (Test 3). A
> "one-size-fits-all" intervention misses where it matters most — and
> over-allocates resources to places where it matters less.

### Policy recommendations

| Finding | Action |
|:--------|:-------|
| High national average | Maintain federal-level pandemic infrastructure (surveillance, vaccine distribution) |
| Concentrated severe regions | Allocate disproportionate ICU, staffing, and outreach resources to high-rate jurisdictions |
| Wide rate variation | Investigate *why* certain regions had 3–5× the median rate (urban density, vaccine coverage, age structure, comorbidity prevalence) |

---

## 8. R Script

```r
library(ggplot2); library(dplyr); library(scales)

df <- read.csv("Provisional_COVID-19_death_counts....csv")
df_clean <- na.omit(df[, c("COVID_deaths", "crude_COVID_rate")])

# TEST 1: One-sample t-test on COVID_deaths
t_test_deaths <- t.test(df_clean$COVID_deaths, mu = 10000)
print("One-Sample t-Test: COVID_deaths vs 10000")
print(t_test_deaths)

# Visualization 1
ggplot(df_clean, aes(x = COVID_deaths)) +
  geom_histogram(binwidth = 2000, fill = "skyblue", color = "black", alpha = 0.7) +
  geom_vline(xintercept = 10000, color = "red", linetype = "dashed", size = 1) +
  labs(title = "Distribution of COVID-19 Deaths by Jurisdiction",
       subtitle = "Red dashed line = hypothesized mean (10,000 deaths)",
       x = "Number of Deaths", y = "Count of Jurisdictions") +
  theme_minimal()

# TEST 2: One-sample t-test on crude rate > 100
t_test_rate <- t.test(df_clean$crude_COVID_rate, mu = 100,
                      alternative = "greater")
print("One-Sample t-Test: crude_COVID_rate > 100")
print(t_test_rate)

# Visualization 2a
ggplot(df_clean, aes(x = crude_COVID_rate)) +
  geom_histogram(binwidth = 10, fill = "lightgreen",
                 color = "black", alpha = 0.7) +
  geom_vline(xintercept = 100, color = "blue", linetype = "dashed", size = 1) +
  labs(title = "Distribution of Crude COVID-19 Death Rates",
       subtitle = "Blue dashed line = test threshold (100/100,000)",
       x = "Crude Death Rate", y = "Count of Jurisdictions") +
  theme_minimal()

# Visualization 2b — Boxplot
ggplot(df_clean, aes(y = crude_COVID_rate)) +
  geom_boxplot(fill = "lightgreen") +
  geom_hline(yintercept = 100, color = "blue", linetype = "dashed", size = 1) +
  labs(title = "Boxplot of Crude COVID-19 Death Rates",
       y = "Crude Death Rate") +
  theme_minimal()

# TEST 3: Proportion test
threshold <- 200
n_total <- length(df_clean$crude_COVID_rate)
n_high  <- sum(df_clean$crude_COVID_rate > threshold)

prop_test <- prop.test(x = n_high, n = n_total,
                       p = 0.5, alternative = "less")
print("Proportion Test: Is proportion < 50%?")
print(prop_test)

# Visualization 3
df_clean <- df_clean %>%
  mutate(high_death_label = ifelse(crude_COVID_rate > threshold,
                                    paste("Above", threshold),
                                    paste(threshold, "or Below")))

prop_data <- df_clean %>%
  count(high_death_label) %>%
  mutate(proportion = n / sum(n))

ggplot(prop_data, aes(x = high_death_label, y = proportion,
                      fill = high_death_label)) +
  geom_bar(stat = "identity", color = "black") +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(title = "Proportion of Jurisdictions by Crude Death Rate Category",
       x = "Crude Death Rate Category",
       y = "Percentage of Jurisdictions") +
  theme_minimal() + theme(legend.position = "none")
```

---

## 9. References

- U.S. Department of Health and Human Services. (n.d.). *Provisional COVID-19 death counts, rates, and percent of total deaths by jurisdiction of residence*. data.gov. https://catalog.data.gov/dataset/provisional-covid-19-death-counts-rates-and-percent-of-total-deaths-by-jurisdiction-of-res
- CDC. (2024). *About multiple cause of death, 1999-2020*. CDC WONDER. https://wonder.cdc.gov/
- Aitchison, J., & Brown, J. A. C. (1957). *The lognormal distribution*. Cambridge University Press. *(rationale for log-transform on right-skewed rates)*
- R Core Team. (2024). *R: A language and environment for statistical computing*. https://www.R-project.org/

---

<div align="center">

[← Module 2](Module2_DescriptiveStatistics.md) &nbsp;•&nbsp; [Back to Portfolio](README.md) &nbsp;•&nbsp; [Next: Module 4 →](Module4_TwoSampleTests.md)

</div>
