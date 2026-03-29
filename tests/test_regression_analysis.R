source("R/translations.R")
source("R/data_prep.R")
source("R/regression_analysis.R")

# Smoke-test the descriptive regression pipeline end to end:
# 1. load grouped survey data
# 2. build five thematic indices
# 3. verify expected dimensions
# 4. fit one regression per index
survey <- load_survey_data()
index_scores <- build_index_scores(survey$wide)

stopifnot(
  nrow(index_scores) == 60,
  length(unique(index_scores$index_name)) == 5,
  all(c("index_name", "age_en", "gender_en", "index_score", "age_mid", "female") %in% names(index_scores))
)

index_counts <- table(index_scores$index_name)
# Each of the five indices should have one row for every age-by-gender cell:
# 6 age groups x 2 genders = 12 rows per index.
stopifnot(all(index_counts == 12))

model_results <- fit_index_models(index_scores)
stopifnot(
  nrow(model_results) == 20,
  all(c("index_name", "term", "estimate") %in% names(model_results))
)

cat("Regression analysis tests passed.\n")
