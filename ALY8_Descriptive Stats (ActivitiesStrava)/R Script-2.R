# Module 2

library(tidyverse)
library(psych)
library(scales)

df <- read_csv("Activities.csv")

# 3.  Verify Column Names

print(names(df))
# Expected output (example):
#  [1] "Date"                "ActivityType"        
#  [3] "Distance"            "Calories"            
#  [5] "AvgHR"               "MaxHR"               
#  [7] "AerobicTE"           "AvgSpeed"            
#  [9] "MaxSpeed"            "TotalAscent"         
# [11] "TotalDescent"        "AvgBikeCadence"      
# [13] "MaxBikeCadence"      "NormalizedPower"     
# [15] "TrainingStressScore" "MaxAvgPower20min"    
# [17] "AvgPower"            "MaxPower"            
# [19] "TotalStrokes"        "Favorite"            
# [21] "MinTemp"             "MaxTemp"             
# [23] "AvgResp"             "MinResp"             
# [25] "MaxResp"             "MinElevation"        
# [27] "MaxElevation"        


# Convert Character Columns to Numeric

numeric_cols <- c(
  "Distance", "Calories", 
  "AvgHR", "MaxHR", "AerobicTE", 
  "AvgSpeed", "MaxSpeed", 
  "TotalAscent", "TotalDescent"
)

for (col in numeric_cols) {
  if (col %in% names(df)) {
    if (is.character(df[[col]]) || is.factor(df[[col]])) {
      df[[col]] <- as.numeric(gsub(",", "", as.character(df[[col]])))
    }
  } else {
    warning(paste("Column", col, "not found in df—skipping conversion."))
  }
}


# Convert Date string into (date-time) format
# Adjust the format string if your timestamp pattern is different.
df$Date <- as.POSIXct(df$Date, format = "%Y-%m-%d %H:%M:%S")

# Convert Favorite column to logical 
df$Favorite <- as.logical(df$Favorite)


# numeric fields
numeric_fields <- c(
  "Distance", "Calories", "AvgHR", 
  "MaxHR", "AerobicTE", "AvgSpeed", 
  "MaxSpeed", "TotalAscent", "TotalDescent"
)

# Use psych::describe() to get n, mean, sd, min, max, etc.
desc_overall <- describe(df[numeric_fields])

# results to console for inspection
print(desc_overall)

# simpler table (mean, sd, min, max, n) in a data frame form:
desc_summary <- df[numeric_fields] %>%
  summarise(across(
    everything(),
    list(
      mean = ~mean(.x, na.rm = TRUE),
      sd   = ~sd(.x,   na.rm = TRUE),
      min  = ~min(.x,  na.rm = TRUE),
      max  = ~max(.x,  na.rm = TRUE),
      n    = ~sum(!is.na(.x))
    )
  )) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Variable", ".value"),
    names_sep = "_"
  )

print(desc_summary)



# Descriptive Statistics: By ActivityType

desc_by_activity <- df %>%
  group_by(ActivityType) %>%
  select(all_of(numeric_fields)) %>%
  summarise(
    across(
      everything(),
      list(
        mean = ~mean(.x, na.rm = TRUE),
        sd   = ~sd(.x,   na.rm = TRUE),
        min  = ~min(.x,  na.rm = TRUE),
        max  = ~max(.x,  na.rm = TRUE),
        n    = ~sum(!is.na(.x))
      )
    ),
    .groups = "drop"
  )

print(desc_by_activity)


# Scatter Plot: Distance vs Calories
plot(
  df$Distance, 
  df$Calories, 
  main = "Figure 1: Scatter – Distance vs Calories",
  xlab = "Distance",
  ylab = "Calories",
  pch  = 16,
  col  = scales::alpha("steelblue", 0.6)
)
abline(
  lm(Calories ~ Distance, data = df),
  col = "darkred",
  lwd = 1.2
)


#  Jitter Plot: AvgHR by ActivityType
par(mar = c(8, 5, 4, 2) + 0.1)  
stripchart(
  AvgHR ~ ActivityType,
  data     = df,
  vertical = TRUE,
  method   = "jitter",
  pch      = 16,
  col      = scales::alpha("darkgreen", 0.6),
  main     = "Figure 2: Jitter – AvgHR by ActivityType",
  xlab     = "Activity Type",
  ylab     = "Average Heart Rate"
)


# Boxplot: AvgSpeed by ActivityType
par(mar = c(8, 5, 4, 2) + 0.1)
boxplot(
  AvgSpeed ~ ActivityType,
  data    = df,
  main    = "Figure 3: Boxplot – AvgSpeed by ActivityType",
  xlab    = "Activity Type",
  ylab    = "Average Speed",
  outline = TRUE,      # show outliers as individual points
  col     = "lightcyan"
)
