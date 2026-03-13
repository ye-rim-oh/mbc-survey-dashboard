# R/plot_functions.R
# Chart functions with Apple HIG color palette

# ── Apple-inspired palette ────────────────────────────────────────────────────
# Likert scale: Strongly Disagree -> Strongly Agree
LIKERT_PALETTE <- c(
  "Strongly Disagree" = "#FF453A",   # Apple Red
  "Disagree"          = "#FF9F0A",   # Apple Orange
  "Neutral"           = "#AEAEB2",   # Apple Gray
  "Agree"             = "#30D158",   # Apple Green
  "Strongly Agree"    = "#0071E3"    # Apple Blue
)

GENDER_PALETTE <- c(
  "Male"   = "#0071E3",   # Apple Blue
  "Female" = "#FF2D55"    # Apple Pink
)

# ── Base ggplot theme ─────────────────────────────────────────────────────────
apple_theme <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size) +
  ggplot2::theme(
    text             = ggplot2::element_text(
                         family = "Helvetica Neue",
                         color  = "#1D1D1F"),
    plot.title       = ggplot2::element_text(
                         size = base_size + 1, face = "bold",
                         margin = ggplot2::margin(b = 12)),
    plot.subtitle    = ggplot2::element_text(
                         size = base_size - 1, color = "#86868B",
                         margin = ggplot2::margin(b = 10)),
    axis.text        = ggplot2::element_text(size = base_size - 2, color = "#86868B"),
    axis.title       = ggplot2::element_text(size = base_size - 1, color = "#86868B"),
    axis.title.x     = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color = "#F2F2F7", linewidth = 0.5),
    panel.grid.minor   = ggplot2::element_blank(),
    panel.background   = ggplot2::element_rect(fill = "white", color = NA),
    plot.background    = ggplot2::element_rect(fill = "white", color = NA),
    strip.text         = ggplot2::element_text(
                           size = base_size - 1, face = "bold",
                           color = "#1D1D1F"),
    strip.background   = ggplot2::element_rect(fill = "#F5F5F7", color = NA),
    legend.position    = "bottom",
    legend.title       = ggplot2::element_blank(),
    legend.text        = ggplot2::element_text(size = base_size - 2),
    legend.key.size    = ggplot2::unit(0.7, "lines"),
    plot.margin        = ggplot2::margin(16, 16, 16, 16)
  )
}

# ── Tab 1: By Age Group (stacked bar, faceted by gender) ─────────────────────
make_age_chart <- function(q_long, title) {
  q_long$response <- factor(q_long$response,
    levels = c("Strongly Disagree","Disagree","Neutral","Agree","Strongly Agree"))

  p <- ggplot2::ggplot(q_long,
         ggplot2::aes(x = age_en, y = pct, fill = response,
                      text = paste0(response, ": ", round(pct, 1), "%"))) +
    ggplot2::geom_col(position = "stack", width = 0.7) +
    ggplot2::facet_wrap(~ gender_en, nrow = 1) +
    ggplot2::scale_fill_manual(values = LIKERT_PALETTE) +
    ggplot2::scale_y_continuous(labels = function(x) paste0(x, "%"),
                                expand = ggplot2::expansion(mult = c(0, 0.05))) +
    ggplot2::labs(title = title,
                  subtitle = "Response distribution by age group",
                  y = "Percentage (%)") +
    apple_theme()

  plotly::ggplotly(p, tooltip = "text") |>
    plotly::layout(
      legend = list(orientation = "h", y = -0.15, x = 0.5, xanchor = "center"),
      margin = list(t = 50, b = 60)
    )
}

# ── Tab 2: By Gender (grouped bar, faceted by age) ────────────────────────────
make_gender_chart <- function(q_wide, title) {
  p <- ggplot2::ggplot(q_wide,
         ggplot2::aes(x = gender_en, y = mean_score, fill = gender_en,
                      text = paste0(gender_en, ": ", round(mean_score, 2)))) +
    ggplot2::geom_col(width = 0.6) +
    ggplot2::geom_hline(yintercept = 3, linetype = "dashed",
                        color = "#AEAEB2", linewidth = 0.4) +
    ggplot2::facet_wrap(~ age_en, nrow = 1) +
    ggplot2::scale_fill_manual(values = GENDER_PALETTE) +
    ggplot2::scale_y_continuous(limits = c(1, 5),
                                breaks = 1:5,
                                labels = c("1\nStrongly\nDisagree","2","3\nNeutral","4","5\nStrongly\nAgree"),
                                expand = ggplot2::expansion(mult = c(0, 0.05))) +
    ggplot2::labs(title = title,
                  subtitle = "Mean score by gender across age groups (dashed = neutral)",
                  y = "Mean Score (1–5)") +
    apple_theme() +
    ggplot2::theme(legend.position = "none")

  plotly::ggplotly(p, tooltip = "text") |>
    plotly::layout(margin = list(t = 50, b = 40))
}

# ── Tab 3: Score Heatmap (age × gender grid) ─────────────────────────────────
make_heatmap <- function(q_wide, title) {
  p <- ggplot2::ggplot(q_wide,
         ggplot2::aes(x = age_en, y = gender_en, fill = mean_score,
                      text = paste0(age_en, " / ", gender_en,
                                    "<br>Score: ", round(mean_score, 2)))) +
    ggplot2::geom_tile(color = "white", linewidth = 1.5) +
    ggplot2::geom_text(ggplot2::aes(label = round(mean_score, 2)),
                       size = 3.5, fontface = "bold",
                       color = ifelse(q_wide$mean_score > 3.5, "white", "#1D1D1F")) +
    ggplot2::scale_fill_gradient2(
      low      = "#FF453A",
      mid      = "#F5F5F7",
      high     = "#0071E3",
      midpoint = 3,
      limits   = c(1, 5),
      name     = "Score"
    ) +
    ggplot2::labs(title = title,
                  subtitle = "Weighted mean score (1 = Strongly Disagree, 5 = Strongly Agree)",
                  x = "Age Group", y = NULL) +
    apple_theme() +
    ggplot2::theme(
      axis.title.x    = ggplot2::element_text(color = "#86868B", size = 11),
      panel.grid       = ggplot2::element_blank(),
      legend.position  = "right"
    )

  plotly::ggplotly(p, tooltip = "text") |>
    plotly::layout(margin = list(t = 50))
}
