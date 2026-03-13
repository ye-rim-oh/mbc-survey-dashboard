rsconnect::deployApp(
  appDir   = ".",
  appFiles = c("app.R", "MBCsurvey.csv",
               "R/data_prep.R", "R/plot_functions.R", "R/translations.R",
               "www/styles.css"),
  forceUpdate = TRUE
)
