<div align="center">

# Module 1 — Regression Diagnostics & Model Selection

### *Predicting Home Sale Prices in Ames, Iowa: From an Initial OLS Model to a Diagnostics-Corrected, All-Subsets Best Model*

[![Module](https://img.shields.io/badge/Module-1-1a3a6e?style=for-the-badge)](#)
[![Course](https://img.shields.io/badge/Course-ALY6015-2b6cb0?style=for-the-badge)](#)
[![Topic](https://img.shields.io/badge/Topic-Regression%20Diagnostics-success?style=for-the-badge)](#)
[![Dataset](https://img.shields.io/badge/Dataset-Ames%20Housing%20(2930%C3%9782)-orange?style=for-the-badge)](#)

</div>

---

> [!NOTE]
> **Module 1 moves from *fitting* a regression to *validating* one.** A model
> can be highly significant and still be invalid. This project fits an initial
> three-predictor OLS model for house sale price, runs a full battery of
> diagnostics (residual plots, VIF for multicollinearity, leverage/outliers),
> corrects the violations it finds, and finally uses **all-subsets regression**
> to search for a better model — then compares the two.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Dataset & Methodology](#2-dataset--methodology)
3. [Exploratory Data Analysis & Data Preparation](#3-exploratory-data-analysis--data-preparation)
4. [Correlation Analysis](#4-correlation-analysis)
5. [Investigating Relationships with Scatter Plots](#5-investigating-relationships-with-scatter-plots)
6. [Initial Multiple Regression Model](#6-initial-multiple-regression-model)
7. [Regression Diagnostics](#7-regression-diagnostics)
8. [Model Improvement](#8-model-improvement)
9. [Best Subsets Regression](#9-best-subsets-regression)
10. [Final Model Comparison](#10-final-model-comparison)
11. [Conclusion](#11-conclusion)
12. [R Script](#12-r-script)
13. [References](#13-references)

---

## 1. Introduction

Accurately predicting the **sale price** of residential property is a cornerstone
of real-estate analysis — useful to sellers, buyers, and lenders alike. The
**Ames Housing** dataset contains **2,930 observations** and **82 variables**
describing homes sold in Ames, Iowa between **2006 and 2010**, making it a rich
sandbox for multiple linear regression.

This project follows a deliberate, iterative workflow: exploratory analysis →
initial model → diagnostics → correction → automated model selection →
final comparison.

> [!IMPORTANT]
> **The central lesson of this module:** a statistically significant model is
> not necessarily a *valid* one. The initial model here has an Adjusted R² of
> 0.757 and p < 2.2e-16, yet its diagnostic plots reveal clear violations of the
> regression assumptions. Diagnostics — not the R² — decide whether a model can
> be trusted.

---

## 2. Dataset & Methodology

### 2.1 Data Source

| Property | Value |
|:---------|:------|
| **Source** | Ames, Iowa Assessor's Office (via Dean De Cock, Truman State University) |
| **Observations** | 2,930 residential sales |
| **Variables** | 82 (23 nominal, 23 ordinal, 14 discrete, 20 continuous, + 2 identifiers) |
| **Period** | 2006–2010 |
| **Target** | `SalePrice` (continuous, USD) |

Full variable definitions are in [`AmesHousingDataDocumentation.txt`](AmesHousingDataDocumentation.txt).

### 2.2 Analytical Workflow

1. Load data and run EDA / descriptive statistics
2. Impute missing numeric values with the column mean
3. Build a correlation matrix of numeric variables (`cor()` + `corrplot`)
4. Fit an initial OLS model on three continuous predictors
5. Run diagnostics: residual plots, **VIF**, outlier/leverage checks
6. Correct issues (log-transform + outlier removal)
7. Run **all-subsets regression** (`leaps::regsubsets`) to find the best model
8. Compare and recommend a preferred model

> [!TIP]
> Because R's `read.csv()` converts spaces in column names to dots, the raw
> header `Overall Qual` becomes `Overall.Qual`, `Gr Liv Area` becomes
> `Gr.Liv.Area`, and so on. All variable references in the code use the dotted
> form.

---

## 3. Exploratory Data Analysis & Data Preparation

The dataset mixes nominal, ordinal, discrete, and continuous variables. The
target, `SalePrice`, is **right-skewed**:

| Statistic | SalePrice |
|:----------|:---------:|
| Mean | **$180,796** |
| Median | **$160,000** |

The mean sitting well above the median is the signature of right-skew — a fact
that later justifies the log transformation.

**Missing-value imputation.** The analysis focuses on the numeric columns.
Every numeric column with missing values was imputed with its own **mean**. For
example, `Lot.Frontage` was filled with its mean of **69.05**. This is simple,
keeps every observation, and lets the correlation and regression steps proceed
without list-wise deletion.

---

## 4. Correlation Analysis

A correlation matrix of all numeric variables was computed with `cor()` and
visualized with the **`corrplot`** package (upper triangle, hierarchical
clustering order).

> [!NOTE]
> **How to read the plot:** colour hue and intensity encode the correlation
> coefficient. Deep blue = strong positive (→ +1), deep red = strong negative
> (→ −1), pale = near zero. *See Figure 1 in the [report](Regression%20Diagnostics%20with%20R%20-%20Report.pdf).*

The three strongest positive correlations with `SalePrice`:

| Rank | Variable | r | Meaning |
|:----:|:---------|:---:|:--------|
| 1 | **Overall.Qual** | **0.799** | Overall material & finish quality |
| 2 | **Gr.Liv.Area** | **0.706** | Above-grade living area (sq ft) |
| 3 | **Garage.Cars** | **0.647** | Garage capacity (cars) |

This confirms the intuitive result: **larger, higher-quality homes command
higher prices.**

---

## 5. Investigating Relationships with Scatter Plots

Three scatter plots were drawn against `SalePrice` — one each for the highest,
lowest, and ≈0.5 correlated predictor. *See Figure 2 in the [report](Regression%20Diagnostics%20with%20R%20-%20Report.pdf).*

| Predictor | r | Pattern |
|:----------|:---:|:--------|
| **Overall.Qual** (highest) | 0.799 | Clear positive, slightly discrete trend; variance in price grows at higher quality |
| **BsmtFin.SF.2** (lowest) | −0.006 | No discernible pattern — a random cloud; a poor standalone predictor |
| **Year.Remod.Add** (≈ mid) | 0.505 | Moderately positive but looser; newer/remodeled homes sell higher, with more scatter |

The contrast across the three plots is exactly what the correlation coefficients
predict — a tight trend at r ≈ 0.8, noise at r ≈ 0, and a loose trend at r ≈ 0.5.

---

## 6. Initial Multiple Regression Model

Guided by the correlations and domain knowledge, an initial model was fit on
three continuous predictors:

```r
initial_model <- lm(SalePrice ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF,
                    data = numeric_data)
```

**Model equation:**

```
SalePrice = -99,259.19 + 23,528.06 · Overall.Qual
                       +     55.48 · Gr.Liv.Area
                       +     57.06 · Total.Bsmt.SF
```

The model is highly significant (**p < 2.2e-16**) with **Adjusted R² = 0.757** —
about 75.7% of the variance in `SalePrice` explained.

### Coefficient Interpretation

| Term | Coefficient | Interpretation (holding others constant) |
|:-----|:-----------:|:-----------------------------------------|
| Intercept | −99,259.19 | Theoretical price at all-zero predictors — not practically meaningful |
| **Overall.Qual** | +23,528.06 | Each +1 quality point → **+$23,528** in predicted price |
| **Gr.Liv.Area** | +55.48 | Each +1 sq ft of living area → **+$55.48** |
| **Total.Bsmt.SF** | +57.06 | Each +1 sq ft of basement → **+$57.06** |

---

## 7. Regression Diagnostics

The four standard diagnostic plots from `plot(initial_model)` were examined.
*See Figure 3 in the [report](Regression%20Diagnostics%20with%20R%20-%20Report.pdf).*

| Panel | What it checks | Verdict |
|:------|:---------------|:--------|
| **Residuals vs Fitted** | Linearity & constant variance | ❌ Curved pattern + spread grows with fitted value → **heteroscedasticity** |
| **Normal Q-Q** | Normality of residuals | ❌ Heavy deviation at the tails → **non-normal residuals** |
| **Scale-Location** | Equal variance | ❌ Upward trend → confirms heteroscedasticity |
| **Residuals vs Leverage** | Influential points | ⚠️ Observations **2181** and **2182** flagged (high leverage + large residual) |

### Multicollinearity (VIF)

```r
vif(initial_model)
```

| Predictor | VIF |
|:----------|:---:|
| Overall.Qual | 1.76 |
| Gr.Liv.Area | 1.54 |
| Total.Bsmt.SF | 1.34 |

> [!TIP]
> All VIF values sit **far below the usual threshold of 5 (or 10)**, so
> multicollinearity is **not** a problem in this model. *Had it been an issue,
> remedies would include dropping one of the correlated predictors, combining
> them into an index, or using regularization (ridge/lasso).*

### Outliers

Observations **2181** and **2182** have exceptionally large living areas
(`Gr.Liv.Area` > 5,000 sq ft) but relatively low sale prices — atypical sales
that heavily influence the fit. The dataset documentation itself recommends
removing homes over 4,000 sq ft. These two were removed for a model intended
to represent *typical* sales.

---

## 8. Model Improvement

Two corrections were applied to address non-normality and heteroscedasticity:

1. **Log-transform** the response (`log(SalePrice)`) — standard for right-skewed
   financial data
2. **Remove** the two extreme outliers (2181, 2182)

```r
numeric_data_cleaned <- numeric_data[-c(2181, 2182), ]
improved_model <- lm(log(SalePrice) ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF,
                     data = numeric_data_cleaned)
```

| Model | Adjusted R² |
|:------|:-----------:|
| Initial (raw SalePrice) | 0.757 |
| **Improved (log + outliers removed)** | **0.846** |

The redrawn diagnostic plots are markedly better — the Residuals vs Fitted plot
loses most of its pattern and the Q-Q plot hugs the diagonal far more closely.
The transformation and outlier removal **worked**.

---

## 9. Best Subsets Regression

To search for a stronger predictor set, **all-subsets regression** was run with
`regsubsets()` from the **`leaps`** package over the top predictors most
correlated with `SalePrice` (`nvmax = 14`), ranking candidate models by
Adjusted R² and BIC.

The best model by Adjusted R² used **11 variables**:

```
log(SalePrice) ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF + Year.Built
               + BsmtFin.SF.1 + Year.Remod.Add + Garage.Cars + X1st.Flr.SF
               + Fireplaces + Full.Bath + TotRms.AbvGrd
```

This model achieved **Adjusted R² = 0.890** — a clear jump over both the initial
and the improved three-variable models.

---

## 10. Final Model Comparison

| | Improved Manual Model | 'Best' Subsets Model |
|:--|:--|:--|
| **Predictors** | 3 (log-transformed) | 11 (log-transformed) |
| **Adjusted R²** | 0.846 | **0.890** |
| **Character** | Simple, easy to interpret | More complex, higher accuracy |

> [!IMPORTANT]
> **Preferred model: the 11-variable best-subsets model.** For predictive
> accuracy, the **+4.4 percentage-point** gain in explained variance (84.6% →
> 89.0%) justifies the added complexity. *If simplicity and interpretability
> were the priority, the 3-variable model would be a strong, defensible choice —
> but in a predictive context, the more accurate model wins.*

---

## 11. Conclusion

This analysis built, diagnosed, and refined a multiple linear regression model
for Ames home prices. The initial model — though highly significant — violated
the normality and homoscedasticity assumptions. Diagnostics surfaced those
problems; a **log transformation** plus **removal of two extreme outliers** fixed
them and lifted Adjusted R² from 0.757 to 0.846. An **all-subsets search** then
found an 11-variable model reaching 0.890, confirming that sale price is driven
by a *bundle* of factors — quality, size (living area, basement, garage), age and
remodeling, and features like fireplaces and bathrooms.

> [!NOTE]
> **Key takeaway:** regression modeling is iterative. A significant model is not
> automatically a valid one — a disciplined diagnostic pass is what turns a
> plausible fit into a trustworthy one.

---

## 12. R Script

The complete, runnable script lives in [`R Script.R`](R%20Script.R). Core steps:

```r
library(corrplot); library(ggplot2); library(leaps); library(car)

# Load & prepare
ames_data <- read.csv("AmesHousing.csv")
numeric_data <- ames_data[, sapply(ames_data, is.numeric)]
for (col in seq_len(ncol(numeric_data))) {          # mean-impute numeric NAs
  if (any(is.na(numeric_data[, col]))) {
    m <- mean(numeric_data[, col], na.rm = TRUE)
    numeric_data[is.na(numeric_data[, col]), col] <- m
  }
}

# Correlation matrix
cor_matrix <- cor(numeric_data)
sale_price_cor <- cor_matrix["SalePrice", ]
corrplot(cor_matrix, method = "color", type = "upper", order = "hclust",
         tl.col = "black", tl.srt = 45, tl.cex = 0.6, mar = c(0, 0, 1, 0))

# Initial model + diagnostics
initial_model <- lm(SalePrice ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF,
                    data = numeric_data)
par(mfrow = c(2, 2)); plot(initial_model); par(mfrow = c(1, 1))
vif(initial_model)                                  # multicollinearity check

# Improve: log-transform + drop outliers 2181, 2182
numeric_data_cleaned <- numeric_data[-c(2181, 2182), ]
improved_model <- lm(log(SalePrice) ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF,
                     data = numeric_data_cleaned)

# All-subsets best model
top <- names(head(sort(abs(sale_price_cor), decreasing = TRUE), 15))
pred <- numeric_data_cleaned[, top]; pred$SalePrice <- NULL
subsets <- regsubsets(log(SalePrice) ~ .,
                      data = cbind(pred, SalePrice = numeric_data_cleaned$SalePrice),
                      nvmax = 14)
best_size <- which.max(summary(subsets)$adjr2)
```

---

## 13. References

- De Cock, D. (2011). Ames, Iowa: Alternative to the Boston Housing Data Set. *Journal of Statistics Education, 19*(3). https://doi.org/10.1080/10691898.2011.11889627
- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013). *An Introduction to Statistical Learning: with Applications in R*. Springer.
- Kutner, M. H., Nachtsheim, C. J., Neter, J., & Li, W. (2005). *Applied Linear Statistical Models* (5th ed.). McGraw-Hill Irwin.
- Fox, J., & Weisberg, S. (2019). *car: Companion to Applied Regression* [R package]. https://cran.r-project.org/package=car
- Lumley, T., & Miller, A. (2020). *leaps: Regression Subset Selection* [R package]. https://cran.r-project.org/package=leaps
- Wei, T., & Simko, V. (2021). *corrplot: Visualization of a Correlation Matrix* [R package]. https://github.com/taiyun/corrplot

---

<div align="center">

**Sri Ram Prabu E** &nbsp;•&nbsp; ALY6015: Intermediate Analytics &nbsp;•&nbsp; Dr. Paul Dooley &nbsp;•&nbsp; 09/20/2025

[Back to Portfolio](../README.md) &nbsp;•&nbsp; [Full Report (PDF)](Regression%20Diagnostics%20with%20R%20-%20Report.pdf)

</div>
