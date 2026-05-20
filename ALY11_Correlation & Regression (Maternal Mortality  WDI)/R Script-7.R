# Module 5 - Week 5(Rscript)

library(tidyverse)
library(WDI)
library(corrplot)
library(stargazer)
library(ggthemes) # Load for theme_clean()


# DATA ACQUISITION AND PREP
indicators <- c(
  maternal_mortality = "SH.STA.MMRT",
  fertility_rate = "SP.DYN.TFRT.IN",
  health_exp_per_cap = "SH.XPD.CHEX.PC.CD",
  gdp_per_capita = "NY.GDP.PCAP.CD"
)

wdi_data <- WDI(
  country = "all", indicator = indicators,
  start = 2017, end = 2017, extra = TRUE
)

# Clean the data and rename for readability.
cleaned_data <- wdi_data %>%
  filter(region != "Aggregates") %>%
  select(country, region, maternal_mortality, fertility_rate, health_exp_per_cap, gdp_per_capita) %>%
  na.omit() %>%
  rename(
    "Maternal Mortality Ratio" = maternal_mortality,
    "Fertility Rate" = fertility_rate,
    "Health Exp. (per Capita)" = health_exp_per_cap,
    "GDP (per Capita)" = gdp_per_capita
  )


# EDA
# Visualize Variable Distributions with Histograms

cleaned_data %>%
  select(-country, -region) %>%
  pivot_longer(cols = everything(), names_to = "indicator", values_to = "value") %>%
  ggplot(aes(x = value)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "steelblue", alpha = 0.8) +
  geom_density(color = "red") +
  facet_wrap(~indicator, scales = "free") +
  labs(
    title = "Distributions of Key Development Indicators",
    subtitle = "All variables exhibit significant right-skew, justifying log transformation",
    x = "Value",
    y = "Density"
  ) +
  theme_minimal()
ggsave("variable_distributions.png", width = 8, height = 6)


# Visualize Key Relationships with Scatter Plots

# Scatter Plot: Maternal Mortality vs. GDP per Capita
ggplot(cleaned_data, aes(x = `GDP (per Capita)`, y = `Maternal Mortality Ratio`)) +
  geom_point(aes(color = region), alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  scale_x_log10(labels = scales::dollar) + # Use log scale and format labels
  scale_y_log10() +
  labs(
    title = "Wealthier Countries Have Lower Maternal Mortality",
    subtitle = "Relationship between Maternal Mortality Ratio and GDP per Capita (2017)",
    x = "GDP per Capita (Log Scale)",
    y = "Maternal Mortality Ratio (Log Scale)",
    color = "Region"
  ) +
  theme_minimal()
ggsave("scatter_mmr_vs_gdp.png", width = 8, height = 6)

# Scatter Plot: Maternal Mortality vs. Fertility Rate
ggplot(cleaned_data, aes(x = `Fertility Rate`, y = `Maternal Mortality Ratio`)) +
  geom_point(aes(color = region), alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    title = "Higher Fertility is Associated with Higher Maternal Mortality",
    subtitle = "Relationship between Maternal Mortality Ratio and Fertility Rate (2017)",
    x = "Fertility Rate (Log Scale)",
    y = "Maternal Mortality Ratio (Log Scale)",
    color = "Region"
  ) +
  theme_minimal()
ggsave("scatter_mmr_vs_fertility.png", width = 8, height = 6)


# CORRELATION ANALYSIS
cor_matrix <- cor(cleaned_data %>% select(-country, -region))
png("correlation_chart.png", width = 800, height = 800, res = 100)
corrplot(cor_matrix,
         method = "color", type = "upper", order = "hclust",
         addCoef.col = "black", tl.col = "black", tl.srt = 45,
         diag = FALSE,
         title = "Correlation Matrix of Development Indicators (2017)",
         mar = c(0,0,1,0))
dev.off()


# REGRESSION ANALYSIS
regression_model <- lm(log(`Maternal Mortality Ratio`) ~ log(`Fertility Rate`) + log(`Health Exp. (per Capita)`) + log(`GDP (per Capita)`),
                       data = cleaned_data)


# REGRESSION DIAGNOSTICS 
# This plot panel checks for linearity, normality of residuals, and homoscedasticity.
png("regression_diagnostics.png", width = 1000, height = 1000, res = 120)
par(mfrow = c(2, 2)) # Set up a 2x2 plotting space
plot(regression_model) # Generate the four default diagnostic plots
par(mfrow = c(1, 1)) # Reset plotting space to default
dev.off()


# EXPORT REGRESSION TABLE
stargazer(regression_model,
          type = "html",
          out = "regression_table.html",
          title = "OLS Regression: Predictors of Maternal Mortality Ratio",
          dep.var.labels = "Log(Maternal Mortality Ratio)",
          covariate.labels = c("Log(Fertility Rate)", "Log(Health Exp. per Capita)", "Log(GDP per Capita)"),
          align = TRUE,
          ci = TRUE,
          p.auto = TRUE,
          report = "vcsp",
          notes = "Data source: World Bank (2017). N=139 countries. All variables are log-transformed.",
          notes.align = "l")

# The script now produces the following set of outputs:
# - variable_distributions.png (Histogram panel)
# - scatter_mmr_vs_gdp.png (Scatter plot)
# - scatter_mmr_vs_fertility.png (Scatter plot)
# - correlation_chart.png (Correlation matrix plot)
# - regression_diagnostics.png (Model assumption checks)
# - regression_table.html (Formatted regression results)