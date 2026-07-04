#' Learning plan module
#'
#' Tab 2 — high-level roadmap summary (value boxes + phase-by-phase
#' timeline) built from the resources list.
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
learning_planUI <- function(id) {
  ns <- NS(id)

  nav_panel(
    title = tagList(bs_icon("map"), " Learning Plan"),
    value = "tab_plan",
    page_fillable(
      layout_column_wrap(
        width = 1 / 3,
        fill = FALSE,
        value_box(
          title = "Total resources",
          value = nrow(all_books),
          showcase = bs_icon("journal-bookmark"),
          theme = "primary"
        ),
        value_box(
          title = "Phases",
          value = length(resources),
          showcase = bs_icon("flag"),
          theme = "success"
        ),
        value_box(
          title = "Estimated timeline",
          value = "12–18 months",
          showcase = bs_icon("calendar3"),
          theme = "info"
        )
      ),
      card(
        card_header(
          bs_icon("signpost-split"),
          " Phase Roadmap",
          class = "d-flex align-items-center gap-2"
        ),
        full_screen = TRUE,
        uiOutput(ns("phase_roadmap"))
      )
    )
  )
}

#' Learning plan module server
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
learning_plan_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  output$phase_roadmap <- renderUI({
    tagList(lapply(seq_along(resources), function(i) {
      ph <- resources[[i]]
      div(
        class = "d-flex align-items-start gap-3 mb-4",
        div(
          class = "d-flex flex-column align-items-center",
          div(
            as.character(i),
            style = paste0(
              "width:36px;height:36px;border-radius:50%;",
              "background:",
              ph$color,
              ";color:#fff;display:flex;",
              "align-items:center;justify-content:center;",
              "font-size:14px;font-weight:700;flex-shrink:0;"
            )
          ),
          if (i < length(resources)) {
            div(
              style = paste0(
                "width:2px;height:60px;background:",
                ph$bg,
                ";margin-top:4px;"
              )
            )
          } else {
            NULL
          }
        ),
        div(
          style = "flex:1;",
          div(
            style = "margin-bottom:6px;",
            tags$span(
              ph$phase,
              style = paste0(
                "background:",
                ph$bg,
                ";color:",
                ph$color,
                ";",
                "font-size:12px;font-weight:600;padding:2px 10px;",
                "border-radius:20px;margin-right:8px;"
              )
            ),
            tags$strong(ph$title, style = "font-size:14px;"),
            tags$span(
              ph$sub,
              style = "font-size:12px;color:#888;margin-left:8px;"
            )
          ),
          div(
            class = "d-flex gap-2 flex-wrap",
            lapply(ph$books, function(b) {
              div(
                class = "p-2 rounded d-flex align-items-center gap-2",
                style = paste0(
                  "background:",
                  ph$bg,
                  ";",
                  "border:",
                  if (b$featured) {
                    paste0("1.5px solid ", ph$color)
                  } else {
                    "1px solid rgba(0,0,0,0.1)"
                  },
                  ";",
                  "font-size:12px;max-width:280px;"
                ),
                if (b$featured) {
                  bs_icon(
                    "star-fill",
                    title = "Featured",
                    style = paste0("color:", ph$color, ";flex-shrink:0;")
                  )
                } else {
                  bs_icon("journal", style = "opacity:0.5;flex-shrink:0;")
                },
                div(
                  div(b$title, style = "font-weight:500;line-height:1.3;"),
                  badge_html(b$use)
                )
              )
            })
          )
        )
      )
    }))
  })
  })
}
