# R/data_prep.R

source("R/translations.R")

load_survey_data <- function() {
  df <- readr::read_csv(
    "MBCsurvey.csv",
    locale = readr::locale(encoding = "UTF-8"),
    show_col_types = FALSE
  )

  # Standardise column names
  names(df) <- c("question_kr", "age_kr", "gender", "pct_sd", "pct_d",
                 "pct_n", "pct_a", "pct_sa", "keyword_kr")

  # Translate labels
  df$question_en <- question_en[df$question_kr]
  df$keyword_en  <- keyword_en[df$keyword_kr]
  df$age_en      <- age_en[df$age_kr]
  df$gender_en   <- gender_en[df$gender]

  # Fallback: keep Korean if translation is missing
  df$question_en <- ifelse(is.na(df$question_en), df$question_kr, df$question_en)
  df$keyword_en  <- ifelse(is.na(df$keyword_en),  df$keyword_kr,  df$keyword_en)
  df$age_en      <- ifelse(is.na(df$age_en),      df$age_kr,      df$age_en)

  # Ordered factor for age
  df$age_en <- factor(df$age_en, levels = age_order)

  # Weighted mean score (1=Strongly Disagree … 5=Strongly Agree)
  total <- df$pct_sd + df$pct_d + df$pct_n + df$pct_a + df$pct_sa
  df$mean_score <- (1*df$pct_sd + 2*df$pct_d + 3*df$pct_n +
                    4*df$pct_a + 5*df$pct_sa) / total

  # Long-form response percentages (for stacked/grouped bar charts)
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
