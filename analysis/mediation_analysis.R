# Mediation analysis: Race -> Education/Health Insurance -> Cognitive Function
# Using the mediation package

# Load required packages
library(tidyverse)
library(mediation)
library(broom)

# Load data
data <- read.csv("data/aging_cohort_data.csv")

# Clean and prepare variables
data$race <- factor(data$race, levels = c("White", "Black", "Hispanic", "Other"))
data$has_health_insurance <- factor(data$has_health_insurance, levels = c(0, 1), labels = c("No", "Yes"))

# For convenience, create a numeric race indicator (White as reference)
data$race_numeric <- as.numeric(data$race) - 1  # White = 0, Black = 1, Hispanic = 2, Other = 3

# ----------------------------------------------------------------------------
# 1. Mediation via Years of Education (continuous mediator)
# ----------------------------------------------------------------------------

# Step 1: Model for mediator (education ~ race + age)
med_model_edu <- lm(years_of_education ~ race + age, data = data)

# Step 2: Model for outcome (cognition ~ education + race + age)
out_model_edu <- lm(total_cognition_score ~ years_of_education + race + age, data = data)

# Step 3: Mediation analysis with bootstrapping
set.seed(123)  # for reproducibility
med_result_edu <- mediate(
  model.m = med_model_edu,
  model.y = out_model_edu,
  treat = "race",  # categorical treatment
  mediator = "years_of_education",
  boot = TRUE,
  sims = 1000,
  treat.value = "White",
  control.value = "Black"  # compare Black vs White
)

# Summary of results
cat("\n=== Mediation via Years of Education (Black vs White) ===\n")
print(summary(med_result_edu))

# ----------------------------------------------------------------------------
# 2. Mediation via Health Insurance (binary mediator)
# ----------------------------------------------------------------------------

# Model for binary mediator (logistic regression)
med_model_ins <- glm(has_health_insurance ~ race + age, 
                     family = binomial(link = "logit"), 
                     data = data)

# Outcome model (cognition ~ insurance + race + age)
out_model_ins <- lm(total_cognition_score ~ has_health_insurance + race + age, data = data)

# Mediation analysis for binary mediator
set.seed(123)
med_result_ins <- mediate(
  model.m = med_model_ins,
  model.y = out_model_ins,
  treat = "race",
  mediator = "has_health_insurance",
  boot = TRUE,
  sims = 1000,
  treat.value = "White",
  control.value = "Black"
)

cat("\n=== Mediation via Health Insurance (Black vs White) ===\n")
print(summary(med_result_ins))

# ----------------------------------------------------------------------------
# 3. Combined visualization (simple path diagram)
# ----------------------------------------------------------------------------

# Create a simple path diagram using base R plotting
pdf("analysis/mediation_paths.pdf", width = 8, height = 5)
par(mfrow = c(1, 2))

# Education mediation plot
plot(med_result_edu, main = "Mediation via Education")

# Insurance mediation plot
plot(med_result_ins, main = "Mediation via Health Insurance")

dev.off()

cat("\nPath diagram saved to 'analysis/mediation_paths.pdf'\n")

# ----------------------------------------------------------------------------
# 4. Export results to CSV for reporting
# ----------------------------------------------------------------------------

results_edu <- data.frame(
  Effect = c("ACME", "ADE", "Total Effect", "Prop. Mediated"),
  Estimate = c(med_result_edu$d0, med_result_edu$z0, med_result_edu$tau.coef, med_result_edu$n0),
  CI_lower = c(med_result_edu$d0.ci[1], med_result_edu$z0.ci[1], med_result_edu$tau.ci[1], med_result_edu$n0.ci[1]),
  CI_upper = c(med_result_edu$d0.ci[2], med_result_edu$z0.ci[2], med_result_edu$tau.ci[2], med_result_edu$n0.ci[2])
)

results_ins <- data.frame(
  Effect = c("ACME", "ADE", "Total Effect", "Prop. Mediated"),
  Estimate = c(med_result_ins$d0, med_result_ins$z0, med_result_ins$tau.coef, med_result_ins$n0),
  CI_lower = c(med_result_ins$d0.ci[1], med_result_ins$z0.ci[1], med_result_ins$tau.ci[1], med_result_ins$n0.ci[1]),
  CI_upper = c(med_result_ins$d0.ci[2], med_result_ins$z0.ci[2], med_result_ins$tau.ci[2], med_result_ins$n0.ci[2])
)

write.csv(results_edu, "analysis/mediation_education_results.csv", row.names = FALSE)
write.csv(results_ins, "analysis/mediation_insurance_results.csv", row.names = FALSE)

cat("\nResults saved to CSV files in 'analysis/' directory.\n")