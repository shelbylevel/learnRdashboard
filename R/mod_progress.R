#' Progress tracker module
#'
#' Tab 4 — track reading progress and personal notes against every
#' resource in the roadmap, with a summary chart and reset control.
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
progressUI <- function(id) {
  ns <- NS(id)

  nav_panel(
    title = tagList(bs_icon("check2-circle"), " Progress"),
    value = "tab_progress",
    layout_sidebar(
      sidebar = sidebar(
        width = 260,
        title = "My Progress",
        p(
          "Track your reading progress. Check off resources as you work through them.",
          style = "font-size:13px;color:#555;"
        ),
        hr(),
        uiOutput(ns("progress_summary_sidebar")),
        hr(),
        actionButton(
          ns("reset_progress"),
          "Reset all progress",
          class = "btn-sm btn-outline-danger w-100",
          icon = icon("rotate-left")
        )
      ),
      layout_column_wrap(
        width = 1 / 2,
        fill = FALSE,
        card(
          card_header(
            bs_icon("bar-chart-fill"),
            " Progress Overview",
            class = "d-flex align-items-center gap-2"
          ),
          full_screen = TRUE,
          plotOutput(ns("progress_chart"), height = "320px")
        ),
        card(
          card_header(
            bs_icon("list-check"),
            " Reading List",
            class = "d-flex align-items-center gap-2"
          ),
          full_screen = TRUE,
          uiOutput(ns("reading_list_ui"))
        )
      )
    )
  )
}

#' Progress tracker module server
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
progress_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

  progress <- reactiveVal(
    setNames(rep("not_started", nrow(all_books)), all_books$title)
  )

  notes <- reactiveVal(
    setNames(rep("", nrow(all_books)), all_books$title)
  )

  output$reading_list_ui <- renderUI({
    prog <- progress()
    nts <- notes()
    tagList(lapply(resources, function(ph) {
      tagList(
        div(
          class = "mt-3 mb-1",
          tags$span(
            ph$phase,
            style = paste0(
              "background:",
              ph$bg,
              ";color:",
              ph$color,
              ";",
              "font-size:11px;font-weight:600;padding:2px 8px;",
              "border-radius:20px;margin-right:6px;"
            )
          ),
          tags$strong(ph$title, style = "font-size:13px;")
        ),
        lapply(ph$books, function(b) {
          cur <- prog[[b$title]] %||% "not_started"
          note_val <- nts[[b$title]] %||% ""
          prog_id <- paste0("prog_", make.names(b$title))
          note_id <- paste0("note_", make.names(b$title))
          has_note <- nchar(trimws(note_val)) > 0

          div(
            style = "border-bottom:1px solid #f0f0f0;padding:6px 0 4px 0;",
            # Status + title row
            div(
              class = "d-flex align-items-center gap-2",
              selectInput(
                inputId = ns(prog_id),
                label = NULL,
                choices = c(
                  "Not started" = "not_started",
                  "In progress" = "in_progress",
                  "Completed" = "completed"
                ),
                selected = cur,
                width = "160px"
              ),
              div(
                style = "flex:1;min-width:0;",
                tags$span(b$title, style = "font-size:12px;font-weight:500;"),
                tags$br(),
                badge_html(b$use)
              ),
              # Notes toggle — amber when a note exists
              tags$button(
                class = paste0(
                  "btn btn-sm ",
                  if (has_note) "btn-warning" else "btn-outline-secondary"
                ),
                style = "font-size:11px;white-space:nowrap;flex-shrink:0;",
                `data-bs-toggle` = "collapse",
                `data-bs-target` = paste0(
                  "#",
                  ns(paste0("notecollapse_", make.names(b$title)))
                ),
                `aria-expanded` = tolower(as.character(has_note)),
                if (has_note) {
                  tagList(
                    bs_icon("sticky-fill", title = "Notes saved"),
                    " Notes"
                  )
                } else {
                  tagList(bs_icon("sticky", title = "Add notes"), " Notes")
                }
              )
            ),
            # Collapsible notes textarea
            div(
              id = ns(paste0("notecollapse_", make.names(b$title))),
              class = paste0("collapse", if (has_note) " show" else ""),
              div(
                class = "pt-2 pb-1",
                style = paste0(
                  "border-left:3px solid ",
                  ph$color,
                  ";padding-left:10px;margin-left:4px;"
                ),
                tags$textarea(
                  id = ns(note_id),
                  class = "form-control form-control-sm",
                  style = paste0(
                    "font-size:12px;resize:vertical;",
                    "min-height:64px;background:#fffef5;border-color:#ffe58f;"
                  ),
                  placeholder = "Jot down takeaways, questions, or things to revisit…",
                  note_val
                )
              )
            )
          )
        })
      )
    }))
  })

  # Sync progress status dropdowns
  observe({
    prog <- progress()
    for (b in all_books$title) {
      val <- input[[paste0("prog_", make.names(b))]]
      if (!is.null(val) && !identical(prog[[b]], val)) prog[[b]] <- val
    }
    progress(prog)
  })

  # Sync notes textareas
  observe({
    nts <- notes()
    for (b in all_books$title) {
      val <- input[[paste0("note_", make.names(b))]]
      if (!is.null(val) && !identical(nts[[b]], val)) nts[[b]] <- val
    }
    notes(nts)
  })

  observeEvent(input$reset_progress, {
    init_prog <- setNames(rep("not_started", nrow(all_books)), all_books$title)
    init_notes <- setNames(rep("", nrow(all_books)), all_books$title)
    progress(init_prog)
    notes(init_notes)
    for (b in all_books$title) {
      updateSelectInput(
        session,
        paste0("prog_", make.names(b)),
        selected = "not_started"
      )
    }
  })

  output$progress_summary_sidebar <- renderUI({
    prog <- progress()
    n_done <- sum(prog == "completed")
    n_wip <- sum(prog == "in_progress")
    n_tot <- length(prog)
    pct <- round(n_done / n_tot * 100)
    div(
      style = "font-size:13px;",
      div(
        class = "d-flex justify-content-between",
        tags$span("Completed:"),
        tags$strong(paste0(n_done, " / ", n_tot))
      ),
      div(
        class = "progress mt-1 mb-2",
        style = "height:8px;",
        div(
          class = "progress-bar bg-success",
          style = paste0("width:", pct, "%;"),
          role = "progressbar"
        )
      ),
      div(
        class = "d-flex justify-content-between",
        tags$span("In progress:"),
        tags$strong(n_wip)
      )
    )
  })

  output$progress_chart <- renderPlot({
    prog <- progress()
    all_books |>
      mutate(
        status = factor(
          prog[title],
          levels = c("not_started", "in_progress", "completed"),
          labels = c("Not started", "In progress", "Completed")
        ),
        phase = factor(phase, levels = sapply(resources, `[[`, "phase"))
      ) |>
      count(phase, status) |>
      ggplot(aes(x = n, y = phase, fill = status)) +
      geom_col(position = "stack", width = 0.6) +
      scale_fill_manual(
        values = c(
          "Not started" = "#e9ecef",
          "In progress" = "#74c0e8",
          "Completed" = "#1D9E75"
        )
      ) +
      labs(
        x = "Number of resources",
        y = NULL,
        fill = NULL,
        title = "Reading progress by phase"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        legend.position = "bottom",
        panel.grid.major.y = element_blank(),
        plot.title = element_text(size = 13, face = "bold")
      )
  })

  })
}
