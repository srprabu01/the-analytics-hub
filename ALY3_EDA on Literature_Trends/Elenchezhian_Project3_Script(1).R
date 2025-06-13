# Load required libraries
library(tidyverse)  # Includes ggplot2, dplyr, and tidyr
library(janitor)    # For cleaning column names
library(lubridate)  # For handling dates

# Load data
books <- read.csv("books.csv")

# Data Cleaning
books <- books %>%
  clean_names() %>%  # Standardize column names
  mutate(
    first_publish_date = mdy(first_publish_date),  # Convert date column
    year = year(first_publish_date)  # Extract year
  ) %>%
  filter(year >= 1990 & year <= 2020) %>%  # Filter years 1990-2020
  select(-c(publish_date, edition, characters, price, genres, setting, isbn)) %>% # Remove unwanted columns
  filter(pages < 700) %>%  # Keep books with <700 pages
  drop_na()  # Remove rows with missing values

# Data Overview
glimpse(books)
summary(books)

# 1. Histogram of Book Ratings
ggplot(books, aes(x = rating)) +
  geom_histogram(binwidth = 0.25, fill = "red", color = "black") +
  labs(title = "Histogram of Book Ratings", x = "Rating", y = "Number of Books")

# 2. Boxplot of Page Counts
ggplot(books, aes(x = pages)) +
  geom_boxplot(fill = "red") +  # Fill color is red
  coord_flip() +  # Make it horizontal
  labs(title = "Box Plot of Page Counts", x = "Pages")

# 3. Books by Year (Line Plot)
by_year <- books %>%
  group_by(year) %>%
  summarise(total_books = n())

ggplot(by_year, aes(x = year, y = total_books)) +
  geom_line(color = "blue") +
  geom_point(size = 2) +
  labs(title = "Total Number of Books Rated Per Year", x = "Year", y = "Number of Books")

# 4. Publisher Analysis
book_publisher <- books %>%
  group_by(publisher) %>%
  summarise(book_count = n()) %>%
  filter(book_count >= 125) %>%  s
  arrange(desc(book_count)) %>%
  mutate(
    cum_counts = cumsum(book_count),
    rel_freq = book_count / sum(book_count),
    cum_freq = cumsum(rel_freq),
    publisher = factor(publisher, levels = publisher)
  )

# 5. Pareto Chart of Publishers
ggplot(book_publisher, aes(x = publisher, y = book_count)) +
  geom_bar(stat = "identity", fill = "cyan") +
  geom_line(aes(y = cum_counts), group = 1, color = "red") +  # Ogive (cumulative count)
  labs(title = "Book Counts (1990 - 2020)", x = "Publisher", y = "Number of Books") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Additional Visualization
top_authors <- books %>%
  group_by(author) %>%
  summarise(book_count = n()) %>%
  arrange(desc(book_count)) %>%
  head(10)

ggplot(top_authors, aes(x = reorder(author, book_count), y = book_count)) +
  geom_bar(stat = "identity", fill = "green") +
  coord_flip() +
  labs(title = "Top 10 Authors by Book Count", x = "Author", y = "Number of Books")

write.csv(books, "cleaned_books.csv", row.names = FALSE)
