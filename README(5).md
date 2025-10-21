# Steam Games Analytics — Discussions & Insights
[![Made with R](https://img.shields.io/badge/Made%20with-R-276DC3.svg)](#) [![License](https://img.shields.io/badge/license-MIT-green.svg)](#)

This repository contains my discussion posts and reflections from a data analytics course,
centered around the **Steam Games Dataset**. It compiles prompts, approaches, and key takeaways
from Modules 1–6, along with references and any accompanying images exported from the original
document.

## Image Gallery

<p>
<img src="repo_assets/doc-image-01-c02c3de31c.png" alt="doc-image-01-c02c3de31c.png" width="420" />
<img src="repo_assets/doc-image-02-081350b565.png" alt="doc-image-02-081350b565.png" width="420" />
<img src="repo_assets/doc-image-03-9142d380ac.png" alt="doc-image-03-9142d380ac.png" width="420" />
<img src="repo_assets/doc-image-04-381372f9d4.png" alt="doc-image-04-381372f9d4.png" width="420" />
<img src="repo_assets/doc-image-05-04431a67cf.png" alt="doc-image-05-04431a67cf.png" width="420" />
</p>

## Table of Contents
- [Overview](#overview)
- [Assets](#assets)
- [References](#references)

## Overview

Module 1 | Discussion

Overview

In this discussion assignment, you will consider the composition of a data set. Asking business or research questions of a data set is often the first step in the data analysis process. How many observations are in the data set? What data is missing or in a format that might be difficult to analyze?  What are values that could be computed to provide additional insights?

Prompt

Locate a dataset on the internet. In an initial post, summarize the dataset and include all types of information it contains. Draft three questions you could use to investigate the dataset.

In two response posts, meaningfully engage with two of your peers’ initial posts by providing feedback on their chosen dataset and crafting additional questions that could be explored with their selected dataset.

I have selected the “Steam Games Dataset” from Kaggle. This dataset provides information about games available on the Steam platform.

Dataset Composition:

Number of Observations: 27,075 rows (games).

Number of Variables: 16 columns, a mix of numeric, categorical, and textual data:

Missing/Difficult Data:

Some games have missing values for Price or Ratings.

Tags and Languages are textual data that require preprocessing for analysis.

Extreme outliers in Average Playtime may need to be addressed.

Additional Computable Values:

Review Ratio: The proportion of positive to total reviews.

Cost per Hour: Price divided by average playtime to evaluate value for money.

Genre Popularity: Total reviews or average playtime per genre.

By investigating this dataset, we can uncover insights into consumer preferences, evaluate game performance trends, and identify factors that contribute to a successful game release on Steam.

What factors (e.g., price, genre, ratings) influence the popularity of games on Steam?

Which genres provide the best value for players in terms of cost per hour of gameplay?

How do user reviews differ between major publishers and indie developers?

Discussion Topic: Module 2

Overview

Reflection is an important aspect of all learning. In this discussion assignment, reflect on your experience with R thus far. What is working well? What challenges remain? Share resources that will help your peers as they develop competency in R.

Prompt

Consider the first two R projects you created for this course. List and describe three pressure points and three successes. In addition to course materials (textbooks, videos, and lessons), what outside resources did you locate and use to complete your work? How did those resources translate into your successes?

In two response posts, meaningfully engage with two of your peers’ initial posts by reviewing and commenting on the resources suggested and reflecting on the balance of class challenges and successes. What can you glean from others’ learning?

Three Pressure Points:

Data Manipulation: In the initial projects, I found it challenging to manipulate data efficiently using R, particularly when working with complex datasets. Functions like dplyr and tidyr can be powerful but require a good grasp of syntax and logical flow to transform the data correctly.

Debugging Errors: I am still facing challenges with understanding and resolving error messages, especially in loops or when combining different data types. R provides helpful messages, but sometimes the exact problem is not obvious without a deeper understanding of how R handles data.

Visualization: I struggled to create consistent and polished visualizations. Customizing and adjusting labels or scales takes time.

Three Successes:

Mastering Data Import: One success was becoming comfortable with importing various data formats CSV into R using functions like read.csv(). This fundamental step was key in building the foundation for further analysis.

Effective Use of Functions: By using built-in functions like summary(), mean(), and table(), I was able to quickly extract insights from data and summarize key statistics. This allowed me to perform basic exploratory data analysis (EDA) with ease.

Creating Visualizations: Despite initial challenges, I was able to create effective visualizations using ggplot2, learning how to layer elements.

Resources that helped me:

RStudio Cheat Sheets: The RStudio cheat sheets provide quick reference guides for common functions and packages which can be incredibly helpful when working through common tasks in R.

Stack Overflow: When stuck on an error or a problem, searching for answers on Stack Overflow helped. The R community on Stack Overflow is quite active, and many solutions have been posted there.

Chat GPT - It helped me with clarifications and doubts that I had. Also was an extensive tool used to debug error prompts.

Module 3 | Discussion

Overview

Good visualizations contain relevant, accurate, and accessible information that directly reflects key insights developed by the data analyst. Unfortunately, visualizations can also convey incorrect, misleading, or otherwise faulty information, or they can simply present information in a nonsensical way. In this discussion assignment, you will locate visualizations in external sources and evaluate their benefits and limitations.

Prompt

Visualizations can tell powerful stories. To better understand the difference between good and bad data visualizations, first consider the following resources:







  Next, locate two visualizations from external sources: One should represent the data clearly and compellingly, but the other should be less legible. Provide commentary on why each example falls into its category. To better understand the difference between good and bad data visualizations, consider the type of visualization, design decisions, accessibility, and clarity.

  In two response posts, meaningfully engage with two of your peers’ initial posts by adding your own insights to each of their selected and annotated visualizations and by offering specific commentary on how each visualization could be improved.

Storytelling with Visualizations ( Good vs. Bad Data Visualizations )

Good Data Visualization:

Example: A well-structured bar chart from a financial report showing quarterly revenue growth across different regions.

Why this is Effective:

Clear Labeling – The axes are properly labeled, and each bar represents a distinct region, making it easy to compare.

Consistent Scale – The y-axis follows a logical numerical progression, avoiding confusion.

Use of Color – Different colors distinguish regions, making it simple to understand and not confusing.

Minimal Clutter – No unnecessary grid-lines or excessive data points that hide the key data.

This visualization allows stakeholders to quickly grasp financial performance trends, aiding in decision-making.

Bad Data Visualization:

Example: A 3D pie chart showing budget allocation across different departments.

Why this chat is Problematic:

Misleading Perspective – The 3D effect distorts the size of the slices, making it difficult to compare proportions accurately.

Too Many Categories – With over 7 segments, the chart becomes cluttered and hard to interpret.

Poor Color Choices – Some sections have nearly identical colors, reducing readability.

No Clear Message – The visualization lacks a key takeaway, leaving viewers unsure of what insight they should gain.

A simple bar chart or a well-structured 2D pie chart would have communicated the budget distribution more effectively.

References:

Huddle, J. (n.d.). Data visualizations. Libraries: Indiana University Bloomington. https://guides.libraries.indiana.edu/dataviz/home

Sobieski, T. (2021, January 28). Bad data visualization: 5 examples of misleading data. Harvard Business School Online. https://online.hbs.edu/blog/post/bad-data-visualization

Discussion Topic: Module 4 | DiscussionModule 4 | Discussion

Overview

Every data analysis has a beginning, middle, and end, often resulting in a final report to a client, supervisor, or class instructor. The humble beginning is no less important than the final deliverable. In the context of data analysis, this stage includes looking at the dataset, beginning exploratory data analysis, and creating data questions you intend to answer. In this discussion assignment, you will start at the beginning and share your initial ideas about the dataset you have selected for your independent data analysis.

Prompt

Describe and link to the dataset you selected for your Module 4 project. Describe three data questions you hope to answer with this dataset. What approaches will you take? What visualizations might you produce?

In two response posts, meaningfully engage with two of your peers’ initial posts by doing the following:

Query their questions: What else could you ask of their dataset?

Brainstorm blindspots: What challenges might their dataset pose?

For my Module 4 Project, I have chosen a dataset of Steam Games, which contains information about over 97,000 games, including release dates, pricing, playtime, reviews, user ratings, and platform availability. The dataset was sourced from Kaggle (

) and includes structured and unstructured data, making it ideal for both exploratory data analysis (EDA) and predictive modeling.

What factors contribute most to a game's popularity?

Popularity will be measured by estimated owners and peak concurrent users (CCU).

I explored correlations between game ratings, price, genre, and playtime.

Approach: Use correlation analysis and regression modeling to identify key predictors.

Visualization: Heatmaps, scatter plots, and bar charts comparing features like price, reviews, and playtime.

How does pricing affect player engagement and reviews?

I wanted to analyze whether higher-priced games have more playtime or better reviews.

Approach: Compare free vs. paid games, group data by price range, and calculate average playtime and review counts.

Visualization: Boxplots for price vs. playtime, scatter plots for price vs. reviews.

Are there seasonal trends in game releases?

Do publishers release more games during specific months or holidays?

Approach: Extract release month and analyze trends over time.

Visualization: Line graphs and bar charts to show monthly game release trends.

References:

Kaggle. (n.d.). Steam Games Dataset. Retrieved from https://www.kaggle.com

Module 5 | Discussion

Overview

In last week's discussion, you shared the dataset you selected for your independent exploratory data analysis as well as your initial questions. For most data analysts, the primary challenge arises after the analysis is complete. Data in hand, analysts must clearly and concisely communicate the most interesting results to an audience with diverse background knowledge. This week, you will practice reporting on the results of your analysis.

Prompt

Report on the most interesting results from the Module 4 project. Be sure to reintroduce the dataset and all questions that you asked. Share at least three interesting results or conclusions. As appropriate, include data tables and graphs to illustrate your discussion.

In two response posts, meaningfully engage with two of your peers’ initial posts by reviewing and commenting on their analysis and sharing a visualization or graph from your work that might support your peer’s dataset and query.

For my Module 4 Project, I analyzed the Steam Games Dataset, which includes information on 97,000+ games. The dataset contains attributes such as release dates, pricing, playtime, reviews, ratings, platform availability, and estimated owners. The objective was to uncover key insights related to game popularity, pricing impact, and seasonal trends.

Questions I choose to explore

What factors contribute most to a game's popularity?

How does pricing affect player engagement and reviews?

Are there seasonal trends in game releases?

Key Findings & Visualizations

Factors Influencing Game Popularity

A strong positive correlation (r = 0.78) was found between Peak Concurrent Users (CCU) and Estimated Owners, meaning the more a game is played, the more likely it is widely owned.

Metacritic score and User score had weak correlations with popularity, suggesting that while reviews matter, other factors like marketing and genre may play a larger role.

Games in the "Action" and "RPG" genres tend to have the highest number of concurrent players.

Graph: Correlation Heatmap of Game Attributes
(Visualizes relationships between features like price, reviews, playtime, and popularity)

Price vs. Player Engagement & Reviews

Free-to-play games dominate engagement, with median playtime significantly higher than paid games.

Paid games ($10-$30 range) receive the most positive reviews, likely due to perceived value.

Scatter plots of price vs. reviews showed a downward trend, indicating that as game price increases, the number of reviews decreases.

Graph: Boxplot Comparing Free vs. Paid Game Playtime
(Highlights the difference in engagement levels for different pricing strategies)

Seasonal Trends in Game Releases

Most games are released in October and November, likely to align with holiday sales.

The fewest games are released in February, possibly due to post-holiday market cooldown.

Line graphs of releases by month over multiple years show an increasing trend in game releases since 2015, peaking in 2020 during the COVID-19 pandemic.

Graph: Monthly Game Release Trends
(Shows the peak months for new game launches)

Conclusions

Popularity is driven more by engagement metrics than reviews.

Price plays a role in review counts and engagement, but free games dominate playtime.

Seasonality affects release patterns, with major spikes in Q4 each year.

Refining the model can help explore advanced machine learning predictions for game success.

References:

Kaggle. (n.d.). Steam Games Dataset. Retrieved from https://www.kaggle.com/

R Project for Statistical Computing. (n.d.). CRAN - Comprehensive R Archive Network. Retrieved from 
https://www.r-project.org/

James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013). An Introduction to Statistical Learning: With 
Applications in R. Springer.

Discussion Topic: Module 6 | DiscussionModule 6 | Discussion

Overview

Congratulations on reaching the last few assignments of this course! While the learning journey is different for each individual, you may have experienced concrete growth in both knowledge and experience. As you prepare to submit your final project, take a moment to reflect on that journey and share lessons that could be of value to others.

Prompt

Summarize your experience in this course. Specifically, share three things that surprised you about the work of data analytics. And share one data analytics question you hope to explore in the future.

In two response posts, meaningfully engage with two of your peers’ initial posts by adding your own insights to their learning journey and responding to the question they posed.

As this course is nearly at its end, I have taken time to reflect on the challenges which i faced and how it impacted my growth. My experience so far throughout this course. This course has deepened my understanding of data-driven decision-making and has equipped me with practical skills in data manipulation, visualization, and analysis.

Surprising Insights About Data Analytics :

The Importance of Data Cleaning and Preprocessing:

One of the biggest surprises was realizing how much time and effort goes into cleaning and preparing data before actual analysis can begin. Handling missing values, transforming variables, and ensuring data consistency proved to be just as critical as the analysis itself.

Correlation Does Not Always Mean Causation:

Initially, I expected strong correlations to indicate direct causation. However, through regression modeling and statistical tests, I learned how misleading correlations can be without deeper context. This realization reinforced the importance of careful hypothesis testing and exploratory data analysis (EDA) to validate insights.

Visualization is Both an Art and a Science:

While I expected data visualization to be a technical skill, I was surprised by how much storytelling is involved. Creating effective visualizations requires careful selection of colors, axes, and chart types to communicate insights clearly. Poorly designed visuals can mislead an audience, making it crucial to apply best practices in data storytelling.

Question I Hope to Explore :

Looking ahead, I would love to explore how one can predict the price on stock/currencies/crypto based on historical data. Given my recent work with the Steam Games dataset, I am curious about developing a predictive model to estimate a true potential on how far data analysis and prediction would leap ahead.

This course has been an invaluable experience, and I look forward to learning more in future analytics Courses.


## References

- Kaggle. *Steam Games Dataset*. https://www.kaggle.com
- R Project for Statistical Computing (CRAN). https://www.r-project.org/
- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013). *An Introduction to Statistical Learning*.
- Huddle, J. *Data visualizations*. Indiana University Libraries.
- Sobieski, T. (2021). *Bad data visualization: 5 examples of misleading data*. HBS Online.
