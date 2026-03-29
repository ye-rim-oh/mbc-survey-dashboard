source("R/translations.R")
source("R/data_prep.R")
source("R/regression_analysis.R")

# Work from the cleaned wide table so every summary below uses the same cell-level means.
survey  <- load_survey_data()
df      <- survey$wide

# Rank items by their overall mean so the write-up has a simple baseline ordering.
q_means <- df |>
  dplyr::group_by(question_en) |>
  dplyr::summarise(mean = mean(mean_score), .groups = "drop") |>
  dplyr::arrange(dplyr::desc(mean))

cat("=== TOP 5 most agreed ===\n")
print(head(q_means, 5))
cat("\n=== BOTTOM 5 most disagreed ===\n")
print(tail(q_means, 5))

# Compare 70+ and 20s scores to surface the largest age gaps quickly.
gen_gap <- df |>
  dplyr::filter(age_en %in% c("20s", "70+")) |>
  dplyr::group_by(question_en, age_en) |>
  dplyr::summarise(mean = mean(mean_score), .groups = "drop") |>
  tidyr::pivot_wider(names_from = age_en, values_from = mean) |>
  dplyr::mutate(gap = `70+` - `20s`) |>
  dplyr::arrange(dplyr::desc(abs(gap)))

cat("\n=== TOP 8 generational gaps (70+ - 20s) ===\n")
print(head(gen_gap, 8))

# Pool across ages here so the first gender pass is about the broad gap, not age-specific splits.
gender_gap <- df |>
  dplyr::group_by(question_en, gender_en) |>
  dplyr::summarise(mean = mean(mean_score), .groups = "drop") |>
  tidyr::pivot_wider(names_from = gender_en, values_from = mean) |>
  dplyr::mutate(gap = Male - Female) |>
  dplyr::arrange(dplyr::desc(abs(gap)))

cat("\n=== TOP 8 gender gaps (M - F) ===\n")
print(head(gender_gap, 8))

# Print the top items for each group because those short profiles are easier to cite in prose.
cat("\n=== GROUP PROFILES (top 3 by mean_score) ===\n")
for (age in c("20s","30s","40s","50s","60s","70+")) {
  for (gen in c("Male","Female")) {
    top3 <- df |>
      dplyr::filter(age_en == age, gender_en == gen) |>
      dplyr::arrange(dplyr::desc(mean_score)) |>
      dplyr::select(question_en, mean_score) |>
      head(3)
    cat(age, gen, ":\n")
    print(top3)
  }
}

# Build theme indices and a small set of fitted profiles so the narrative can move beyond item-by-item description.
index_scores <- build_index_scores(df)
model_results <- fit_index_models(index_scores)
profile_results <- predict_index_profiles(index_scores)

cat("\n=== INDEX SCORES (theme averages) ===\n")
print(index_scores)

cat("\n=== DESCRIPTIVE REGRESSIONS ===\n")
print(model_results)

cat("\n=== REGRESSION-IMPLIED PROFILES ===\n")
print(profile_results)
