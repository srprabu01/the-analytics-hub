<div align="center">

# Module 5 — Correlation & Regression Analysis

### *Socio-Economic Predictors of Maternal Mortality: From Correlation to Multivariable Regression*

[![Module](https://img.shields.io/badge/Module-5-1a3a6e?style=for-the-badge)](#)
[![Course](https://img.shields.io/badge/Course-ALY6010-2b6cb0?style=for-the-badge)](#)
[![Topic](https://img.shields.io/badge/Topic-Correlation%20%26%20Regression-success?style=for-the-badge)](#)
[![Dataset](https://img.shields.io/badge/Dataset-World%20Bank%20WDI%202017-orange?style=for-the-badge)](#)

</div>

---

> [!NOTE]
> **Module 5 takes the leap from comparing means to modeling relationships.**
> Correlation tells us the *strength and direction* of linear association.
> Regression tells us *how much* one variable moves when another changes,
> controlling for other factors simultaneously. Together, they form the
> backbone of empirical social and biomedical research.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Dataset & Methodology](#2-dataset--methodology)
3. [Exploratory Data Analysis](#3-exploratory-data-analysis)
4. [Part 1 — Correlation Analysis](#4-part-1--correlation-analysis)
5. [Part 2 — Regression Analysis](#5-part-2--regression-analysis)
6. [Regression Diagnostics](#6-regression-diagnostics)
7. [Discussion & Caveats](#7-discussion--caveats)
8. [R Script](#8-r-script)
9. [References](#9-references)

---

## 1. Introduction

The **Maternal Mortality Ratio (MMR)** — the number of maternal deaths per
100,000 live births — is a critical indicator of a nation's health-system
quality, gender equality, and economic development. A high MMR signals
systemic challenges in delivering accessible, effective care to women.

This module uses **2017 World Bank data** to examine relationships between
MMR and three established socio-economic predictors:

- **National wealth** (GDP per capita)
- **Public health investment** (health expenditure per capita)
- **Demographic patterns** (fertility rate)

> [!IMPORTANT]
> **Why these specific predictors?** They mirror the UN Maternal Mortality
> Estimation Inter-Agency Group's (MMEIG) own BMat Bayesian estimation model,
> which uses GDP, general fertility rate, and skilled birth attendant
> coverage to estimate MMR for country-years missing direct data. By
> replicating this predictor set, we connect our analysis to the global
> reference standard.

**Three-stage analysis:**

1. **EDA** — distributions and bivariate visualizations
2. **Correlation** — `corrplot` chart of pairwise associations
3. **OLS multiple regression** — quantifying the joint effect of predictors

---

## 2. Dataset & Methodology

### 2.1 Data Source

The dataset was compiled using the **WDI** R package to query World Bank
indicators for **2017** — the latest year with complete coverage across all
four indicators. After dropping rows with missing data, **n = 139 countries**
remained.

### 2.2 Variables

| Indicator | Role | Description |
|:----------|:-----|:------------|
| **Maternal Mortality Ratio (MMR)** | Outcome | Maternal deaths per 100,000 live births |
| Fertility Rate | Predictor | Total births per woman |
| GDP per Capita (USD) | Predictor | National wealth |
| Health Expenditure per Capita (USD) | Predictor | Healthcare investment |

### 2.3 Methodology — Why Log-Transform?

All four variables are heavily right-skewed (see Figure 1 below). OLS
regression assumes residuals are approximately normal — skewed predictors
violate this. Two solutions:

1. **Log-transform** all variables → restores approximate normality
2. **Interpret coefficients as elasticities** — a 1% change in X
   associates with a β% change in Y

> [!TIP]
> The log-log specification is standard in development economics. It is
> the form used by Romer, Solow, and countless growth-model papers because
> elasticities are easier to interpret and compare across variables of
> wildly different scales (GDP in thousands of USD vs. fertility in 1–7
> births per woman).

---

## 3. Exploratory Data Analysis

### Figure 1 — Distribution of Key Indicators

![Distributions](images/m5_fig1_distributions.png)

All four variables are **heavily right-skewed**:

- **MMR:** most countries cluster below 50, a long tail extends past 1,000
- **Fertility:** most clustered at 1.5–3.0, a tail reaches 7+
- **GDP per capita:** most below $20k, a few wealthy nations at $80k+
- **Health expenditure:** similar pattern, even more extreme

This visual evidence **strongly justifies the log transformation** for
subsequent modeling.

### Figure 2 — MMR vs. GDP per Capita (Log-Log Scale)

![MMR vs GDP](images/m5_fig2_mmr_gdp.png)

A clear **negative association**: wealthier countries have lower maternal
mortality. The dashed OLS line on the log-log scale captures this with
slope ≈ −0.45 (the bivariate elasticity). Sub-Saharan African countries
cluster at high MMR + low GDP; European countries cluster at low MMR +
high GDP — exactly the development gradient.

### Figure 3 — MMR vs. Fertility Rate (Log-Log Scale)

![MMR vs Fertility](images/m5_fig3_mmr_fertility.png)

A **strong positive association**: countries with higher fertility rates
have higher maternal mortality. The log-log correlation is r ≈ +0.64, and
the upward slope is unmistakable. This reflects multiple intertwined
mechanisms — more pregnancies per woman, less access to family planning,
younger mean age at first birth, and the demographic conditions that
correlate with poverty.

---

## 4. Part 1 — Correlation Analysis

### Figure 4 — Correlation Matrix of Development Indicators

![Correlation matrix](images/m5_fig4_corr.png)

### Key Analytical Findings

| Pair | Correlation | Interpretation |
|:-----|:-----------:|:---------------|
| 🟢 log(MMR) ↔ log(Fertility) | **+0.64** | Strong positive — highest correlation with MMR |
| 🔵 log(MMR) ↔ log(GDP) | **−0.45** | Moderate negative — wealth lowers MMR |
| 🔵 log(MMR) ↔ log(Health Exp.) | **−0.36** | Weaker negative — direct spending alone less explanatory |
| 🟠 log(GDP) ↔ log(Health Exp.) | **+0.91** | **Multicollinearity alert** — wealthier nations spend more on health |

> [!CAUTION]
> The **+0.91 correlation between GDP and Health Expenditure** is the
> single most important diagnostic. When two predictors correlate this
> strongly, including both in a regression produces **inflated standard
> errors** and unstable coefficients — a problem called *multicollinearity*.
> This shows up in the regression results below.

### Why Limit Correlation Charts to ≤ 5 Variables?

> [!IMPORTANT]
> **Assignment Question:** *"A correlation chart is diagnostic and should
> not be larger than 5 variables for reporting purposes. Why?"*

Three reasons:

1. **Readability** — the matrix grows quadratically. A 10-variable matrix has
   45 unique cells; visual interpretation breaks down.
2. **Cognitive overload** — diagnostic tools are for *rapid* visual
   interpretation. Beyond ~5 variables, the reader's attention fragments.
3. **Multiple comparisons** — with k variables, you produce k(k−1)/2
   correlations. At k = 20, that's 190 tests; some "significant" results
   will appear by chance alone (the **multiple testing problem**).

---

## 5. Part 2 — Regression Analysis

### How Regression Differs from Correlation

> [!IMPORTANT]
> **Assignment Question:** *"How does regression analysis differ from
> correlation analysis?"*

| Aspect | Correlation | Regression |
|:-------|:------------|:-----------|
| **Symmetry** | Symmetric: cor(A,B) = cor(B,A) | Asymmetric: X predicts Y, not vice versa |
| **Variable roles** | Both treated equally | Designated outcome (Y) and predictors (X) |
| **Multivariable control** | No — pairwise only | Yes — isolates each predictor's unique effect |
| **Output** | Single coefficient (strength) | Coefficient + std error + p-value + CI |
| **Interpretation** | "A and B move together" | "A 1-unit rise in X is associated with β units in Y, holding other Xs constant" |

### The Model

```r
regression_model <- lm(
  log(`Maternal Mortality Ratio`) ~ log(`Fertility Rate`) +
                                    log(`Health Exp. (per Capita)`) +
                                    log(`GDP (per Capita)`),
  data = cleaned_data
)
summary(regression_model)
```

### Results Table (Stargazer-Formatted)

| Predictor | Coefficient (β) | Std. Error | p-value | Significance |
|:----------|:---------------:|:----------:|:-------:|:------------:|
| log(Fertility Rate) | **+1.09** | 0.16 | < 0.001 | *** |
| log(GDP per Capita) | **−0.25** | 0.10 | < 0.01 | ** |
| log(Health Exp.) | +0.06 | 0.13 | 0.65 | (n.s.) |
| Intercept | -0.15 | 0.59 | 0.81 | — |

**Model statistics:**

```
F-statistic ≈ 70 (p < 0.001)
R² = 0.609     Adjusted R² = 0.600
n = 139 countries
```

### Figure 6 — Coefficient Plot with 95% CIs

![Coefficient plot](images/m5_fig6_coefs.png)

The coefficient plot visualizes the table above. The 95% confidence intervals
for log(Fertility) and log(GDP) both **exclude zero** — these effects are
statistically significant. The log(Health Exp.) CI **crosses zero** — its
effect is not distinguishable from zero in this specification.

### Interpretation

> [!TIP]
> **Fertility is the dominant predictor.**

| Predictor | Elasticity | Plain English |
|:----------|:----------:|:--------------|
| Fertility Rate | +1.09 | A 1% rise in fertility associates with a **1.09% rise in MMR** (proportional response) |
| GDP per Capita | −0.25 | A 1% rise in GDP associates with a **0.25% fall in MMR** |
| Health Exp. | not sig. | Effect absorbed by GDP (multicollinearity) |

**Why health expenditure is non-significant:** Once GDP is in the model,
health spending no longer adds explanatory power — the +0.91 correlation
between GDP and health spending means they share most of the same
information. GDP is acting as a broader proxy for the resources,
infrastructure, and stability that drive better maternal outcomes,
**subsuming** the unique effect of health spending.

> [!NOTE]
> The model explains **~61% of the variation** in log(MMR) across countries
> (Adjusted R² = 0.600). This is strong explanatory power for cross-sectional
> social-science data.

---

## 6. Regression Diagnostics

### Figure 5 — Four-Panel Diagnostic Plot

![Diagnostic plots](images/m5_fig5_diagnostics.png)

| Panel | What it checks | Verdict |
|:------|:---------------|:--------|
| **Residuals vs Fitted** | Linearity & homoscedasticity | Random scatter around 0 ✓ |
| **Normal Q-Q** | Normality of residuals | Points fall close to diagonal ✓ |
| **Scale-Location** | Equal variance across fitted | Roughly constant spread ✓ |
| **Residuals vs Leverage** | Influential outliers | No extreme leverage points ✓ |

> [!TIP]
> All four assumptions are reasonably met. The log-log transformation
> successfully normalized the residuals — the original right-skewed data
> would have failed the normality and homoscedasticity checks.

---

## 7. Discussion & Caveats

### Important Limitations

> [!WARNING]
> Despite strong statistical results, the following limitations apply:

| Limitation | What it means |
|:-----------|:--------------|
| **Causality** | Cross-sectional design — strong associations, but **no causal claims**. Higher GDP is *associated* with lower MMR, but we cannot say increasing GDP *causes* MMR to fall. |
| **Omitted variables** | Female education, political stability, governance, and skilled-birth-attendant coverage are all known MMR predictors not in the model. Their effects may be partially absorbed by the included predictors. |
| **Data quality** | MMR is notoriously hard to measure in low-resource settings; deaths may go unrecorded. Measurement error reduces precision. |
| **Multicollinearity** | The +0.91 GDP ↔ Health Exp. correlation makes their individual effects difficult to separate. |
| **Heterogeneity** | A pooled model assumes the same elasticity applies to all countries. In reality, the GDP→MMR relationship may differ across development levels. |

### Policy Implications

Despite the caveats, the consistent direction and magnitude of effects (and
their alignment with the UN MMEIG's BMat model) support several
generally-accepted policy conclusions:

1. **Family planning investment is among the highest-leverage interventions.**
   The +1.09 fertility elasticity dwarfs the −0.25 GDP elasticity — meaning
   reductions in fertility have proportionally larger effects on MMR than
   equivalent GDP gains.
2. **Economic development matters** but is part of a complex bundle (health
   infrastructure, education, governance) that GDP alone proxies.
3. **Direct health spending appears non-significant in this specification**
   — not because it doesn't matter, but because GDP captures shared variance.

---

## 8. R Script

```r
library(tidyverse); library(WDI); library(corrplot); library(stargazer)
library(ggthemes)

# DATA ACQUISITION
indicators <- c(
  maternal_mortality   = "SH.STA.MMRT",
  fertility_rate       = "SP.DYN.TFRT.IN",
  health_exp_per_cap   = "SH.XPD.CHEX.PC.CD",
  gdp_per_capita       = "NY.GDP.PCAP.CD"
)

wdi_data <- WDI(country = "all", indicator = indicators,
                start = 2017, end = 2017, extra = TRUE)

# Clean and rename
cleaned_data <- wdi_data %>%
  filter(region != "Aggregates") %>%
  select(country, region, maternal_mortality, fertility_rate,
         health_exp_per_cap, gdp_per_capita) %>%
  na.omit() %>%
  rename(
    "Maternal Mortality Ratio" = maternal_mortality,
    "Fertility Rate"           = fertility_rate,
    "Health Exp. (per Capita)" = health_exp_per_cap,
    "GDP (per Capita)"         = gdp_per_capita
  )

# EDA — Distributions
cleaned_data %>%
  select(-country, -region) %>%
  pivot_longer(cols = everything(), names_to = "indicator",
               values_to = "value") %>%
  ggplot(aes(x = value)) +
  geom_histogram(aes(y = ..density..), bins = 20,
                 fill = "steelblue", alpha = 0.8) +
  geom_density(color = "red") +
  facet_wrap(~indicator, scales = "free") +
  labs(title = "Distributions of Key Development Indicators",
       subtitle = "All variables right-skewed — justifies log transformation") +
  theme_minimal()
ggsave("variable_distributions.png", width = 8, height = 6)

# Scatter plots
ggplot(cleaned_data, aes(x = `GDP (per Capita)`, y = `Maternal Mortality Ratio`)) +
  geom_point(aes(color = region), alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  scale_x_log10(labels = scales::dollar) + scale_y_log10() +
  labs(title = "Wealthier Countries Have Lower Maternal Mortality") +
  theme_minimal()
ggsave("scatter_mmr_vs_gdp.png", width = 8, height = 6)

# CORRELATION ANALYSIS
cor_matrix <- cor(cleaned_data %>% select(-country, -region))
png("correlation_chart.png", width = 800, height = 800, res = 100)
corrplot(cor_matrix, method = "color", type = "upper", order = "hclust",
         addCoef.col = "black", tl.col = "black", tl.srt = 45,
         diag = FALSE,
         title = "Correlation Matrix of Development Indicators (2017)",
         mar = c(0,0,1,0))
dev.off()

# REGRESSION
regression_model <- lm(
  log(`Maternal Mortality Ratio`) ~ log(`Fertility Rate`) +
                                     log(`Health Exp. (per Capita)`) +
                                     log(`GDP (per Capita)`),
  data = cleaned_data
)

# Diagnostics — 4-panel plot
png("regression_diagnostics.png", width = 1000, height = 1000, res = 120)
par(mfrow = c(2, 2)); plot(regression_model); par(mfrow = c(1, 1))
dev.off()

# Stargazer export
stargazer(regression_model, type = "html", out = "regression_table.html",
          title = "OLS Regression: Predictors of Maternal Mortality Ratio",
          dep.var.labels = "Log(Maternal Mortality Ratio)",
          covariate.labels = c("Log(Fertility Rate)",
                               "Log(Health Exp. per Capita)",
                               "Log(GDP per Capita)"),
          align = TRUE, ci = TRUE, p.auto = TRUE, report = "vcsp",
          notes = "Data source: World Bank (2017). N=139 countries.",
          notes.align = "l")
```

---

## 9. References

- The World Bank Group. (2024). *World development indicators*. https://databank.worldbank.org/source/world-development-indicators
- WHO, UNICEF, UNFPA, World Bank Group, & UN Population Division. (2019). *Trends in maternal mortality 2000 to 2017*. https://www.who.int/publications/i/item/9789241516488
- Arel-Bundock, V. (2021). *WDI: World Bank development indicators* [R package]. https://github.com/vincentarelbundock/WDI
- Wei, T., & Simko, V. (2021). *corrplot: Visualization of a correlation matrix*. https://github.com/taiyun/corrplot
- Hlavac, M. (2022). *stargazer: Well-formatted regression and summary statistics tables*. https://CRAN.R-project.org/package=stargazer
- Wooldridge, J. M. (2019). *Introductory econometrics: A modern approach* (7th ed.). Cengage. *(rationale for log-log elasticity)*
- Delacre, M., Lakens, D., & Leys, C. (2017). Why psychologists should by default use Welch's t-test instead of Student's t-test. *International Review of Social Psychology, 30*(1), 92–101.

---

<div align="center">

[← Module 4](Module4_TwoSampleTests.md) &nbsp;•&nbsp; [Back to Portfolio](README.md) &nbsp;•&nbsp; [Next: Module 6 →](Module6_DummyVariables.md)

</div>
