# Prepare the survey once so analysis scripts and charts do not clean the same file differently.

source("R/translations.R")

# Override the oldest age label in derived outputs so all displays read "70+"
# rather than the less precise decade label.
age_order <- c("20s", "30s", "40s", "50s", "60s", "70+")

# Return one wide table for summaries and one long table for charts from the same cleaned source.
load_survey_data <- function() {
  df <- readr::read_csv(
    "MBCsurvey.csv",
    locale = readr::locale(encoding = "UTF-8"),
    show_col_types = FALSE
  )

  # Rename columns once so the rest of the project can rely on a stable schema.
  names(df) <- c("question_kr", "age_kr", "gender", "pct_sd", "pct_d",
                 "pct_n", "pct_a", "pct_sa", "drop_col")
  df <- dplyr::select(df, -drop_col)

  # Translate labels here so downstream code can stay in one language.
  df$question_en <- question_en[df$question_kr]
  df$age_en      <- age_en[df$age_kr]
  df$gender_en   <- gender_en[df$gender]

  # Fall back to the source label so unmatched rows are still usable.
  df$question_en <- ifelse(is.na(df$question_en), df$question_kr, df$question_en)
  df$age_en      <- ifelse(is.na(df$age_en),      df$age_kr,      df$age_en)
  df$age_en      <- ifelse(df$age_en == "70s", "70+", df$age_en)

  # Set the age order now so plots do not sort groups alphabetically.
  df$age_en <- factor(df$age_en, levels = age_order)

  # Rescale each row first because the raw percentages are the input to every later score.
  total <- df$pct_sd + df$pct_d + df$pct_n + df$pct_a + df$pct_sa
  df$raw_total_pct <- total
  response_cols <- c("pct_sd", "pct_d", "pct_n", "pct_a", "pct_sa")
  df[response_cols] <- lapply(df[response_cols], function(x) x / total * 100)
  df$mean_score <- (1 * df$pct_sd + 2 * df$pct_d + 3 * df$pct_n +
                    4 * df$pct_a + 5 * df$pct_sa) / 100

  # Pivot to long form once so every distribution chart can reuse the same structure.
  df_long <- tidyr::pivot_longer(
    df,
    cols      = c(pct_sd, pct_d, pct_n, pct_a, pct_sa),
    names_to  = "response_code",
    values_to = "pct"
  )
  df_long$response <- dplyr::recode(df_long$response_code,
    pct_sd = "Strongly Disagree",
    pct_d  = "Disagree",
    pct_n  = "Neutral",
    pct_a  = "Agree",
    pct_sa = "Strongly Agree"
  )
  df_long$response <- factor(df_long$response, levels = likert_order)

  list(wide = df, long = df_long)
}
