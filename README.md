# MBC Survey 2025 — Social Values Dashboard

An interactive Shiny dashboard exploring South Korean social values across age groups and genders, based on MBC's 2025 survey data.

**Live app:** https://z25die-0-0.shinyapps.io/mbc-survey-dashboard/

---

## Data

`MBCsurvey.csv` — 432 rows (36 questions × 6 age groups × 2 genders)

| Column | Description |
|--------|-------------|
| 질문 | Survey question (Korean) |
| 연령대 | Age group: 20대–70대 |
| 성별 | Gender: M / W |
| 전혀 그렇지 않다 ~ 매우 그렇다 | 5-point Likert response percentages |
| 키워드 | Thematic category |

Each row contains the **percentage distribution** of responses for one question × age × gender cell. Scores are computed as weighted means on a 1–5 scale (1 = Strongly Disagree, 5 = Strongly Agree).

The 36 questions span 17 thematic categories including Meritocracy, Gender & Family Roles, Equality & Fairness, Destructive Impulses, Climate Policy, and Anti-Discrimination.

---

## Dashboard Usage

**Sidebar**
- Filter questions by category using the dropdown
- Click any row in the question table to select it

**Tabs**
| Tab | Chart |
|-----|-------|
| By Age Group | Stacked bar — response distribution across 6 age groups, split by gender |
| By Gender | Grouped bar — mean score by gender across age groups |
| Score Heatmap | Age × gender grid with weighted mean scores (red = disagree, blue = agree) |

---

## Structure

```
├── app.R                  # Shiny app (ui + server)
├── MBCsurvey.csv          # Survey data
├── R/
│   ├── translations.R     # Korean → English label mappings
│   ├── data_prep.R        # Data loading and transformation
│   └── plot_functions.R   # ggplot2 + plotly chart functions
└── www/
    └── styles.css         # Apple-style CSS
```

---

## Run Locally

```r
# Install dependencies
install.packages(c("shiny", "bslib", "readr", "dplyr", "tidyr",
                   "ggplot2", "plotly", "DT"))

# Run
shiny::runApp()
```
