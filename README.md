# MBC Survey 2025: What Is Your "Political Blood Type"?

An interactive Shiny dashboard and companion analysis of South Korean social values across age groups and genders, based on MBC's Political Blood Type quiz response data.

**Live app:** https://z25die-0-0.shinyapps.io/mbc-survey-dashboard/

---

## Data

`MBCsurvey.csv` contains 432 grouped observations:

- 36 survey questions
- 6 age groups (`20s`, `30s`, `40s`, `50s`, `60s`, `70+`)
- 2 gender groups (`Male`, `Female`)

Each row stores the response distribution for one `question x age x gender` cell on a five-point Likert scale.

| Column | Description |
|--------|-------------|
| `question_kr` | Original Korean survey question |
| `age_kr` | Original Korean age label |
| `gender` | Raw gender label in the source file |
| `pct_sd` to `pct_sa` | Response shares from strongly disagree to strongly agree |

The analysis scripts rescale each row to sum to 100 and compute weighted mean scores on a 1-5 scale:

- `1` = Strongly Disagree
- `3` = Neutral
- `5` = Strongly Agree

Because the repository contains grouped cells rather than respondent-level microdata, all regression outputs are descriptive summaries of age-by-gender patterns.

---

## Dashboard

The deployed app presents one question at a time through two linked views:

- A stacked bar chart showing the full response distribution by age and gender
- A grouped bar chart showing weighted mean scores by age and gender

Users can:

- Select a question from the full translated item list
- Filter the display by age group
- Filter the display by gender

The app uses one shared cleaned dataset so the charts and the written analysis stay aligned in wording and scores.

---

## Analysis

The repository also includes a narrative write-up and supporting R scripts:

- `analysis.md`: written interpretation of the dataset
- `R/regression_analysis.R`: theme construction and descriptive regressions
- `_analysis_data.R`: reproducible summary output used to check the write-up
- `tests/test_regression_analysis.R`: smoke test for the regression pipeline

The current descriptive regression section uses five indices:

- Traditional family norms
- Gender inequality skepticism
- Procedural fairness
- Authoritarian order
- Alienation

---

## Project Structure

```text
app.R
MBCsurvey.csv
analysis.md
_analysis_data.R
_deploy.R
R/
  data_prep.R
  plot_functions.R
  regression_analysis.R
  translations.R
tests/
  test_regression_analysis.R
www/
  styles.css
```

---

## Run Locally

```r
install.packages(c(
  "shiny", "bslib", "readr", "dplyr", "tidyr",
  "ggplot2", "plotly"
))

shiny::runApp()
```

To regenerate the descriptive analysis outputs:

```bash
Rscript _analysis_data.R
```

To run the regression smoke test:

```bash
Rscript tests/test_regression_analysis.R
```
