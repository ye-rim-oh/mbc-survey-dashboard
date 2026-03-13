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

# ── Load data ─────────────────────────────────────────────────────────────────
survey <- load_survey_data()
df_wide <- survey$wide
df_long <- survey$long

# Question lookup: question_en -> question_kr (for filtering)
all_questions <- df_wide |>
  dplyr::select(question_en, keyword_en) |>
  dplyr::distinct() |>
  dplyr::arrange(keyword_en, question_en)

all_categories <- sort(unique(all_questions$keyword_en))

# ── UI ────────────────────────────────────────────────────────────────────────
ui <- bslib::page_sidebar(
  title = "MBC Survey · Social Values Dashboard",
  theme = bslib::bs_theme(
    version     = 5,
    bg          = "#F5F5F7",
    fg          = "#1D1D1F",
    primary     = "#0071E3",
    base_font   = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Inter")
  ),

  tags$head(
    tags$link(rel = "stylesheet", href = "styles.css")
  ),

  # ── Sidebar ────────────────────────────────────────────────────────────────
  sidebar = bslib::sidebar(
    width = 380,
    open  = TRUE,

    tags$p(
      style = "font-size:11px; color:#86868B; text-transform:uppercase;
               letter-spacing:0.5px; font-weight:600; margin-bottom:6px;",
      "Filter by Category"
    ),
    shiny::selectizeInput(
      "sel_category",
      label   = NULL,
      choices = c("All Categories" = "", all_categories),
      selected = "",
      multiple = FALSE,
      options  = list(placeholder = "All Categories")
    ),

    tags$hr(style = "border-color:#E5E5EA; margin:16px 0;"),

    tags$p(
      style = "font-size:11px; color:#86868B; text-transform:uppercase;
               letter-spacing:0.5px; font-weight:600; margin-bottom:6px;",
      "Select a Question"
    ),
    DT::DTOutput("question_table", height = "auto")
  ),

  # ── Main panel ────────────────────────────────────────────────────────────
  bslib::card(
    style = "padding: 10px 16px; margin-bottom: 10px;",
    shiny::uiOutput("question_detail")
  ),

  bslib::navset_tab(
    bslib::nav_panel(
      "By Age Group",
      icon = shiny::icon("bar-chart"),
      plotly::plotlyOutput("plot_age", height = "420px")
    ),
    bslib::nav_panel(
      "By Gender",
      icon = shiny::icon("venus-mars"),
      plotly::plotlyOutput("plot_gender", height = "420px")
    ),
    bslib::nav_panel(
      "Score Heatmap",
      icon = shiny::icon("th"),
      plotly::plotlyOutput("plot_heatmap", height = "340px")
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # Filtered question list
  filtered_questions <- shiny::reactive({
    if (is.null(input$sel_category) || input$sel_category == "") {
      all_questions
    } else {
      dplyr::filter(all_questions, keyword_en == input$sel_category)
    }
  })

  # Question table (sidebar)
  output$question_table <- DT::renderDT({
    DT::datatable(
      filtered_questions() |> dplyr::rename(Question = question_en, Category = keyword_en),
      selection  = list(mode = "single", selected = 1),
      rownames   = FALSE,
      options    = list(
        pageLength  = 36,
        dom         = "t",
        scrollY     = "55vh",
        scrollCollapse = TRUE,
        ordering    = FALSE,
        columnDefs  = list(
          list(targets = 1, visible = FALSE)   # hide Category column
        )
      ),
      class = "compact hover"
    )
  })

  # Selected question text
  selected_q <- shiny::reactive({
    sel <- input$question_table_rows_selected
    if (is.null(sel) || length(sel) == 0) return(filtered_questions()$question_en[1])
    filtered_questions()$question_en[sel]
  })

  # Question detail header
  output$question_detail <- shiny::renderUI({
    q  <- selected_q()
    kw <- all_questions$keyword_en[all_questions$question_en == q][1]
    tags$div(
      style = "padding: 4px 0;",
      tags$span(style = "font-size:11px; color:#86868B; font-weight:600;
                         text-transform:uppercase; letter-spacing:0.4px;
                         display:inline; margin-right:8px;", paste0(kw, " ·")),
      tags$span(style = "font-size:14px; font-weight:500; color:#1D1D1F;", q)
    )
  })

  # Subset data for selected question
  q_wide_sel <- shiny::reactive({
    dplyr::filter(df_wide, question_en == selected_q())
  })
  q_long_sel <- shiny::reactive({
    dplyr::filter(df_long, question_en == selected_q())
  })

  # Tab 1: By Age Group
  output$plot_age <- plotly::renderPlotly({
    req(nrow(q_long_sel()) > 0)
    make_age_chart(q_long_sel(), selected_q())
  })

  # Tab 2: By Gender
  output$plot_gender <- plotly::renderPlotly({
    req(nrow(q_wide_sel()) > 0)
    make_gender_chart(q_wide_sel(), selected_q())
  })

  # Tab 3: Heatmap
  output$plot_heatmap <- plotly::renderPlotly({
    req(nrow(q_wide_sel()) > 0)
    make_heatmap(q_wide_sel(), selected_q())
  })
}

shiny::shinyApp(ui, server)
