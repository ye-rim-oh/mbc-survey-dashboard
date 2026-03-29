# Keep the dashboard entry point small so shared data prep and plotting stay easy to trace.

library(shiny)
library(bslib)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(readr)

source("R/translations.R")
source("R/data_prep.R")
source("R/plot_functions.R")

survey        <- load_survey_data()
df_wide       <- survey$wide
df_long       <- survey$long

all_questions <- df_wide |>
  dplyr::distinct(question_en) |>
  dplyr::arrange(question_en)

# This file mainly binds one shared control state to two complementary views of the same question.
ui <- bslib::page_fillable(
  theme = bslib::bs_theme(
    version      = 5,
    bg           = "#FAFAFA",
    fg           = "#111111",
    primary      = "#2563EB",
    base_font    = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Inter")
  ),
  tags$head(tags$link(rel = "stylesheet", href = "styles.css")),

  # Put the controls first so both charts always read from the same question and filters.
  tags$div(
    class = "controls-wrap",

    # Keep one active question at a time so the dashboard stays focused on one item.
    tags$div(
      class = "control-row",
      tags$div(
        class = "control-col",
        tags$label(class = "ctrl-label", "Question"),
        shiny::selectizeInput(
          "sel_question", label = NULL,
          choices  = setNames(all_questions$question_en, all_questions$question_en),
          selected = all_questions$question_en[1],
          options  = list(placeholder = "Select a question")
        )
      )
    ),

    # Age and gender filters stay separate so users can isolate one cleavage without changing the question.
    tags$div(
      class = "filter-row",
      tags$div(
        class = "filter-group",
        tags$span(class = "ctrl-label", "Age"),
        shiny::checkboxGroupInput(
          "sel_age", label = NULL,
          choices  = age_order,
          selected = age_order,
          inline   = TRUE
        )
      ),
      tags$div(
        class = "filter-group",
        tags$span(class = "ctrl-label", "Gender"),
        shiny::checkboxGroupInput(
          "sel_gender", label = NULL,
          choices  = c("Male", "Female"),
          selected = c("Male", "Female"),
          inline   = TRUE
        )
      )
    )
  ),

  # Show both the full response spread and the mean score because either view alone hides part of the pattern.
  tags$div(
    class = "charts-wrap",
    bslib::card(
      class = "chart-card",
      plotly::plotlyOutput("plot_dist", height = "320px")
    ),
    bslib::card(
      class = "chart-card",
      plotly::plotlyOutput("plot_score", height = "280px")
    )
  )
)

# Server logic only coordinates the shared filters and chart outputs.
server <- function(input, output, session) {
  selected_q <- shiny::reactive({
    req(input$sel_question)
    input$sel_question
  })

  sel_age    <- shiny::reactive({ req(input$sel_age);    input$sel_age    })
  sel_gender <- shiny::reactive({ req(input$sel_gender); input$sel_gender })

  q_wide_sel <- shiny::reactive({
    dplyr::filter(df_wide,
      question_en == selected_q(),
      age_en      %in% sel_age(),
      gender_en   %in% sel_gender()
    )
  })

  q_long_sel <- shiny::reactive({
    dplyr::filter(df_long,
      question_en == selected_q(),
      age_en      %in% sel_age(),
      gender_en   %in% sel_gender()
    )
  })

  output$plot_dist <- plotly::renderPlotly({
    req(nrow(q_long_sel()) > 0)
    make_dist_chart(q_long_sel())
  })

  output$plot_score <- plotly::renderPlotly({
    req(nrow(q_wide_sel()) > 0)
    make_score_chart(q_wide_sel())
  })
}

shiny::shinyApp(ui, server)
