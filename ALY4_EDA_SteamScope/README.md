# 🎮 **SteamScope: Deep Dive into Steam Game Trends**

> *Uncovering patterns in 🏷️ game pricing strategies, ⏱️ player engagement via playtime, 🧠 user sentiment through reviews, and 🎮 genre and category trends through data science.*

---

## 📊 Overview

**SteamScope** is an exploratory data analysis (EDA) project that investigates the **Steam games ecosystem** using a comprehensive dataset of over 97,000 games. This project leverages data cleaning, feature engineering, and visualization techniques to extract meaningful insights into:

- Game pricing strategies
- Player engagement via playtime
- User sentiment through reviews
- Genre and category trends

---

## 🧠 Objectives

- Understand trends in game pricing and accessibility.
- Segment games by engagement levels and price tiers.
- Analyze the relationship between price, playtime, and sentiment.
- Identify genre popularity and its influence on user satisfaction.

---

## 🗃️ Dataset

- **Source:** Kaggle, Steam API, and third-party providers  
- **Size:** ~97,000 games  
- **Key Fields:**
  - `Name`, `Release Date`, `Price`, `Playtime`, `User Reviews`, `Genres`

---

## 🧹 Data Cleaning

- Converted date fields to datetime format
- Removed columns with >60% missing data
- Standardized column names (no spaces/special chars)
- Converted price/playtime to numeric for analysis

---

## ⚙️ Feature Engineering

| Feature            | Description                                                             |
|--------------------|-------------------------------------------------------------------------|
| `Price Category`   | Grouped into: Free, Low, Mid, High                                      |
| `Playtime Category`| Segmented into: No Engagement, Casual, Moderate, Highly Engaged         |
| `Sentiment Score`  | Calculated as % of positive user reviews                                |

---

## 📈 Exploratory Data Analysis (EDA)

- Distribution analysis of **price** and **playtime**
- **Genre frequency** and popularity trends
- Correlation plots between **price ↔️ playtime**, and **reviews ↔️ engagement**
- Visualizations of **sentiment scores** across game types

---

## 🖼️ Visualizations

Included:
- Box plots and histograms
- Heatmaps
- Genre-wise bar charts
- Sentiment trend lines

(See `/visuals/` or notebook for outputs)

---

## 🧠 Key Insights

- **Free and low-cost games dominate** the market, making gaming accessible to a wide audience.
- **Indie and casual genres** are the most prevalent.
- **Multiplayer games show higher engagement**, hinting at the importance of social gaming.
- Games with **frequent updates and positive sentiment** maintain better player retention.

---

## 📚 References

- Kaggle Steam Dataset: [link](https://www.kaggle.com/)
- R Project: [r-project.org](https://www.r-project.org/)
- Data.gov: [data.gov](https://www.data.gov/)
- "An Introduction to Statistical Learning" by James et al.
- "Applied Predictive Modeling" by Kuhn & Johnson

---

## 🧪 Tools Used

- `R` for statistical analysis and visualization
- `ggplot2`, `dplyr`, `tidyverse` for EDA
- `Gamma.app` for presentation design

---

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/steamscope-analysis.git
   ```
2. Open the R script or notebook.
3. Install dependencies (listed in `requirements.R` or mentioned in script).
4. Run the EDA section and explore the insights!

---

## 📬 Contact

**Sri Ram Prabu Elenchezhian**  
*Connect with me via [LinkedIn](https://www.linkedin.com/) or email*
