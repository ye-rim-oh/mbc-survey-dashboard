rsconnect::deployApp(
  appDir   = ".",
  appFiles = c("app.R", "MBCsurvey_scraped.csv",
               "R/data_prep.R", "R/plot_functions.R", "R/translations.R",
               "www/styles.css"),
  forceUpdate = TRUE
)
