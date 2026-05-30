# 🎮 Online Gaming Behavior — Final Project

> **A complete statistical analytics study of 40,034 online gamers — from exploratory data analysis through formal hypothesis testing to predictive modeling and player segmentation. Built end-to-end in R.**

![R](https://img.shields.io/badge/R-4.3.2-276DC3?logo=r&logoColor=white)
![ggplot2](https://img.shields.io/badge/viz-ggplot2-orange)
![Status](https://img.shields.io/badge/status-complete-brightgreen)
![Course](https://img.shields.io/badge/ALY6010-Probability%20%26%20Statistics-blue)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Business Motivation](#-business-motivation)
3. [Dataset](#-dataset)
4. [Repository Structure](#-repository-structure)
5. [Methodology](#-methodology)
6. [Milestone 1 — Exploratory Data Analysis](#-milestone-1--exploratory-data-analysis)
7. [Milestone 2 — Inferential Statistics](#-milestone-2--inferential-statistics)
8. [Milestone 3 — Advanced Modeling](#-milestone-3--advanced-modeling)
9. [Consolidated Findings](#-consolidated-findings)
10. [Business Recommendations](#-business-recommendations)
11. [Limitations & Honest Caveats](#-limitations--honest-caveats)
12. [Tech Stack & Reproducibility](#-tech-stack--reproducibility)
13. [Future Work](#-future-work)
14. [Author & References](#-author--references)

---

## 📌 Project Overview

This final project investigates **what drives player behavior in an online gaming environment** — engagement, playtime, spending, and segmentation. Built around the Online Gaming Behavior dataset (40,034 players × 13 variables), it is structured as three connected milestones that move progressively from description to inference to prediction:

| Milestone | Goal | Techniques |
|-----------|------|------------|
| **1 — EDA** | Profile the data and surface initial patterns | Descriptive stats, histograms, boxplots, scatterplots |
| **2 — Inferential Statistics** | Validate the EDA patterns with formal tests | One-sample *t*-test, two-sample *t*-test, chi-square test |
| **3 — Advanced Modeling** | Build models that predict and segment players | Logistic regression, two-way ANOVA, multinomial regression, K-means, multiple linear regression |

Each milestone is documented in its own report, supported by an R script, and culminates in a presentation slide deck.

---

## 💡 Business Motivation

In a freemium gaming economy, three commercial questions dominate:

1. **Who spends money?** — what behavioral and demographic signals predict in-game purchases?
2. **What keeps players engaged?** — which design factors (genre, difficulty, progression) drive playtime?
3. **Who are our players, really?** — can the player base be segmented into actionable archetypes?

This project answers each through formal statistical methods rather than intuition, providing a data-driven foundation for monetization, content design, and retention strategy.

---

## 📊 Dataset

**File:** `online_gaming_behavior_dataset.csv`
**Records:** 40,034 players × 13 variables
**Source:** [Kaggle — Player Engagement Analysis](https://www.kaggle.com/code/sulaniishara/player-engagement-analysis-prediction/notebook)

| Field | Type | Description | Range |
|-------|------|-------------|-------|
| `PlayerID` | Integer | Unique identifier | 1–40,034 |
| `Age` | Integer | Player age | 15–49 |
| `Gender` | Categorical | Male / Female | — |
| `Location` | Categorical | USA / Europe / Asia / Other | — |
| `GameGenre` | Categorical | Action / RPG / Simulation / Sports / Strategy | — |
| `PlayTimeHours` | Numeric | Avg daily hours played | 0.0001–23.9996 |
| `InGamePurchases` | Binary | 1 = purchaser, 0 = non-purchaser | 0/1 |
| `GameDifficulty` | Categorical | Easy / Medium / Hard | — |
| `SessionsPerWeek` | Numeric | Weekly gameplay sessions | 0–19 |
| `AvgSessionDurationMinutes` | Numeric | Mean session length (minutes) | 10–179 |
| `PlayerLevel` | Numeric | Current in-game level | 1–99 |
| `AchievementsUnlocked` | Numeric | Total achievements earned | 0–49 |
| `EngagementLevel` | Categorical | Composite: Low / Medium / High | — |

### Data Quality
- ✅ **No missing values** across any field
- ✅ **No duplicate `PlayerID`s**
- ✅ **No out-of-range values** (no negative ages, impossible playtimes, etc.)
- ✅ **All categorical fields well-formed** (no unexpected levels)

### Cleaning Decisions
Players with `PlayTimeHours < 1` **or** `SessionsPerWeek < 1` were filtered out as inactive/newly-registered accounts. This leaves **32,235 active players (~80.5%)** that form the basis of all downstream analysis.

A derived feature, **`AgeGroup`**, was engineered by binning `Age` into four life stages: `15–24`, `25–34`, `35–44`, `45–49` — enabling demographic comparisons.

---

## 📁 Repository Structure

```
.
├── online_gaming_behavior_dataset.csv     # Raw dataset (40,034 rows)
│
├── R_Script-1.R                           # Milestone 1: EDA + visualizations
├── R_Script-6.R                           # Milestone 2: hypothesis tests
├── R_Script-c2b60572-...R                 # Milestone 3: advanced modeling
│
├── EDA_Report.pdf                         # Milestone 1 report (full EDA write-up)
├── R_Report-1.pdf                         # Milestone 2 report (hypothesis testing)
├── Final_Project_Report.pdf               # Milestone 3 report (modeling + conclusions)
├── Final_Project_slide_deck.html          # Presentation deck for stakeholders
│
└── README.md                              # This file
```

> 💡 **Naming tip:** the modeling script's UUID-style filename is hard to reference. Renaming it to `R_Script-modeling.R` (and updating any `source()` calls) is recommended.

---

## 🔬 Methodology

A consistent analytical workflow runs through all three milestones:

1. **Load & filter** — read the CSV, restrict to active players, engineer features.
2. **Frame** — state a research question, link it to the EDA, declare hypotheses.
3. **Test/Model** — apply the appropriate statistical method at α = 0.05.
4. **Visualize** — produce a chart that makes the result readable at a glance.
5. **Interpret** — translate the statistical result into a business insight.

This structure makes results easy to audit and explain to non-technical stakeholders.

---

## 📈 Milestone 1 — Exploratory Data Analysis

**Script:** `R_Script-1.R` · **Report:** `EDA_Report.pdf`

### Descriptive Statistics (active players, n = 32,235)

| Variable | Mean | Median | SD | IQR |
|----------|------|--------|----|----|
| Age | 32.29 | 32 | 9.97 | 23–41 |
| PlayTimeHours | 12.20 | 12.15 | 6.74 | 6.38–17.95 |
| SessionsPerWeek | 10.02 | 10 | 5.61 | 5–14 |
| AvgSessionDurationMinutes | 96.41 | 96 | 48.91 | 54–138 |
| PlayerLevel | 50.42 | 50 | 28.26 | 25–74 |
| AchievementsUnlocked | 25.02 | 25 | 14.19 | 12–37 |
| InGamePurchases (rate) | 23.4% | — | — | — |

### Categorical Distributions
- **Gender:** 60.5% Male, 39.5% Female
- **Location:** USA 39.8%, Europe 19.9%, Asia 19.9%, Other 20.3%
- **GameGenre:** evenly distributed (~20% each across Action / RPG / Simulation / Sports / Strategy)
- **GameDifficulty:** Easy 49.7%, Medium 35.0%, Hard 15.5%
- **EngagementLevel:** Low 26.2%, Medium 47.7%, High 26.2%

### Ten Visualizations Produced
Age histogram & boxplot · Daily playtime histogram & boxplot · Weekly sessions histogram & boxplot · Sessions vs. PlayTime scatterplot · PlayerLevel vs. Achievements scatterplot · Playtime by EngagementLevel boxplot · Players per genre bar chart.

### Key EDA Takeaways
- **Median daily playtime ≈ 12.15 hours** — a heavily engaged player base.
- **Strong positive correlation between sessions/week and daily hours** (regression slope ≈ 1.16) — players spread playtime across sessions rather than marathon-ing.
- **RPG players have the highest in-game purchase rate (24.0%)**; Strategy the lowest (18.0%).
- **Middle-aged adults (25–44) log the most playtime**.
- **EngagementLevel categories show similar median playtimes** — suggesting "engagement" captures more than just hours played (e.g., recency, spending).

---

## 🧪 Milestone 2 — Inferential Statistics

**Script:** `R_Script-6.R` · **Report:** `R_Report-1.pdf`

Three EDA observations were formalized into testable hypotheses at α = 0.05:

### Test 1 — One-Sample *t*-Test: Is mean daily playtime > 10 hours?

- **H₀:** μ = 10 · **Hₐ:** μ > 10 (one-tailed)
- **Sample mean:** 12.21 hours · **t = 58.26** · ***p* < 2.2e-16**
- **→ Reject H₀.** The player base is significantly more engaged than the 10-hour benchmark.

### Test 2 — Chi-Square Test: Do RPG and Strategy players differ in purchase rate?

- **H₀:** purchase rate is independent of genre · **Hₐ:** they're associated
- **Purchase rates:** RPG 25.3% vs. Strategy 18.1% · **χ² = 99.39, df = 1** · ***p* ≈ 2.07e-23**
- **→ Reject H₀.** Genre is significantly associated with purchasing behavior; RPG players spend more.

### Test 3 — Two-Sample *t*-Test: Do 25–34 yr-olds play more than 15–24 yr-olds?

- **H₀:** μ₁₅₋₂₄ = μ₂₅₋₃₄ · **Hₐ:** μ₁₅₋₂₄ < μ₂₅₋₃₄ (one-tailed)
- **Group means:** 11.53 vs. 12.25 hours · **t = -7.06** · ***p* ≈ 8.8e-13**
- **→ Reject H₀.** 25–34 year-olds play significantly more per day than 15–24 year-olds.

> ⚠️ **Honest disclosure:** `R_Script-6.R` performs these tests on a **simulated dataset** (`df_simulated`) generated via `rnorm()` / `rbinom()` from the EDA's summary statistics, *not* on the raw CSV. This faithfully reproduces the population parameters from Milestone 1, but the simulation does not preserve the original joint structure between variables. Results should be read as validating the patterns surfaced in the EDA, not as independent confirmation from raw observations.

---

## 🤖 Milestone 3 — Advanced Modeling

**Script:** `R_Script-c2b60572-...R` · **Report:** `Final_Project_Report.pdf`

Five analyses build a multi-angle view of player behavior:

### Analysis 1 — Logistic Regression: Predicting In-Game Purchases
- **Model:** `glm(InGamePurchases ~ Age + Gender + PlayTimeHours + SessionsPerWeek + GameGenre + EngagementLevel, family = "binomial")`
- **Key results:** `GameGenreStrategy` (β = +0.122, *p* = 0.003 **) and `GenderMale` (β = +0.054, *p* = 0.044 *) emerge as significant predictors.
- **Insight:** monetization potential is not uniform — genre and gender shift purchase odds in measurable ways.

### Analysis 2 — Two-Way ANOVA: Genre × Difficulty on Playtime
- **Model:** `aov(PlayTimeHours ~ GameGenre * GameDifficulty)`
- **Result:** none of the main effects nor the interaction reached significance at α = 0.05 (genre *p* = 0.154, difficulty *p* = 0.327, interaction *p* = 0.577).
- **Insight:** in this dataset, mean playtime is roughly stable across genre/difficulty combinations — useful as a negative finding for design teams considering aggressive difficulty tuning.

### Analysis 3 — Multinomial Regression: Predicting Engagement Level
- **Model:** `multinom(EngagementLevel ~ PlayTimeHours + SessionsPerWeek + InGamePurchases + AvgSessionDurationMinutes + AchievementsUnlocked)`
- **Result:** all behavioral predictors statistically significant (*p* < 0.001). **SessionsPerWeek** and **PlayTimeHours** are the strongest drivers of High engagement vs. Low.
- **Insight:** engagement is predictable from behavior — and session frequency matters more than session length.

### Analysis 4 — K-Means Clustering: Player Archetypes
- **Variables (scaled):** PlayTimeHours, SessionsPerWeek, AvgSessionDurationMinutes, PlayerLevel, AchievementsUnlocked. **k = 3**.
- **Result:** three player archetypes emerge:
  - **Casuals** — low playtime, low sessions, low achievements
  - **Dedicated Grinders** — high playtime, high achievements, moderate sessions
  - **Frequent Socializers** — very high sessions, moderate playtime per session
- **Insight:** the player base is heterogeneous — different segments warrant different retention strategies.

### Analysis 5 — Multiple Linear Regression: Predicting PlayTime
- **Model:** `lm(PlayTimeHours ~ SessionsPerWeek + PlayerLevel + AchievementsUnlocked)`
- **Result (from script output):** F(3, 36471) = 1.084, *p* = 0.355, Adjusted R² ≈ 6.9e-6 — **the model does not significantly predict playtime**.
- **Insight:** within active players, raw progression metrics alone are weak linear predictors of total hours. This pushes future modeling toward interactions, polynomial terms, or behavioral features (e.g., session recency, social play).

---

## 🎯 Consolidated Findings

1. **The player base is highly engaged.** Average daily playtime (12.2 hrs) significantly exceeds the 10-hour benchmark.
2. **Genre drives spending.** RPG players are significantly more likely to make in-game purchases than Strategy players (25.3% vs. 18.1%).
3. **Age matters for engagement.** Players aged 25–34 play significantly more daily than 15–24 year-olds.
4. **Engagement is multidimensional.** Median playtime is similar across Low/Medium/High engagement tiers — engagement reflects session frequency, purchases, and recency, not just hours.
5. **Players segment into distinct archetypes.** K-means cleanly separates Casuals, Grinders, and Socializers — supporting personalized strategies.
6. **Difficulty × Genre is not a strong design lever** (in this dataset) — average playtime is stable across the combinations tested.

---

## 💼 Business Recommendations

| Domain | Recommendation |
|--------|----------------|
| **Monetization** | Prioritize RPG-tailored offers and bundles; design alternative engagement incentives (cosmetics, seasonal events) for lower-converting genres like Strategy. |
| **Retention** | Tailor campaigns by age: gamified social features for 15–24, deeper progression and competitive content for 25–44. |
| **Engagement Metrics** | Redefine `EngagementLevel` to combine playtime *and* purchase frequency *and* session recency — not just playtime. |
| **Player Experience** | Use the K-means archetypes for personalized onboarding, push notifications, and content recommendations. |
| **Churn Prevention** | Flag players whose session frequency declines as at-risk, given the tight session-hours coupling. |

---

## ⚠️ Limitations & Honest Caveats

- **Cross-sectional data.** No time component → no churn modeling, no causal inference. All findings are associations.
- **Milestone 2 uses simulated data.** Tests reproduce EDA parameters but not the raw data's joint structure (see disclosure above).
- **Linear regression for playtime fit poorly.** Adjusted R² near zero — playtime within active players is not well-explained by a linear combination of progression metrics alone.
- **K-means cluster count (k=3) was set heuristically.** An elbow plot or silhouette analysis would strengthen the segmentation.
- **No train/test split or cross-validation.** Models are descriptive of this dataset, not validated as predictive on unseen data.
- **`EngagementLevel` is a pre-computed composite** — its construction is opaque, which affects interpretability of the multinomial model.

---

## 🛠️ Tech Stack & Reproducibility

### Software
- **R** 4.3.2 — R Foundation for Statistical Computing

### Packages
| Package | Use |
|---------|-----|
| `dplyr`, `readr` | Data wrangling |
| `ggplot2`, `scales`, `ggpubr` | Visualization |
| `nnet` | Multinomial logistic regression |
| `cluster` | K-means clustering support |

### Run the Project

```r
# Install dependencies
install.packages(c("dplyr", "readr", "ggplot2", "scales", "nnet", "cluster", "ggpubr"))

# Run from the repo root (scripts expect the CSV in the working directory)
source("R_Script-1.R")                                    # Milestone 1: EDA + plots
source("R_Script-6.R")                                    # Milestone 2: Hypothesis tests
source("R_Script-c2b60572-4e0e-41c2-b4a8-d6c812f544bd.R") # Milestone 3: Modeling
```

The modeling script writes a consolidated summary file `advanced_model_outputs.txt` to the working directory.

---

## 🚀 Future Work

- **Longitudinal data** to enable churn prediction and retention modeling.
- **Train/test split + cross-validation** to assess true predictive performance.
- **Hyperparameter tuning** for K-means (elbow, silhouette, gap statistic) and exploration of alternatives like DBSCAN or hierarchical clustering.
- **Feature engineering:** ratio features (e.g., achievements per level), interaction terms, polynomial transforms.
- **Alternative models:** random forests, gradient boosting (`xgboost`), or neural nets for in-game purchase prediction.
- **Re-derive `EngagementLevel`** transparently using behavioral inputs, then validate the new definition statistically.
- **Genre-specific deep dives** — within-genre analysis of difficulty, age, and spending patterns.

---

## 👤 Author & References

**Sri Ram Prabu E**
ALY6010 — Probability Theory and Introductory Statistics
Instructor: Tom Breur · Northeastern University

### References
- Ishara, S. (n.d.). *Player engagement analysis & prediction* [Kaggle notebook]. https://www.kaggle.com/code/sulaniishara/player-engagement-analysis-prediction
- R Core Team (2024). *R: A language and environment for statistical computing* (Version 4.3.2). https://www.R-project.org/
- Wickham, H. (2016). *ggplot2: Elegant graphics for data analysis*. Springer.
- Venables, W. N., & Ripley, B. D. (2002). *Modern applied statistics with S* (4th ed.). Springer.
- Kassambara, A. (2023). *ggpubr: 'ggplot2' based publication ready plots* (v0.6.0). https://CRAN.R-project.org/package=ggpubr
- Maechler, M., et al. (2023). *cluster: Cluster analysis basics and extensions* (v2.1.6). https://CRAN.R-project.org/package=cluster
- Ripley, B., & Venables, W. N. (2022). *nnet: Feed-forward neural networks and multinomial log-linear models* (v7.3-19). https://CRAN.R-project.org/package=nnet

---

## 📄 License

Released under the **MIT License** — free to learn from and build upon.
