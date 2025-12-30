# Cognitive Aging Study: Race, Education, and Health Insurance as Mediators

Research project on mediation analysis of race and cognitive function in older adults.

## Dataset

The dataset `aging_cohort_data.csv` contains the following variables:

- `participant_id`: unique identifier
- `age`: age in years
- `race`: categorical (White, Black, Hispanic, Other)
- `total_cognition_score`: continuous measure of cognitive functioning
- `years_of_education`: years of formal education
- `has_health_insurance`: binary (0 = No, 1 = Yes)

## Analysis Scripts

### 1. Initial Analysis (`initial_analysis.R`)

This script performs a simple linear regression of cognitive score on race and age. It serves as a baseline model.

To run:
```r
source("analysis/initial_analysis.R")
```

### 2. Mediation Analysis (`mediation_analysis.R`)

This script conducts a formal mediation analysis to examine the extent to which education and health insurance mediate the relationship between race and cognitive functioning.

Two separate mediation models are estimated:

- **Education mediation**: years of education as a continuous mediator.
- **Health insurance mediation**: health insurance status as a binary mediator.

The analysis uses the `mediation` package in R, with bootstrapping (1000 simulations) to compute confidence intervals for the Average Causal Mediation Effect (ACME), Average Direct Effect (ADE), and proportion mediated.

To run:
```r
source("analysis/mediation_analysis.R")
```

**Outputs**:
- Console summary of ACME, ADE, total effect, and proportion mediated.
- A PDF path diagram (`mediation_paths.pdf`) visualizing the mediation pathways.
- CSV files with numerical results (`mediation_education_results.csv`, `mediation_insurance_results.csv`).

## Results Interpretation

Initial results from the mediation analysis suggest:

- **Education** accounts for approximately X% of the total effect of race on cognition.
- **Health insurance** accounts for approximately Y% of the total effect.

These findings highlight the importance of socioeconomic and access-to-care factors in explaining racial disparities in cognitive aging.

## Requirements

- R (>= 4.0)
- R packages: `tidyverse`, `mediation`, `broom`

Install missing packages with:
```r
install.packages(c("tidyverse", "mediation", "broom"))
```

## Repository Structure

```
cognitive-aging-study/
├── data/
│   └── aging_cohort_data.csv
├── analysis/
│   ├── initial_analysis.R
│   └── mediation_analysis.R
├── README.md
└── .gitignore
```

## Contributing

Please open an issue to discuss proposed changes. Follow the standard GitHub workflow: fork, branch, pull request.