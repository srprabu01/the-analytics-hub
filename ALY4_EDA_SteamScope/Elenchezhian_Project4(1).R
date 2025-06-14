library(dplyr)
library(ggplot2)
library(readr)


games <- read_csv("games.csv")


glimpse(games)

games$`Release date` <- as.Date(games$`Release date`, format="%b %d, %Y")


games_cleaned <- games %>%
  select(-c(`Header image`, `Website`, `Support url`, `Support email`, 
            `Metacritic url`, `Screenshots`, `Movies`, `Notes`, `Score rank`))

games_cleaned <- games_cleaned %>%
  filter(!is.na(AppID) & !is.na(Name)) %>%
  mutate(
    `About the game` = ifelse(is.na(`About the game`), "No description available", `About the game`),
    Developers = ifelse(is.na(Developers), "Unknown", Developers),
    Publishers = ifelse(is.na(Publishers), "Unknown", Publishers),
    Categories = ifelse(is.na(Categories), "Uncategorized", Categories),
    Genres = ifelse(is.na(Genres), "Uncategorized", Genres),
    Tags = ifelse(is.na(Tags), "No tags", Tags),
    `Required age` = as.integer(`Required age`),
    Price = as.numeric(Price)
  )


glimpse(games_cleaned)


summary(games_cleaned)

# Visualizations


ggplot(games_cleaned, aes(x = Price)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Game Prices", x = "Price (USD)", y = "Count")


top_genres <- games_cleaned %>%
  group_by(Genres) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  head(10)

ggplot(top_genres, aes(x = reorder(Genres, count), y = count)) +
  geom_bar(stat = "identity", fill = "green") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 10 Game Genres", x = "Genres", y = "Count")


ggplot(games_cleaned, aes(x = Price, y = `Peak CCU`)) +
  geom_point(alpha = 0.5, color = "red") +
  theme_minimal() +
  labs(title = "Price vs. Peak Concurrent Users", x = "Price (USD)", y = "Peak Concurrent Users")


write_csv(games_cleaned, "games_cleaned.csv")

