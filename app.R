# app.R — MBC Survey Dashboard

library(shiny)
library(bslib)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(DT)
library(readr)

source("R/translations.R")
source("R/data_prep.R")
source("R/plot_functions.R")

survey        <- load_survey_data()
df_wide       <- survey$wide
df_long       <- survey$long

all_questions <- df_wide |>
  dplyr::select(question_en, keyword_en) |>
  dplyr::distinct() |>
  dplyr::arrange(keyword_en, question_en)

all_categories <- sort(unique(all_questions$keyword_en))

# ── UI ────────────────────────────────────────────────────────────────────────
ui <- bslib::page_sidebar(
  title = "MBC Survey — Social Values in South Korea",
  theme = bslib::bs_theme(
    version      = 5,
    bg           = "#FAFAFA",
    fg           = "#111111",
    primary      = "#2563EB",
    base_font    = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Inter")
  ),

  tags$head(tags$link(rel = "stylesheet", href = "styles.css")),

  sidebar = bslib::sidebar(
    width = 340,
    bg    = "white",
    open  = TRUE,
    padding = "20px 16px",

    tags$div(class = "sidebar-label", "Category"),
    shiny::selectizeInput(
      "sel_category",
      label    = NULL,
      choices  = c("All" = "", all_categories),
      selected = "",
      multiple = FALSE,
      options  = list(placeholder = "All categories")
    ),

    tags$div(class = "sidebar-label", style = "margin-top:18px;", "Question"),
    DT::DTOutput("question_table", height = "auto")
  ),

  bslib::navset_card_underline(
    id     = "main_tabs",
    height = "520px",
    bslib::nav_panel("By Age Group",
      plotly::plotlyOutput("plot_age", height = "460px")
    ),
    bslib::nav_panel("By Gender",
      plotly::plotlyOutput("plot_gender", height = "460px")
    ),
    bslib::nav_panel("Score Heatmap",
      plotly::plotlyOutput("plot_heatmap", height = "400px")
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  filtered_questions <- shiny::reactive({
    if (is.null(input$sel_category) || input$sel_category == "") {
      all_questions
    } else {
      dplyr::filter(all_questions, keyword_en == input$sel_category)
    }
  })

  output$question_table <- DT::renderDT({
    DT::datatable(
      filtered_questions() |> dplyr::rename(Question = question_en, Category = keyword_en),
      selection  = list(mode = "single", selected = 1),
      rownames   = FALSE,
      options    = list(
        pageLength     = 36,
        dom            = "t",
        scrollY        = "62vh",
        scrollCollapse = TRUE,
        ordering       = FALSE,
        columnDefs     = list(list(targets = 1, visible = FALSE))
      ),
      class = "compact hover"
    )
  })

  selected_q <- shiny::reactive({
    sel <- input$question_table_rows_selected
    fq  <- filtered_questions()
    if (is.null(sel) || length(sel) == 0) return(fq$question_en[1])
    fq$question_en[sel]
  })

  q_wide_sel <- shiny::reactive({
    dplyr::filter(df_wide, question_en == selected_q())
  })
  q_long_sel <- shiny::reactive({
    dplyr::filter(df_long, question_en == selected_q())
  })

  output$plot_age <- plotly::renderPlotly({
    req(nrow(q_long_sel()) > 0)
    make_age_chart(q_long_sel(), selected_q())
  })

  output$plot_gender <- plotly::renderPlotly({
    req(nrow(q_wide_sel()) > 0)
    make_gender_chart(q_wide_sel(), selected_q())
  })

  output$plot_heatmap <- plotly::renderPlotly({
    req(nrow(q_wide_sel()) > 0)
    make_heatmap(q_wide_sel(), selected_q())
  })
}

shiny::shinyApp(ui, server)
