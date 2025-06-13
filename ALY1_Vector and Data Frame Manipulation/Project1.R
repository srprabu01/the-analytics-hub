# Elenchezhian_Project1.R
# Name: [Sri Ram Prabu]
# Date: [01/17/2025]
# Class: [ALY_6000]

# Problem 1
123 * 453
5^2 * 40
TRUE & FALSE
TRUE | FALSE
75 %% 10
75 / 10

# Problem 2
first_vector <- c(17, 12, -33, 5)

# Problem 3
counting_by_fives <- c(5, 10, 15, 20, 25, 30, 35)

# Problem 4
second_vector <- 20:1

# Problem 5
counting_vector <- 5:15

# Problem 6
grades <- c(96, 100, 85, 92, 81, 72)

# Problem 7
bonus_points_added <- grades + 3

# Problem 8
one_to_one_hundred <- 1:100

# Problem 9
# Adding 20 to each element of second_vector
second_vector + 20
# Multiplying each element of second_vector by 20
second_vector * 20
# Checking if elements of second_vector are greater than or equal to 20
second_vector >= 20
# Checking if elements of second_vector are not equal to 20
second_vector != 20

# Problem 10
total <- sum(one_to_one_hundred)

# Problem 11
average_value <- mean(one_to_one_hundred)

# Problem 12
median_value <- median(one_to_one_hundred)

# Problem 13
max_value <- max(one_to_one_hundred)

# Problem 14
min_value <- min(one_to_one_hundred)

# Problem 15
first_value <- second_vector[1]

# Problem 16
first_three_values <- second_vector[1:3]

# Problem 17
vector_from_brackets <- second_vector[c(1, 5, 10, 11)]

# Problem 18
vector_from_boolean_brackets <- first_vector[c(FALSE, TRUE, FALSE, TRUE)]
# Explanation: Extracts elements where the corresponding boolean value is TRUE.

# Problem 19
# Comparing each element of second_vector to see if it is greater than or equal to 10.
second_vector >= 10

# Problem 20
# Extracting elements of one_to_one_hundred greater than or equal to 20.
one_to_one_hundred[one_to_one_hundred >= 20]

# Problem 21
lowest_grades_removed <- grades[grades > 85]

# Problem 22
middle_grades_removed <- grades[-c(3, 4)]

# Problem 23
fifth_vector <- second_vector[-c(5, 10)]

# Problem 24
set.seed(5)
random_vector <- runif(n=10, min=0, max=1000)

# Problem 25
sum_vector <- sum(random_vector)

# Problem 26
cumsum_vector <- cumsum(random_vector)

# Problem 27
mean_vector <- mean(random_vector)

# Problem 28
sd_vector <- sd(random_vector)

# Problem 29
round_vector <- round(random_vector)

# Problem 30
sort_vector <- sort(random_vector)

# Problem 31
first_dataframe <- read.csv("ds_salaries.csv")

# Problem 32
summary(first_dataframe)

