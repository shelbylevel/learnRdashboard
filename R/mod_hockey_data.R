#' Hockey data module
#'
#' Tab 3 — browse the pre-loaded ISAR hockey datasets, preview the
#' live data table, and view the exercises tied to each dataset.
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
hockey_dataUI <- function(id) {
  ns <- NS(id)

  nav_panel(
    title = tagList(bs_icon("database"), " Hockey Data"),
    value = "tab_data",
    layout_sidebar(
      sidebar = sidebar(
        width = 270,
        title = "Datasets",
        p(
          "All datasets pre-loaded from the ",
          tags$strong("ISAR"),
          " package —",
          " no internet connection required.",
          style = "font-size:12px;color:#555;margin-bottom:10px;"
        ),
        radioButtons(
          ns("selected_dataset"),
          label = NULL,
          choices = dataset_names,
          selected = 1
        ),
        hr(),
        div(
          style = "font-size:12px;color:#555;",
          bs_icon("info-circle"),
          " ",
          tags$strong("ISAR"),
          " = Introduction to Sports Analytics with R ",
          tags$em("(Elmore & Urbaczewski, 2024)"),
          " — the Phase 4 textbook."
        )
      ),
      uiOutput(ns("dataset_panel"))
    )
  )
}

#' Hockey data module server
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
hockey_data_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

  output$dataset_panel <- renderUI({
    idx <- as.integer(input$selected_dataset)
    if (is.na(idx) || idx < 1 || idx > length(datasets_meta)) {
      return(NULL)
    }
    ds <- datasets_meta[[idx]]

    tagList(
      # Row 1: overview + column glossary
      layout_column_wrap(
        width = 1 / 2,
        fill = FALSE,
        card(
          card_header(
            class = "d-flex align-items-center gap-2 fw-semibold",
            tags$span(ds$emoji, style = "font-size:18px;"),
            ds$name,
            level_badge(ds$level),
            tags$span(
              paste0(ds$rows, " rows · ", ds$cols_n, " cols"),
              style = "font-size:11px;color:#888;margin-left:auto;"
            )
          ),
          card_body(
            tags$p(
              ds$desc,
              style = "font-size:13px;line-height:1.65;margin-bottom:12px;"
            ),
            div(
              class = "alert alert-info p-2 d-flex align-items-center gap-2",
              style = "font-size:12px;",
              bs_icon("box"),
              tags$span("Source package: "),
              tags$code(ds$pkg),
              tags$span("·"),
              tags$code(paste0(
                'data("',
                sub("_clean$", "", ds$key),
                '", package = "ISAR")'
              ))
            )
          )
        ),
        card(
          card_header(
            bs_icon("table"),
            " Column Glossary",
            class = "d-flex align-items-center gap-2"
          ),
          card_body(
            tags$table(
              class = "table table-sm table-hover",
              style = "font-size:12px;margin-bottom:0;",
              tags$thead(tags$tr(
                tags$th("Column"),
                tags$th("What it means")
              )),
              tags$tbody(lapply(ds$col_glossary, function(g) {
                tags$tr(
                  tags$td(tags$code(g$col)),
                  tags$td(g$def, style = "color:#444;")
                )
              }))
            )
          )
        )
      ),
      # Row 2: live data preview
      card(
        card_header(
          bs_icon("eye"),
          " Live Data Preview",
          class = "d-flex align-items-center gap-2"
        ),
        full_screen = TRUE,
        card_body(class = "p-0", DTOutput(ns("data_preview"), height = "340px"))
      ),
      # Row 3: exercises
      card(
        card_header(
          bs_icon("journal-code"),
          " Resource Exercises",
          class = "d-flex align-items-center gap-2"
        ),
        full_screen = TRUE,
        card_body(
          p(
            "Copy any exercise code into your R console to try it immediately.",
            style = "font-size:12px;color:#666;margin-bottom:12px;"
          ),
          uiOutput(ns("exercise_cards"))
        )
      )
    )
  })

  output$data_preview <- renderDT({
    idx <- as.integer(input$selected_dataset)
    if (is.na(idx)) {
      return(NULL)
    }
    ds <- datasets_meta[[idx]]
    datatable(
      ds$data,
      rownames = FALSE,
      options = list(
        pageLength = 8,
        scrollX = TRUE,
        dom = "tip",
        ordering = TRUE,
        autoWidth = FALSE
      ),
      class = "table table-sm table-hover"
    )
  })

  output$exercise_cards <- renderUI({
    idx <- as.integer(input$selected_dataset)
    if (is.na(idx)) {
      return(NULL)
    }
    ds <- datasets_meta[[idx]]

    # Find phase colors for badges
    phase_lookup <- setNames(
      lapply(resources, function(ph) list(bg = ph$bg, color = ph$color)),
      sapply(resources, `[[`, "phase")
    )

    tagList(lapply(seq_along(ds$exercises), function(ei) {
      ex <- ds$exercises[[ei]]
      pcfg <- phase_lookup[[ex$phase]] %||% list(bg = "#f0f0f0", color = "#333")
      card(
        class = "mb-3",
        style = paste0("border-left:4px solid ", pcfg$color, ";"),
        card_body(
          div(
            class = "d-flex align-items-center gap-2 mb-2",
            tags$span(
              ex$phase,
              style = paste0(
                "background:",
                pcfg$bg,
                ";color:",
                pcfg$color,
                ";",
                "font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;"
              )
            ),
            tags$span(
              ex$book,
              style = "font-size:12px;color:#555;font-style:italic;"
            ),
            tags$span(
              paste0("Exercise ", ei),
              style = "font-size:11px;color:#aaa;margin-left:auto;"
            )
          ),
          tags$strong(
            ex$title,
            style = "font-size:13px;display:block;margin-bottom:4px;"
          ),
          tags$p(
            ex$desc,
            style = "font-size:12px;color:#555;margin-bottom:8px;"
          ),
          tags$pre(
            class = "p-3 rounded mb-0",
            style = paste0(
              "background:#f8f9fa;font-size:12px;",
              "white-space:pre-wrap;border:1px solid #e9ecef;"
            ),
            ex$code
          )
        )
      )
    }))
  })
  })
}
