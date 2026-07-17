# Module 4 Assignment - Regularization (Ridge & LASSO)
# Course : ALY6015 - Intermediate Analytics
# Author : Sri Ram Prabu E
# Date   : 10/12/2025
#
# Goal: predict college Graduation Rate (Grad.Rate) on the ISLR::College dataset
# using penalized linear models (Ridge L2, LASSO L1), tuned by 10-fold CV, and
# benchmarked against a stepwise-selection baseline.

set.seed(2025)

suppressPackageStartupMessages({
  library(ISLR)
  library(caret)
  library(glmnet)
  library(dplyr)
})

data("College")

# ---- Inspect and clean ----
df <- College %>%
  as.data.frame() %>%
  na.omit()

# Response
y <- df$Grad.Rate

# Model matrix: one-hot encode the Private factor; drop intercept column
X <- model.matrix(Grad.Rate ~ ., data = df)[, -1]

# ---- Train/Test split (70/30) ----
set.seed(2025)
idx     <- createDataPartition(y, p = 0.7, list = FALSE)
X_train <- X[idx, ];  y_train <- y[idx]
X_test  <- X[-idx, ]; y_test  <- y[-idx]

rmse <- function(actual, pred) sqrt(mean((actual - pred)^2))

# ============================================================
# RIDGE REGRESSION  (alpha = 0)
# ============================================================
set.seed(2025)
cv_ridge <- cv.glmnet(X_train, y_train, alpha = 0, nfolds = 10, standardize = TRUE)
lambda_min_ridge <- cv_ridge$lambda.min      # 1.201
lambda_1se_ridge <- cv_ridge$lambda.1se      # 17.832

# Coefficients (none are zeroed under Ridge)
coef_ridge_min <- coef(cv_ridge, s = "lambda.min")
coef_ridge_1se <- coef(cv_ridge, s = "lambda.1se")

# Predictions & RMSE at lambda.min
pred_ridge_train_min <- predict(cv_ridge, newx = X_train, s = "lambda.min")
pred_ridge_test_min  <- predict(cv_ridge, newx = X_test,  s = "lambda.min")
rmse_ridge_train_min <- rmse(y_train, pred_ridge_train_min)   # 12.67
rmse_ridge_test_min  <- rmse(y_test,  pred_ridge_test_min)    # 12.57

# Predictions & RMSE at lambda.1se
pred_ridge_train_1se <- predict(cv_ridge, newx = X_train, s = "lambda.1se")
pred_ridge_test_1se  <- predict(cv_ridge, newx = X_test,  s = "lambda.1se")
rmse_ridge_train_1se <- rmse(y_train, pred_ridge_train_1se)   # 13.27
rmse_ridge_test_1se  <- rmse(y_test,  pred_ridge_test_1se)    # 12.72

# ============================================================
# LASSO REGRESSION  (alpha = 1)
# ============================================================
set.seed(2025)
cv_lasso <- cv.glmnet(X_train, y_train, alpha = 1, nfolds = 10, standardize = TRUE)
lambda_min_lasso <- cv_lasso$lambda.min      # 0.138
lambda_1se_lasso <- cv_lasso$lambda.1se      # 1.413

coef_lasso_min <- coef(cv_lasso, s = "lambda.min")
coef_lasso_1se <- coef(cv_lasso, s = "lambda.1se")

# Predictors that survive LASSO at lambda.min (non-zero coefficients)
lasso_min_nonzero <- rownames(coef_lasso_min)[as.numeric(coef_lasso_min) != 0]

pred_lasso_train_min <- predict(cv_lasso, newx = X_train, s = "lambda.min")
pred_lasso_test_min  <- predict(cv_lasso, newx = X_test,  s = "lambda.min")
rmse_lasso_train_min <- rmse(y_train, pred_lasso_train_min)   # 12.65
rmse_lasso_test_min  <- rmse(y_test,  pred_lasso_test_min)    # 12.72

pred_lasso_train_1se <- predict(cv_lasso, newx = X_train, s = "lambda.1se")
pred_lasso_test_1se  <- predict(cv_lasso, newx = X_test,  s = "lambda.1se")
rmse_lasso_train_1se <- rmse(y_train, pred_lasso_train_1se)   # 13.26
rmse_lasso_test_1se  <- rmse(y_test,  pred_lasso_test_1se)    # 12.95

# ============================================================
# STEPWISE SELECTION BASELINE (bidirectional, AIC)
# ============================================================
train_df <- df[idx, ]
test_df  <- df[-idx, ]

full_lm <- lm(Grad.Rate ~ ., data = train_df)
step_lm <- step(full_lm, direction = "both", trace = 0)

pred_step_train <- predict(step_lm, newdata = train_df)
pred_step_test  <- predict(step_lm, newdata = test_df)
rmse_step_train <- rmse(train_df$Grad.Rate, pred_step_train)  # 12.64
rmse_step_test  <- rmse(test_df$Grad.Rate,  pred_step_test)   # 12.94

# ============================================================
# SUMMARY OUTPUT
# ============================================================
cat("\n--- RIDGE ---\n")
cat("lambda.min:", lambda_min_ridge, "  lambda.1se:", lambda_1se_ridge, "\n")
cat("Ridge RMSE (train/test @ min):", rmse_ridge_train_min, rmse_ridge_test_min, "\n")
cat("Ridge RMSE (train/test @ 1se):", rmse_ridge_train_1se, rmse_ridge_test_1se, "\n")

cat("\n--- LASSO ---\n")
cat("lambda.min:", lambda_min_lasso, "  lambda.1se:", lambda_1se_lasso, "\n")
cat("LASSO RMSE (train/test @ min):", rmse_lasso_train_min, rmse_lasso_test_min, "\n")
cat("LASSO RMSE (train/test @ 1se):", rmse_lasso_train_1se, rmse_lasso_test_1se, "\n")

cat("\n--- Stepwise ---\n")
cat("Formula:", deparse(formula(step_lm)), "\n")
cat("Stepwise RMSE (train/test):", rmse_step_train, rmse_step_test, "\n")

# CV plots (view interactively in R)
# plot(cv_ridge); title("Ridge CV", line = 2.5)
# plot(cv_lasso); title("LASSO CV", line = 2.5)
