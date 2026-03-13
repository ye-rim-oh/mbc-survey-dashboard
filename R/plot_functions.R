# R/plot_functions.R

LIKERT_PALETTE <- c(
  "Strongly Disagree" = "#C5705D",
  "Disagree"          = "#D4A96A",
  "Neutral"           = "#C7C7CC",
  "Agree"             = "#6BAF8A",
  "Strongly Agree"    = "#5B8FBF"
)

GENDER_PALETTE <- c(
  "Male"   = "#5B8FBF",
  "Female" = "#C5705D"
)

chart_theme <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size) +
  ggplot2::theme(
    text               = ggplot2::element_text(color = "#1D1D1F"),
    plot.subtitle      = ggplot2::element_text(size = base_size - 1, color = "#888888",
                           margin = ggplot2::margin(b = 10)),
    axis.text          = ggplot2::element_text(size = base_size - 2, color = "#888888"),
    axis.title.x       = ggplot2::element_blank(),
    axis.title.y       = ggplot2::element_text(size = base_size - 2, color = "#888888"),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color = "#F0F0F0", linewidth = 0.5),
    panel.grid.minor   = ggplot2::element_blank(),
    panel.background   = ggplot2::element_rect(fill = "white", color = NA),
    plot.background    = ggplot2::element_rect(fill = "white", color = NA),
    strip.text         = ggplot2::element_text(size = base_size - 1, face = "bold",
                           color = "#333333"),
    strip.background   = ggplot2::element_blank(),
    legend.position    = "bottom",
    legend.title       = ggplot2::element_blank(),
    legend.text        = ggplot2::element_text(size = base_size - 2),
    legend.key.size    = ggplot2::unit(0.7, "lines"),
    plot.margin        = ggplot2::margin(12, 16, 8, 16)
  )
}

# Chart 1: Response distribution — stacked bar, age on x, faceted by gender
make_dist_chart <- function(q_long) {
  q_long$response <- factor(q_long$response, levels = likert_order)
  q_long$group_label <- paste0(q_long$age_en, " \u00b7 ", q_long$gender_en)

  p <- ggplot2::ggplot(q_long,
         ggplot2::aes(x = age_en, y = pct, fill = response,
                      text = paste0(group_label, "\n",
                                    response, ": ", round(pct, 1), "%"))) +
    ggplot2::geom_col(position = "stack", width = 0.72) +
    ggplot2::facet_wrap(~ gender_en, nrow = 1) +
    ggplot2::scale_fill_manual(values = LIKERT_PALETTE) +
    ggplot2::scale_y_continuous(
      labels = function(x) paste0(x, "%"),
      expand = ggplot2::expansion(mult = c(0, 0.03))) +
    ggplot2::labs(subtitle = "Response distribution (%)", y = "Percentage", fill = "") +
    chart_theme()

  plotly::ggplotly(p, tooltip = "text") |>
    plotly::layout(
      legend = list(orientation = "h", y = -0.2, x = 0.5, xanchor = "center",
                    title = list(text = "")),
      margin = list(t = 40, b = 70, l = 50, r = 30)
    ) |>
    plotly::config(displayModeBar = FALSE)
}

# Chart 2: Mean score — grouped bar, age on x, colored by gender
make_score_chart <- function(q_wide) {
  q_wide$group_label <- paste0(q_wide$age_en, " \u00b7 ", q_wide$gender_en)
  q_wide$age_en <- factor(q_wide$age_en, levels = age_order)

  p <- ggplot2::ggplot(q_wide,
         ggplot2::aes(x = age_en, y = mean_score, fill = gender_en,
                      text = paste0(group_label, "\nScore: ", round(mean_score, 2)))) +
    ggplot2::geom_col(position = "dodge", width = 0.6) +
    ggplot2::geom_hline(yintercept = 3, linetype = "dashed",
                        color = "#CCCCCC", linewidth = 0.4) +
    ggplot2::scale_fill_manual(values = GENDER_PALETTE) +
    ggplot2::scale_y_continuous(
      breaks = 1:5,
      labels = c("1", "2", "3 (neutral)", "4", "5"),
      expand = ggplot2::expansion(mult = c(0, 0.05))) +
    ggplot2::coord_cartesian(ylim = c(1, 5.2)) +
    ggplot2::labs(subtitle = "Mean score  (1 = Strongly Disagree, 5 = Strongly Agree)",
                  y = "Score", fill = "") +
    chart_theme()

  plotly::ggplotly(p, tooltip = "text") |>
    plotly::layout(
      legend = list(orientation = "h", y = -0.2, x = 0.5, xanchor = "center",
                    title = list(text = "")),
      margin = list(t = 10, b = 70, l = 60, r = 30)
    ) |>
    plotly::config(displayModeBar = FALSE)
}
