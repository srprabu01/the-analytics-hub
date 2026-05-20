# Module 1
# Week 1

# Install & load required packages

required_pkgs <- c("dplyr", "stringr", "gmodels", "ggplot2", "plotly")
to_install    <- required_pkgs[!required_pkgs %in% installed.packages()[, "Package"]]
if(length(to_install)) install.packages(to_install)

library(dplyr)
library(stringr)
library(gmodels)
library(ggplot2)
library(plotly)

# Import data 

df <- read.csv("LungCapDataCSV.csv", 
               stringsAsFactors = FALSE, 
               na.strings      = c("", "NA", "N/A"))

# Inspect raw data

cat("=== Raw data structure ===\n"); str(df)
cat("\n=== First 6 rows ===\n"); print(head(df))

# Clean & structure

df_clean <- df %>%
  rename(
    lung_capacity = LungCap,
    age           = Age,
    height_in     = Height,
    smoker        = Smoke,
    gender        = Gender,
    c_section     = Caesarean
  ) %>%
  filter(!is.na(lung_capacity), !is.na(age), !is.na(gender)) %>%
  mutate(
    smoker    = str_to_lower(str_trim(smoker)),
    gender    = str_to_lower(str_trim(gender)),
    c_section = str_to_lower(str_trim(c_section))
  ) %>%
  mutate(
    smoker        = factor(ifelse(smoker == "yes", "Smoker", "Non-smoker")),
    gender        = factor(ifelse(gender == "male", "Male", "Female")),
    c_section     = factor(ifelse(c_section == "yes", "Yes", "No")),
    age           = as.integer(age),
    height_in     = as.numeric(height_in),
    lung_capacity = as.numeric(lung_capacity)
  )

cat("\n=== Cleaned data structure ===\n"); str(df_clean)

# Frequency tables & cross‐tabs

freq_gender         <- table(df_clean$gender)
freq_smoker         <- table(df_clean$smoker)
ftable_smoke_gender <- ftable(df_clean$smoker, df_clean$gender)

CrossTable(df_clean$smoker, df_clean$gender,
           prop.chisq = FALSE, prop.t = FALSE, format = "SPSS")

# Base‐R histogram of Lung Capacity 

hist(df_clean$lung_capacity,
     main   = "Histogram of Lung Capacity",
     xlab   = "Lung Capacity (L)",
     border = "white",
     col    = "lightblue")

# ggplot2 histograms & faceting

# Overlayed Age Distribution by Smoker Status

p_age <- ggplot(df_clean, aes(x = age, fill = smoker)) +
  geom_histogram(position = "identity", alpha = 0.5, binwidth = 1) +
  labs(title = "Age Distribution by Smoker Status",
       x     = "Age (years)",
       y     = "Count") +
  theme_minimal()
print(p_age)

# Faceted Lung Capacity by Smoker

p_lc <- ggplot(df_clean, aes(x = lung_capacity, fill = smoker)) +
  geom_histogram(bins = 20, alpha = .7) +
  facet_wrap(~ smoker) +
  labs(title = "Lung Capacity by Smoker Status",
       x     = "Lung Capacity (L)",
       y     = "Count") +
  theme_minimal()
print(p_lc)

# Interactive scatter plot (plotly)

p_int <- ggplot(df_clean, aes(x = height_in, y = lung_capacity, color = smoker)) +
  geom_point() +
  labs(title = "Lung Capacity vs. Height",
       x     = "Height (inches)",
       y     = "Lung Capacity (L)") +
  theme_minimal()
print(ggplotly(p_int))

# Side‐by‐side boxplots for multi‐class comparison

p_box <- ggplot(df_clean, aes(x = gender, y = lung_capacity, fill = smoker)) +
  geom_boxplot(position = position_dodge(width = 0.7)) +
  labs(title = "Lung Capacity by Gender & Smoker Status",
       x     = "Gender",
       y     = "Lung Capacity (L)") +
  theme_minimal()
print(p_box)
