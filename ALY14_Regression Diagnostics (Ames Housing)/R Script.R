# Module 1 Assignment - Regression Diagnostics with R
# Course : ALY6015 - Intermediate Analytics
# Author : Sri Ram Prabu E
# Date   : 09/20/2025

# Install required packages if they are not already available
if (!require("corrplot")) install.packages("corrplot")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("leaps"))   install.packages("leaps")
if (!require("car"))     install.packages("car")

library(corrplot)
library(ggplot2)
library(leaps)
library(car)

# 1. Load the Ames Housing dataset
tryCatch({
  ames_data <- read.csv("AmesHousing.csv")
  print("Ames Housing dataset loaded successfully.")
}, error = function(e) {
  print("Error loading AmesHousing.csv. Please ensure the file is in your working directory.")
  stop(e)
})

# 2. Exploratory Data Analysis (EDA)
cat("\n--- Exploratory Data Analysis ---\n")

# Display the structure of the dataset
cat("\nStructure of the dataset:\n")
str(ames_data, list.len = 10)

# Display summary statistics for key variables
cat("\nSummary statistics for SalePrice:\n")
summary(ames_data$SalePrice)

cat("\nSummary statistics for some predictor variables:\n")
summary(ames_data[, c("Gr.Liv.Area", "Overall.Qual", "Total.Bsmt.SF", "Year.Built")])

# 3. Data Preparation: impute missing values with the column mean
cat("\n--- Data Preparation ---\n")

# Identify numeric columns
numeric_vars <- sapply(ames_data, is.numeric)
numeric_data <- ames_data[, numeric_vars]

# Impute missing values with the mean for each numeric column
for (col in 1:ncol(numeric_data)) {
  if (any(is.na(numeric_data[, col]))) {
    mean_val <- mean(numeric_data[, col], na.rm = TRUE)
    numeric_data[is.na(numeric_data[, col]), col] <- mean_val
    cat("Missing values in '", colnames(numeric_data)[col],
        "' imputed with mean: ", round(mean_val, 2), "\n")
  }
}

# Verify that there are no more NA values in the numeric subset
cat("\nTotal NA values in numeric data after imputation: ",
    sum(is.na(numeric_data)), "\n")

# 4. Correlation matrix of the numeric variables
cat("\n--- Correlation Analysis ---\n")
cor_matrix <- cor(numeric_data)

# View the correlations with SalePrice
sale_price_cor <- cor_matrix["SalePrice", ]
cat("\nTop 10 correlations with SalePrice:\n")
print(head(sort(abs(sale_price_cor), decreasing = TRUE), 11))

# 5. Plot the correlation matrix
par(mfrow = c(1, 1))
corrplot(cor_matrix, method = "color", type = "upper", order = "hclust",
         tl.col = "black", tl.srt = 45, tl.cex = 0.6,
         title = "Correlation Matrix of Ames Housing Numeric Variables",
         mar = c(0, 0, 1, 0))

# 6. Scatter plots for highest, lowest, and ~0.5 correlated predictors

# Variable with the highest correlation with SalePrice (excluding SalePrice itself)
highest_cor_var <- names(sort(abs(sale_price_cor), decreasing = TRUE)[2])
highest_cor_val <- sale_price_cor[highest_cor_var]

# Variable with the lowest absolute correlation with SalePrice
# (exclude PID and Order as they are identifiers)
lowest_cor_var <- names(sort(abs(sale_price_cor[!names(sale_price_cor) %in%
                                                  c("PID", "Order")]),
                             decreasing = FALSE)[1])
lowest_cor_val <- sale_price_cor[lowest_cor_var]

# Variable with correlation closest to 0.5
mid_cor_var <- names(which.min(abs(sale_price_cor - 0.5)))
mid_cor_val <- sale_price_cor[mid_cor_var]

cat("\nHighest correlation with SalePrice:", highest_cor_var,
    "(", round(highest_cor_val, 3), ")\n")
cat("Lowest absolute correlation with SalePrice:", lowest_cor_var,
    "(", round(lowest_cor_val, 3), ")\n")
cat("Correlation closest to 0.5 with SalePrice:", mid_cor_var,
    "(", round(mid_cor_val, 3), ")\n")

# Create a 1x3 layout for the scatter plots
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1))

# Highest correlation
plot(numeric_data[[highest_cor_var]], numeric_data$SalePrice,
     main = paste("Highest Correlation:\n", highest_cor_var),
     xlab = highest_cor_var, ylab = "Sale Price", pch = 16, col = "blue")

# Lowest correlation
plot(numeric_data[[lowest_cor_var]], numeric_data$SalePrice,
     main = paste("Lowest Correlation:\n", lowest_cor_var),
     xlab = lowest_cor_var, ylab = "Sale Price", pch = 16, col = "grey")

# Correlation closest to 0.5
plot(numeric_data[[mid_cor_var]], numeric_data$SalePrice,
     main = paste("Mid Correlation (~0.5):\n", mid_cor_var),
     xlab = mid_cor_var, ylab = "Sale Price", pch = 16, col = "orange")

# Reset plotting layout
par(mfrow = c(1, 1))

# 7. Fit an initial multiple regression model (3 continuous predictors)
cat("\n--- Initial Regression Model ---\n")
initial_model <- lm(SalePrice ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF,
                    data = numeric_data)
cat("\nSummary of Initial Model:\n")
summary(initial_model)

# 8. Report the model in equation form
cat("\nModel Equation: SalePrice = ", round(coef(initial_model)[1], 2),
    " + ", round(coef(initial_model)[2], 2), " * Overall.Qual",
    " + ", round(coef(initial_model)[3], 2), " * Gr.Liv.Area",
    " + ", round(coef(initial_model)[4], 2), " * Total.Bsmt.SF\n")

# 9. Plot and interpret the four diagnostic graphs
cat("\n--- Model Diagnostics ---\n")
par(mfrow = c(2, 2))
plot(initial_model)
par(mfrow = c(1, 1))

# 10. Check for multicollinearity using VIF
cat("\nChecking for Multicollinearity using VIF:\n")
vif_values <- vif(initial_model)
print(vif_values)

# 11. Check for outliers and influential points
cat("\nChecking for Outliers and Influential Points:\n")
# Outliers appear in the Residuals vs. Fitted plot; influential points via Cook's distance.
cat("Points 1499, 2181, 2182 appear to be influential based on diagnostic plots.\n")
influential_points <- numeric_data[c(1499, 2181, 2182),
                                   c("SalePrice", "Overall.Qual",
                                     "Gr.Liv.Area", "Total.Bsmt.SF")]
cat("\nData for influential points:\n")
print(influential_points)

# 12. Correct model issues: log-transform SalePrice and remove extreme outliers
cat("\n--- Model Improvement ---\n")
# Remove the two most extreme outliers (2181, 2182) with huge Gr.Liv.Area.
numeric_data_cleaned <- numeric_data[-c(2181, 2182), ]

improved_model <- lm(log(SalePrice) ~ Overall.Qual + Gr.Liv.Area + Total.Bsmt.SF,
                     data = numeric_data_cleaned)
cat("\nSummary of Improved Model (log-transformed SalePrice, outliers removed):\n")
summary(improved_model)

# Diagnostics for the improved model
par(mfrow = c(2, 2))
plot(improved_model)
par(mfrow = c(1, 1))

# 13. All subsets regression to identify the "best" model
cat("\n--- All Subsets Regression ---\n")
# Select the top predictors to keep computation manageable.
top_predictors_names <- names(head(sort(abs(sale_price_cor), decreasing = TRUE), 15))
predictors_df <- numeric_data_cleaned[, top_predictors_names]
predictors_df$SalePrice <- NULL  # Remove the response variable

subsets <- regsubsets(log(SalePrice) ~ .,
                      data = cbind(predictors_df,
                                   SalePrice = numeric_data_cleaned$SalePrice),
                      nvmax = 14)
subsets_summary <- summary(subsets)

# Plot Adjusted R-squared and BIC to choose the best model size
par(mfrow = c(1, 2))
plot(subsets_summary$adjr2, xlab = "Number of Variables",
     ylab = "Adjusted R-squared", type = "b")
plot(subsets_summary$bic, xlab = "Number of Variables",
     ylab = "BIC", type = "b")
par(mfrow = c(1, 1))

# Find the model with the highest Adjusted R-squared
best_model_size <- which.max(subsets_summary$adjr2)
cat("\nBest model size based on Adjusted R-squared:", best_model_size, "variables.\n")

# Build and fit the best model
best_model_vars <- names(coef(subsets, id = best_model_size))
best_model_formula <- as.formula(paste("log(SalePrice) ~",
                                       paste(best_model_vars[-1], collapse = "+")))
best_model <- lm(best_model_formula, data = numeric_data_cleaned)
cat("\nSummary of the 'Best' Model from all subsets regression:\n")
summary(best_model)

# 14. Compare the improved model with the best subsets model
cat("\n--- Final Model Comparison ---\n")
cat("\n--- Improved Manual Model (Step 12) ---\n")
print(summary(improved_model))
cat("\n--- 'Best' All Subsets Model (Step 13) ---\n")
print(summary(best_model))

cat("\nThe 'Best' model from all subsets regression includes more variables and has a higher Adjusted R-squared (",
    round(summary(best_model)$adj.r.squared, 4),
    ") compared to the improved 3-variable model (",
    round(summary(improved_model)$adj.r.squared, 4), ").\n")

# Report the best model equation
best_coeffs <- coef(best_model)
cat("\nEquation for the 'Best' Model:\n log(SalePrice) = ", round(best_coeffs[1], 2))
for (i in 2:length(best_coeffs)) {
  cat(" + (", round(best_coeffs[i], 4), " * ", names(best_coeffs)[i], ")")
}
cat("\n")

# End
