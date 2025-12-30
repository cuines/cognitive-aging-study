# Initial analysis: relationship between race and cognitive scores
# Dataset: aging_cohort_data.csv

# Load required packages
library(tidyverse)

# Load data
data <- read.csv("data/aging_cohort_data.csv")

# Inspect structure
str(data)
summary(data)

# Clean data: convert race to factor, check missing values
data$race <- factor(data$race, levels = c("White", "Black", "Hispanic", "Other"))
data$has_health_insurance <- factor(data$has_health_insurance, levels = c(0, 1), labels = c("No", "Yes"))

# Simple linear regression: cognition ~ race + age
model <- lm(total_cognition_score ~ race + age, data = data)

# Model summary
summary(model)

# Print coefficients
cat("\n--- Regression Coefficients ---\n")
print(coef(model))

# Optional: plot residuals
# pdf("analysis/residuals_plot.pdf")
# plot(model, which = 1)
# dev.off()