# Project 6 — Probability Distributions with R

A compact, reproducible analysis of **binomial**, **Poisson**, and **normal** probability models applied to:  
- MLB playoff outcomes (7-game series)  
- Call-center load and staffing  
- Light-bulb lifespans and quality thresholds  
- Bonus: quick EDA on the **Palmer Penguins** dataset

> Course: **ALY6000 — Introduction to Analytics** • Author: **Sri Ram Prabu** • Date: **Feb 14, 2025**

---

## Table of Contents
- [Overview](#overview)  
- [Key Results](#key-results)  
- [Repo Structure](#repo-structure)  
- [Getting Started](#getting-started)  
- [Reproduce the Analysis](#reproduce-the-analysis)  
- [Outputs](#outputs)  
- [Notes & Assumptions](#notes--assumptions)  
- [References](#references)  
- [License](#license)

---

## Overview
This project demonstrates how to turn domain questions into solvable probability problems using **R**. It walks through:
- **Binomial** modeling of series wins (e.g., Red Sox in a best-of-7)
- **Poisson** modeling of hourly/shift call volumes for staffing decisions
- **Normal** modeling of product reliability (lifespan thresholds, yield)
- A light **EDA** on Palmer Penguins (normality checks, simple correlation)

The report provides probabilities, expected values, variances, simulations, and practical interpretations for each scenario.

---

## Key Results
- **Baseball (Binomial)**  
  - P(exactly 5 wins in 7): **0.298**  
  - P(fewer than 5 wins): **0.468**  
  - P(3–5 wins inclusive): **0.711**  
  - P(>4 wins): **0.532**  
  - Theoretical **E[wins] ≈ 4.55**, **Var[wins]** consistent with binomial; simulation (n=1,000) aligns.

- **Call Center (Poisson)**  
  - P(exactly 6 calls/hour): **0.149**  
  - P(≤40 calls in 8 hours for one employee): **0.0155**  
  - P(quota ≥275 in 8h): **0.625** for **5** employees; **0.00054** for **4** employees  
  - 90th-percentile day for one employee (8h): **≥66 calls**

- **Light Bulbs (Normal)**  
  - P(1,800–2,200 hours): **0.954**  
  - P(>2,500 hours): **2.87×10⁻⁷**  
  - Bottom 10% (defective threshold): **≤1,872 hours**  
  - Simulated population (n=10,000) mean ≈ **2,000** hours as expected

- **Penguins EDA**  
  - Adélie flipper length ~ **normal** (histogram + Shapiro-Wilk)  
  - Gentoo: **positive correlation** between flipper length and beak depth

> See the full write-up in `report/Elenchezhain_Project6_Report.pdf` for methods, formulas, and interpretation.

---

## Repo Structure
```
.
├─ README.md                # You are here
├─ report/                  # PDF or RMarkdown report(s)
│  └─ Elenchezhain_Project6_Report.pdf
├─ R/                       # R scripts (install, simulate, plot)
│  ├─ 00_setup.R
│  ├─ 10_binomial_series.R
│  ├─ 20_poisson_callcenter.R
│  ├─ 30_normal_lifespans.R
│  └─ 40_penguins_eda.R
├─ data/                    # External/public data (e.g., palmerpenguins)
└─ outputs/                 # Tables, figures, simulated datasets
```

> If your local layout differs, adjust paths in the code snippets below.

---

## Getting Started

### Prerequisites
- **R ≥ 4.2**
- Recommended IDE: **RStudio**

### Install Packages
```r
# Run once
install.packages(c("tidyverse", "palmerpenguins"))
```

---

## Reproduce the Analysis

### 1) Setup (shared helpers, options)
```r
source("R/00_setup.R")   # optional: themes, options, helper funcs
```

### 2) Binomial — MLB Series
```r
source("R/10_binomial_series.R")
# Produces probabilities, EV/Var, a 1,000-series simulation, and summary table(s)
```

### 3) Poisson — Call Center
```r
source("R/20_poisson_callcenter.R")
# Hourly/shift probabilities, staffing quota probabilities, percentile threshold
```

### 4) Normal — Lifespans
```r
source("R/30_normal_lifespans.R")
# Interval probabilities, extreme-tail calc, 10,000-pop simulation, sampling dist
```

### 5) Penguins EDA
```r
source("R/40_penguins_eda.R")
# Normality check (Adélie), correlation (Gentoo), and simple visualizations
```

> All scripts are designed to write tables/figures into `outputs/`.  
> If you prefer a single run, create an orchestrator script to `source()` them in order.

---

## Outputs
- **Tables**: probability summaries for each scenario  
- **Figures**:  
  - X-bar style/series histograms (simulation)  
  - Sampling distribution of means (n=100, 1,000 samples)  
  - Penguins histograms and scatterplots
- **Report**: PDF in `report/` with consolidated interpretation and recommendations

---

## Notes & Assumptions
- Baseball series modeled as **Binomial(n=7, p)** with independence and constant win probability across games.  
- Call volumes: **Poisson(λ)** assumptions (independent arrivals, stationary rate) by hour; shift totals via additivity.  
- Lifespans: **Normal(μ=2000, σ=100)** per spec; quality threshold = lower 10th percentile.  
- Penguins: lightweight EDA; normality via histogram + Shapiro-Wilk; simple Pearson correlation for linear trend.

---

## References
- **Course Report**: `report/Elenchezhain_Project6_Report.pdf` (methods, results, interpretation)  
- R Documentation: https://cran.r-project.org/manuals.html  
- **Palmer Penguins**: https://allisonhorst.github.io/palmerpenguins/  
- Casella, G. & Berger, R. L. (2002). *Statistical Inference* (2nd ed.).  
- Ross, S. M. (2019). *Introduction to Probability and Statistics for Engineers and Scientists* (6th ed.).  
- Wickham, H. & Grolemund, H. (2017). *R for Data Science*.  
- Moore, D. S., McCabe, G. P., & Craig, B. A. (2017). *Introduction to the Practice of Statistics* (9th ed.).

---

## License
This project is released under the **MIT License**. See `LICENSE` for details.

---

### How to use this README
- **Drop it** at your repo root as `README.md`.  
- **Adjust paths** in code blocks to match your folder structure.  
- **Swap in** your actual script names if they differ.  
- **Push!** Your repo now has a clear, reproducible entry point.
