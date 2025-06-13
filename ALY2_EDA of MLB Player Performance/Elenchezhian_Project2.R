# Load the required lib
library(readr)
library(tidyverse)
library(dplyr)
library(janitor)   

#1: Load the 2015 dataset
data_2015 <- read_csv("2015(1).csv")

head(data_2015)

#2: Check the column names
names(data_2015)

#3: View the dataset in a separate tab
View(data_2015)

#4: Use the glimpse function to explore the dataset structure
glimpse(data_2015)

#5: Clean column names using janitor
data_2015 <- clean_names(data_2015)

#6: Select specific columns (country, region, happiness_score, freedom)
happy_df <- data_2015 %>%
  select(country, region, happiness_score, freedom)

#7: Slice the first 10 rows for top countries
top_ten_df <- happy_df %>%
  slice(1:10)

#8: Filter rows with freedom values under 0.20
no_freedom_df <- happy_df %>%
  filter(freedom < 0.20)

#9: Arrange rows by freedom in descending order
best_freedom_df <- happy_df %>%
  arrange(desc(freedom))

#10: Add a new column gff_stat (family + freedom + generosity)
data_2015 <- data_2015 %>%
  mutate(gff_stat = family + freedom + generosity)

#11: Group by region and summarize statistics
regional_stats_df <- happy_df %>%
  group_by(region) %>%
  summarise(
    country_count = n(),
    mean_happiness = mean(happiness_score, na.rm = TRUE),
    mean_freedom = mean(freedom, na.rm = TRUE)
  )

# Load necessary libraries
library(tidyverse)

#12. Load the dataset
baseball <- read_csv("baseball.csv")

#13. Explore the dataset to understand its structure and contents
str(baseball)
summary(baseball)
head(baseball)

#14. Remove players with 0 at bats (AB)
baseball <- baseball %>% filter(AB > 0)

#15. Add a new column for Batting Average (BA)
baseball <- baseball %>% mutate(BA = H / AB)

#16. Add a new column for On-Base Percentage (OBP)
baseball <- baseball %>% mutate(OBP = (H + BB) / (AB + BB))

#17. Determine the top 10 players with the most strikeouts
strikeout_artist <- baseball %>% 
  arrange(desc(SO)) %>% 
  slice_head(n = 10)

# View the top strikeout players
print(strikeout_artist)

#18. Filter eligible players for awards (at least 300 ABs or appeared in at least 100 games)
eligible_df <- baseball %>% 
  filter(AB >= 300 | G >= 100)

#19. Create a histogram of Batting Average for eligible players
hist(eligible_df$BA, 
     breaks = 20, 
     col = "blue", 
     main = "Histogram of Batting Average (Eligible Players)", 
     xlab = "Batting Average", 
     ylab = "Frequency")

#20. Analyze eligible players for MVP selection
# Compute summary statistics for eligible players
eligible_summary <- eligible_df %>% 
  summarise(
    avg_BA = mean(BA, na.rm = TRUE),
    avg_OBP = mean(OBP, na.rm = TRUE),
    avg_HR = mean(HR, na.rm = TRUE),
    avg_RBI = mean(RBI, na.rm = TRUE)
  )

# View summary statistics
print(eligible_summary)

# Select the player with the most impact
mvp_candidate <- eligible_df %>% 
  filter(Last == "Barfield" & First == "Jesse")

# View details of the selected MVP candidate
print(mvp_candidate)

