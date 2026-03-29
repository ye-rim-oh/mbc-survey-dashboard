# Keep the descriptive modeling code separate from the dashboard so analysis choices are explicit.
# These functions work on age-by-gender cell means, so they are for broad grouped patterns, not individual-level claims.

# Define the index membership here so every model uses the same thematic grouping.
# `reverse` keeps higher values pointing in the same conceptual direction before averaging.
default_index_spec <- function() {
  data.frame(
    index_name = c(
      rep("Traditional family norms", 3),
      rep("Gender inequality skepticism", 2),
      rep("Procedural fairness", 3),
      rep("Authoritarian order", 3),
      rep("Alienation", 3)
    ),
    question_en = c(
      "Having children is a social obligation",
      "Work is fine, but women should prioritize family and children",
      "Children suffer when mothers work",
      "The gender wage gap has legitimate reasons",
      "A law banning discrimination based on sex, disability, medical history, age, religion, and sexual orientation should be enacted",
      "Fair treatment should be the first principle of legislation",
      "Equal treatment for all people is important",
      "It is important to protect the vulnerable and treat everyone fairly, even people I don't know",
      "We need a strong leader to suppress the extremism that is ruining our country",
      "Adolescents need more discipline",
      "It feels good when wrongdoers are caught and punished",
      "I think society needs to completely collapse",
      "I sometimes imagine most of humanity disappearing, leaving only a few to start over",
      "I sometimes feel the urge to destroy beautiful things"
    ),
    reverse = c(
      FALSE, FALSE, FALSE,
      FALSE, TRUE,
      FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE
    ),
    stringsAsFactors = FALSE
  )
}

# Collapse item means to index means so the models operate on comparable theme-level scores.
build_index_scores <- function(df_wide, index_spec = default_index_spec()) {
  age_map <- c("20s" = 20, "30s" = 30, "40s" = 40, "50s" = 50, "60s" = 60, "70+" = 70)
  index_levels <- unique(index_spec$index_name)
  available_questions <- unique(df_wide$question_en)
  missing_questions <- setdiff(index_spec$question_en, available_questions)

  if (length(missing_questions) > 0) {
    stop(
      paste(
        "Index questions missing from survey data:",
        paste(missing_questions, collapse = "; ")
      )
    )
  }

  df_wide |>
    dplyr::filter(question_en %in% index_spec$question_en) |>
    dplyr::inner_join(index_spec, by = "question_en") |>
    dplyr::mutate(
      # Lock the index order now so tables and profile outputs do not reshuffle later.
      index_name = factor(index_name, levels = index_levels),
      # Convert grouped ages to numeric midpoints so one linear age term is possible.
      age_mid = unname(age_map[as.character(age_en)]),
      # Center age at the 20s so the intercept reads as the youngest male baseline.
      age_step = (age_mid - 20) / 10,
      # The grouped data only distinguish Male/Female cells, so one indicator is enough here.
      female = ifelse(gender_en == "Female", 1, 0),
      # Reverse-code flagged items before averaging so the index does not mix opposite directions.
      item_score = ifelse(reverse, 6 - mean_score, mean_score)
    ) |>
    dplyr::group_by(index_name, age_en, gender_en, age_mid, age_step, female) |>
    dplyr::summarise(
      # Average within index after alignment so each theme becomes one comparable score.
      index_score = mean(item_score),
      question_count = dplyr::n(),
      .groups = "drop"
    ) |>
    dplyr::arrange(index_name, age_mid, female)
}

# Fit one simple model per index so the text can summarize age, gender, and their interaction in the same frame.
# The parameterization is chosen for prose readability: baseline = 20s men, `age_step` = male age slope,
# `female` = female gap in the 20s, and the interaction = difference in that slope.
fit_index_models <- function(index_scores) {
  split(index_scores, index_scores$index_name) |>
    lapply(function(dat) {
      # Each fit uses the 12 aggregated age-by-gender cells available for one index.
      model <- stats::lm(index_score ~ age_step * female, data = dat)
      coefs <- as.data.frame(summary(model)$coefficients)
      coefs$term <- rownames(coefs)
      rownames(coefs) <- NULL
      coefs$index_name <- as.character(dat$index_name[[1]])
      names(coefs) <- c("estimate", "std_error", "statistic", "p_value", "term", "index_name")
      coefs[, c("index_name", "term", "estimate", "std_error", "statistic", "p_value")]
    }) |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      term = dplyr::recode(
        term,
        "(Intercept)" = "20s male baseline",
        "age_step" = "Male age slope (per decade)",
        "female" = "Female gap in 20s",
        "age_step:female" = "Female age-slope difference"
      )
    )
}

# Predict four reference groups so the write-up can report a small, readable set of comparisons.
# These are fitted values rather than raw cell means.
predict_index_profiles <- function(index_scores) {
  profile_grid <- data.frame(
    age_mid = c(20, 20, 70, 70),
    female = c(0, 1, 0, 1),
    stringsAsFactors = FALSE
  )

  split(index_scores, index_scores$index_name) |>
    lapply(function(dat) {
      model <- stats::lm(index_score ~ age_step * female, data = dat)
      profile_data <- profile_grid
      # Reuse the estimation transform so predictions stay on the same scale as the model.
      profile_data$age_step <- (profile_data$age_mid - 20) / 10
      profile_data$predicted_score <- as.numeric(stats::predict(model, newdata = profile_data))
      profile_data$index_name <- as.character(dat$index_name[[1]])
      profile_data$group <- c("20s Male", "20s Female", "70+ Male", "70+ Female")
      profile_data[, c("index_name", "group", "age_mid", "female", "predicted_score")]
    }) |>
    dplyr::bind_rows() |>
    dplyr::mutate(index_name = factor(index_name, levels = unique(index_scores$index_name)))
}
