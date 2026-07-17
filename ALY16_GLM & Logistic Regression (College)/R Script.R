# Module 3 Assignment - GLM and Logistic Regression
# Course : ALY6015 - Intermediate Analytics
# Author : Sri Ram Prabu E
# Date   : 10/05/2025
#
# Goal: classify U.S. colleges as Private (Yes) vs Public (No) using logistic
# regression on the ISLR::College dataset (777 institutions, 18 variables).

library(ISLR)
library(ggplot2)
library(caret)
library(pROC)
library(dplyr)
set.seed(2025)

# ---- Load data ----
data("College")
df <- College
df$Private <- factor(df$Private, levels = c("No", "Yes"))

str(df)
summary(df)

# ---- Exploratory Data Analysis ----
numeric_vars <- c("Apps", "Accept", "Enroll", "Top10perc", "Top25perc", "F.Undergrad",
                  "P.Undergrad", "Outstate", "Room.Board", "Books", "Personal",
                  "PhD", "Terminal", "S.F.Ratio", "perc.alumni", "Expend", "Grad.Rate")

plot_hist <- function(var) {
  ggplot(df, aes(x = .data[[var]])) +
    geom_histogram(bins = 30) +
    labs(title = paste("Histogram of", var), x = var, y = "Count")
}

# Boxplots of candidate predictors by Private/Public
bp1 <- ggplot(df, aes(x = Private, y = Outstate))  + geom_boxplot() + labs(title = "Outstate by Private")
bp2 <- ggplot(df, aes(x = Private, y = Expend))    + geom_boxplot() + labs(title = "Expend by Private")
bp3 <- ggplot(df, aes(x = Private, y = Grad.Rate)) + geom_boxplot() + labs(title = "Grad.Rate by Private")

# ---- Train/Test split (70/30, stratified on the outcome) ----
train_index <- createDataPartition(df$Private, p = 0.7, list = FALSE)
train <- df[train_index, ]
test  <- df[-train_index, ]

# ---- Fit logistic regression on five selected predictors ----
# Outstate (tuition), Expend (spend/student), Grad.Rate, S.F.Ratio, perc.alumni
base_formula <- Private ~ Outstate + Expend + Grad.Rate + S.F.Ratio + perc.alumni

fit <- glm(base_formula, data = train, family = binomial(link = "logit"))
summary(fit)
final_fit <- fit

# ---- Evaluate on the TRAINING set (threshold 0.5) ----
train$prob <- predict(final_fit, newdata = train, type = "response")
train$pred <- factor(ifelse(train$prob >= 0.5, "Yes", "No"), levels = c("No", "Yes"))

cm_train <- confusionMatrix(data = train$pred, reference = train$Private, positive = "Yes")
print(cm_train)

train_accuracy  <- cm_train$overall["Accuracy"]
train_precision <- cm_train$byClass["Precision"]
train_recall    <- cm_train$byClass["Sensitivity"]
train_specific  <- cm_train$byClass["Specificity"]
print(c(Accuracy = train_accuracy, Precision = train_precision,
        Recall = train_recall, Specificity = train_specific))

# ROC / AUC (train)
roc_train <- roc(response = train$Private, predictor = train$prob,
                 levels = c("No", "Yes"), direction = "<")
auc_train <- auc(roc_train)
print(auc_train)
plot(roc_train, main = sprintf("ROC (Train) -- AUC = %.3f", auc_train))

# ---- Evaluate on the TEST set (threshold 0.5) ----
test$prob <- predict(final_fit, newdata = test, type = "response")
test$pred <- factor(ifelse(test$prob >= 0.5, "Yes", "No"), levels = c("No", "Yes"))

cm_test <- confusionMatrix(data = test$pred, reference = test$Private, positive = "Yes")
print(cm_test)

test_accuracy  <- cm_test$overall["Accuracy"]
test_precision <- cm_test$byClass["Precision"]
test_recall    <- cm_test$byClass["Sensitivity"]
test_specific  <- cm_test$byClass["Specificity"]
print(c(Accuracy = test_accuracy, Precision = test_precision,
        Recall = test_recall, Specificity = test_specific))

# ROC / AUC (test)
roc_test <- roc(response = test$Private, predictor = test$prob,
                levels = c("No", "Yes"), direction = "<")
auc_test <- auc(roc_test)
print(auc_test)
plot(roc_test, main = sprintf("ROC (Test) -- AUC = %.3f", auc_test))
