# Group 1 - Hernandez/Prabu/Shirevani, ALY 6015
# Pitcher's Stuff & Injury Risk
# =========================

rm(list = ls())
library(tidyverse)
library(Lahman)
library(stringi) #removing accents
str(Pitching)

#Normalizer (to be used in both datasets - LAHMAN & SAVANT) 
norm_key <- function(x) {
  x %>%
    stringi::stri_trans_general("Latin-ASCII") %>%      # José -> Jose
    stringr::str_to_lower() %>%
    stringr::str_replace_all("[[:punct:]]", " ") %>%    # drop commas/periods
    stringr::str_squish() %>%
    # collapse spaced initials: "j t" -> "jt", "j c" -> "jc"
    stringr::str_replace_all("(?<=\\b[a-z])\\s+(?=[a-z]\\b)", "") %>%
    # remove generational suffixes
    stringr::str_replace_all("\\b(jr|sr|ii|iii|iv|v)\\b", "") %>%
    stringr::str_squish()
}

#People - display name "Last, First"
people_commas <- People %>%
  mutate(name_suffix = if ("nameSuffix" %in% names(.)) coalesce(nameSuffix, "") else "") %>%
  transmute(
    playerID,
    name_last_first = paste0(
      nameLast,
      ifelse(name_suffix != "", paste0(" ", name_suffix), ""),
      ", ",
      nameFirst))

#Season-level pitching with names; keeping original Lahman names to mantain baseball lingo
pitching <- Pitching %>%
  left_join(people_commas, by = "playerID") %>% #Accounting only Statcast era stats
  filter(yearID >= 2015) %>%
  mutate(
    IP = IPouts / 3,
    SO9 = if_else(IP > 0, SO * 9 / IP, NA_real_),
    BB9 = if_else(IP > 0, BB * 9 / IP, NA_real_),
    HR9 = if_else(IP > 0, HR * 9 / IP, NA_real_),
    WHIP = if_else(IP > 0,(BB + H) / IP, NA_real_))

#Auto-sum additive numeric columns; excluding rate-like 
rate_like <- c("BAOpp","ERA","IP","SO9","BB9","HR9","WHIP")
num_cols  <- names(pitching)[sapply(pitching, is.numeric)]
additive_numeric <- setdiff(num_cols, rate_like)

lahman_pitcher_totals <- pitching %>%
  group_by(playerID) %>%
  summarise(
    name_last_first = first(name_last_first),
    seasons         = n_distinct(yearID),
    first_year      = min(yearID, na.rm = TRUE),
    last_year       = max(yearID, na.rm = TRUE),
    across(all_of(additive_numeric), ~ sum(.x, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  mutate(
    IP_total   = IPouts / 3,
    ERA_career = if_else(IP_total > 0, 9 * ER / IP_total, NA_real_),
    SO9_career = if_else(IP_total > 0, SO * 9 / IP_total, NA_real_),
    BB9_career = if_else(IP_total > 0, BB * 9 / IP_total, NA_real_),
    HR9_career = if_else(IP_total > 0, HR * 9 / IP_total, NA_real_),
    WHIP_career = if_else(IP_total > 0, (BB + H) / IP_total, NA_real_)
  ) %>%
  mutate(join_key = norm_key(name_last_first))

#Checking for dupes
lah_dupes <- lahman_pitcher_totals %>%
  dplyr::count(join_key) %>%
  dplyr::filter(n > 1)
  
#Mannually drop dupes based on data in Savant & Trumedia
drop_playerIDs <- c(
  "adamsau01","allenlo01","carpeda01","carpeda02","castidi02","castilu03",
  "fernajo04","guerrja02","ortizlu02","ortizlu03","reynoma02","reynoma03",
  "smithch08","smithch10","smithch07","smithch09","smithjo08")

#Applying the manual drop
lahman_pitcher_totals <- lahman_pitcher_totals %>%
  filter(!playerID %in% drop_playerIDs)

#Loading Savant Statcast dataset
library(readr)
library(dplyr)
savant <- read_csv("savant_data.csv", show_col_types=FALSE) %>%
  dplyr::select(
    player_name,
    total_pitches,
    velocity,
    spin_rate,
    effective_speed,
    whiffs,
    swings,
    takes
  )  %>%
  mutate(join_key = norm_key(player_name))

#Applying known preferred-name adjustments (Savant changed to Lahman naming alignment)
savant <- savant %>%
  mutate(join_key = dplyr::recode(
    join_key,
    "boyd matthew"   = "boyd matt",
    "king michael"   = "king mike",
    "soroka michael" = "soroka mike",
    "smith josh a"   = "smith josh",
    "bowman matt"    = "bowman matthew"
  ))

#Checking for dupes
sav_dupes <- savant %>%
  dplyr::count(join_key) %>%
  dplyr::filter(n > 1)

#Manually mapping the two Luis Garcia rows to precise Lahman playerIDs
savant_explicit <- savant %>%
  dplyr::filter(player_name %in% c("García, Luis", "Garcia, Luis")) %>%
  dplyr::mutate(
    playerID = dplyr::case_when(
      player_name == "García, Luis" ~ "garcilu03",  # accented -> garcilu03
      player_name == "Garcia, Luis" ~ "garcilu05",  # unaccented -> garcilu05
      TRUE ~ NA_character_))

#Excluding the two Luis Garcia from the rest to avoid duplicating them
savant_rest <- savant %>%
  dplyr::filter(!player_name %in% c("García, Luis", "Garcia, Luis"))

#Collapsing the rest of Savant to ONE row per normalized name 
savant_rest_keyed <- savant_rest %>%
  dplyr::group_by(join_key) %>%
  dplyr::slice_max(total_pitches, n = 1, with_ties = FALSE) %>%
  dplyr::ungroup()

#Prepping Lahman for name-key join 
lahman_by_key <- lahman_pitcher_totals %>%
  dplyr::group_by(join_key) %>%
  dplyr::slice_max(IP_total, n = 1, with_ties = FALSE) %>%
  dplyr::ungroup()

#Joining - the two explicit Luis Garcia rows by playerID (exact match)
combined_explicit <- savant_explicit %>%
  dplyr::inner_join(lahman_pitcher_totals, by = "playerID")

#Joining - everyone else by normalized name key
combined_rest <- savant_rest_keyed %>%
  dplyr::inner_join(lahman_by_key, by = "join_key")

#Unifying both datasets - LAHMAN / SAVANT STATCAST
pitcher_df <- dplyr::bind_rows(combined_explicit, combined_rest)

#Dropping join helper columns (no longer needed) ---
pitcher_df <- pitcher_df %>%
  dplyr::select(-dplyr::any_of(c("join_key.x", "name_last_first", "join_key.y", "join_key")))

#Injury Data Integration
library(lubridate)
injuries <- read_csv("injuries.csv", show_col_types = FALSE)
str(injuries)

#Base cleaning (NO year filter yet)
injuries_clean_base <- injuries %>%
  dplyr::rename(
    player_name_il = Relinquished,   
    injury         = Injury,          #injury indicator
    dl_days        = DL_length,       
    injury_type    = Injury_Type
  ) %>%
  dplyr::mutate(
    player_name_il = stringr::str_remove(player_name_il, "^\\s*•\\s*"), # removing leading bullets like "• " from names
    injury_date    = as.Date(Date),
    year_final     = year(injury_date)) %>%
  dplyr::filter(stringr::str_detect(player_name_il, "[A-Za-z]")) %>% #keeping only rows that actually look like a name
#building a First, Last Join Key
  dplyr::mutate(join_key_fl = norm_key(player_name_il))

#Making filtered version (2015–2017)
injuries_clean <- injuries_clean_base %>%
  dplyr::filter(!is.na(year_final) & dplyr::between(year_final, 2015, 2017))

#Aggregating multiple injuries per player 
injuries_agg <- injuries_clean %>%
  dplyr::group_by(join_key_fl) %>%
  dplyr::summarise(
    injury_count   = dplyr::n(),               #producing IL counts based on rows of IL each name has
    total_dl_days  = sum(dl_days, na.rm = TRUE),                        #total DL days
    last_injury_dt = suppressWarnings(max(injury_date, na.rm = TRUE)),  #most recent injury
    injury_types   = paste(sort(unique(na.omit(injury_type))), collapse = " | "),
    .groups = "drop")

#Checking for duplicates
injuries_dup <- injuries_agg %>%
  dplyr::count(join_key_fl) %>%
  dplyr::filter(n > 1)

#Preparing pitcher_df key in the same name order as injuries (First Last)
#Savant player_name is "Last, First" - converting to "First Last" then normalizing
pitcher_df <- pitcher_df %>%
  dplyr::mutate(
    name_first_last = stringr::str_replace(player_name, "^([^,]+),\\s*(.+)$", "\\2 \\1"),
    join_key_fl     = norm_key(name_first_last)
  ) %>%
  dplyr::left_join(injuries_agg, by = "join_key_fl") %>%
  dplyr::mutate(
    injury_count    = dplyr::coalesce(as.integer(injury_count), 0L),  #NA - 0
    total_dl_days   = dplyr::coalesce(total_dl_days, 0),              #NA - 0
    injury_occurred = as.integer(injury_count > 0)                    #final binary
  ) %>%
  dplyr::select(-name_first_last, -join_key_fl)

#EDA and Descriptive Statistics
#Viewing summary information of the data
head(pitcher_df)
str(pitcher_df)
dim(pitcher_df)

summary(pitcher_df %>% 
          select(ERA_career, SO9_career, BB9_career, WHIP_career, 
                        velocity, spin_rate, total_pitches))

#Correlation Matrix
cor_matrix <- pitcher_df %>% 
  select(ERA_career, SO9_career, BB9_career, WHIP_career, 
         velocity, spin_rate, total_pitches) %>% 
  cor(use = "pairwise.complete.obs")
round(cor_matrix, 2)

#Producing a correlation plot for the correlation matrix
library(corrplot)
corrplot(cor_matrix, method = "color", type = "upper", tl.cex = 0.5)

#Histogram of Career ERA
ggplot(pitcher_df, aes(x = ERA_career)) + 
  geom_histogram(binwidth = 0.25, fill = "blue", color = "black") +
  labs(title = "Distribution of Career ERA", x = "Career ERA", y = "Count")

#Scatterplot of Velocity vs Strikeouts per 9 innings
ggplot(pitcher_df, aes(x = velocity, y = SO9_career)) + 
  geom_point(color = "green") +
  geom_smooth(method = "lm", se = FALSE, color = "red") + 
  labs(title = "Velocity vs Strikeouts per 9 Innings", x = "Velocity (mph)", y = "Strikeouts per 9 (SO9)")

#Density Plot of Velocity
ggplot(pitcher_df, aes(x = velocity)) +
  geom_density(fill = "darkturquoise") + 
  labs(title = "Distribution of Pitch Velocity", x = "Velocity (mph)", y = "Density")

#Linear Regression Model: Predicting ERA from Pitching Metrics
lm_era <-  lm(formula = ERA_career ~ SO9_career + BB9_career + velocity + spin_rate, data = pitcher_df)
summary(lm_era)

#Plotting regression diagnostics for lm_era
#Residuals vs Fitted - linearity 
#Normal Q-Q Plot - normality
#Scale - Location - homoscedasticity (constant variance)
#Residuals vs Leverage - Unusual observations
par(mfrow = c(2,2))
plot(lm_era)
dev.off()

#Linear Regression Model: Predicting Innings Pitched from Pitching Metrics
lm_ip <-  lm(formula = IP_total ~ SO9_career + BB9_career + velocity + spin_rate, data = pitcher_df)
summary(lm_ip)

#Plotting regression diagnostics for lm_ip
#Residuals vs Fitted - linearity 
#Normal Q-Q Plot - normality
#Scale - Location - homoscedasticity (constant variance)
#Residuals vs Leverage - Unusual observations
par(mfrow = c(2,2))
plot(lm_ip)
dev.off()


#Split data into train and test sets
set.seed(123)
trainIndex <- sample(x = nrow(pitcher_df), size = nrow(pitcher_df) * 0.70)
train <- pitcher_df[trainIndex,]
test <- pitcher_df[-trainIndex,]

head(train)

#Fit a logistic regression model
model1 <- glm(injury_occurred ~ total_pitches + velocity + spin_rate + IP_total + SO9_career + BB9_career,  data = train, family = binomial)
summary(model1)

#Checking for multicollinearity
library(car)
vif(model1)

#Fit a logistic regression model
model2 <- glm(injury_occurred ~ total_pitches + velocity + spin_rate + SO9_career + BB9_career,  data = train, family = binomial)
summary(model2)

#Display regression coefficients (log-odds)
coef(model2)

#Display regression coefficients (odds)
exp(coef(model2))

#Checking for multicollinearity
vif(model2)

#Create dataset to see how probability changes for different values of total pitches
testdata1 <- data.frame(total_pitches = c(min(pitcher_df$total_pitches), mean(pitcher_df$total_pitches), max(pitcher_df$total_pitches)), 
                        velocity = mean(pitcher_df$velocity), spin_rate = mean(pitcher_df$spin_rate), 
                        SO9_career = mean(pitcher_df$SO9_career), 
                        BB9_career = mean(pitcher_df$BB9_career)) 
testdata1$probs <- predict (model2, testdata1, type = "response") 
testdata1

#Train set predictions
library(caret)

#Converting train response variable to factor
train$injury_occurred <- factor(ifelse(train$injury_occurred == 1, "Yes", "No"))

#Making predicted probabilities on the training set
probabilities.train <- predict(model2, newdata = train, type = "response") 
predicted.classes.min <- as.factor(ifelse(probabilities.train >= 0.5, "Yes", "No"))

#Creating confusion matrix and model accuracy
confusionMatrix(predicted.classes.min, train$injury_occurred, positive = 'Yes')


#Converting test response variable to factor
test$injury_occurred <- factor(ifelse(test$injury_occurred == 1, "Yes", "No"))

#Test set predictions
probabilities.test <- predict(model2, newdata = test, type = "response") 
predicted.classes.min <- as.factor(ifelse(probabilities.test >= 0.5, "Yes", "No"))


#Confusion matrix and model accuracy
confusionMatrix(predicted.classes.min, test$injury_occurred, positive = 'Yes')

#Plot ROC curve
library(pROC)
ROC1 <- roc(test$injury_occurred, probabilities.test)

plot(ROC1, col = "blue", ylab = "Sensitivity - TP Rate", xlab = "Specificity - FP Rate")

#Calculate the area under ROC curve
auc <- auc(ROC1)
auc

#The top 10 pitchers who appeared the most in the IL List
top_pitcher_il <- pitcher_df %>%
  select(player_name, injury_count) %>%
  arrange(desc(injury_count)) %>%
  head(10)
top_pitcher_il