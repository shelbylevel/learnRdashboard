#' Explorer module
#'
#' Tab 1 — browse and filter the curated learning resources (books,
#' courses, references) that make up the R learning roadmap.
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
explorerUI <- function(id) {
  ns <- NS(id)

  nav_panel(
    title = tagList(bs_icon("search"), " Explorer"),
    value = "tab_explorer",
    layout_sidebar(
      sidebar = sidebar(
        width = 270,
        open = "closed",
        title = "Filter Resources",
        selectInput(
          ns("filter_phase"),
          "Phase",
          choices = c(
            "All phases",
            setNames(
              sapply(resources, `[[`, "phase_id"),
              paste(
                sapply(resources, `[[`, "phase"),
                "·",
                sapply(resources, `[[`, "title")
              )
            )
          ),
          selected = "All phases"
        ),
        checkboxGroupInput(
          ns("filter_use"),
          "Reading priority",
          choices = c(
            "Read all" = "all",
            "Read most" = "most",
            "Selected parts" = "parts",
            "Save for later" = "later"
          ),
          selected = c("all", "most", "parts", "later")
        ),
        hr(),
        textInput(
          ns("search_text"),
          "Search titles",
          placeholder = "e.g. ggplot, tidyverse…"
        )
      ),
      layout_column_wrap(
        width = 1,
        fill = FALSE,
        uiOutput(ns("explorer_cards"))
      )
    )
  )
}

#' Explorer module server
#'
#' @param id Unique id for the module instance.
#'
#' @keywords internal
explorer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    filtered_resources <- reactive({
      ph <- input$filter_phase
      use_f <- input$filter_use
      txt <- tolower(trimws(input$search_text))
      lapply(resources, function(ph_data) {
        if (ph != "All phases" && ph_data$phase_id != ph) {
          return(NULL)
        }
        books_f <- Filter(
          function(b) {
            (b$use %in% use_f) && (txt == "" || grepl(txt, tolower(b$title)))
          },
          ph_data$books
        )
        if (length(books_f) == 0) {
          return(NULL)
        }
        modifyList(ph_data, list(books = books_f))
      })
    })

    output$explorer_cards <- renderUI({
      phases_to_show <- Filter(Negate(is.null), filtered_resources())
      if (length(phases_to_show) == 0) {
        return(p(
          "No resources match your filters.",
          style = "color:#888;padding:1rem;"
        ))
      }
      tagList(lapply(phases_to_show, function(ph) {
        tagList(
          div(
            style = "margin-bottom:0.25rem;",
            tags$span(
              ph$phase,
              style = paste0(
                "background:",
                ph$bg,
                ";color:",
                ph$color,
                ";",
                "font-size:11px;font-weight:600;padding:2px 10px;",
                "border-radius:20px;display:inline-block;margin-right:6px;"
              )
            ),
            tags$span(ph$title, style = "font-size:14px;font-weight:500;"),
            tags$span(
              ph$sub,
              style = "font-size:12px;color:#888;margin-left:6px;"
            )
          ),
          layout_column_wrap(
            width = "420px",
            fill = FALSE,
            !!!lapply(ph$books, function(b) {
              card(
                style = if (b$featured) {
                  paste0("border:2px solid ", ph$color, ";")
                } else {
                  ""
                },
                card_header(
                  class = "d-flex align-items-center gap-2 py-2",
                  if (b$featured) {
                    bs_icon(
                      "star-fill",
                      title = "Featured",
                      style = paste0("color:", ph$color)
                    )
                  } else {
                    bs_icon("journal")
                  },
                  tags$span(
                    b$title,
                    style = "font-size:13px;font-weight:500;flex:1;"
                  ),
                  badge_html(b$use)
                ),
                card_body(
                  class = "py-2",
                  tags$p(
                    b$verdict,
                    style = "font-size:12px;font-weight:500;margin-bottom:6px;"
                  ),
                  tags$p(
                    b$desc,
                    style = "font-size:12px;color:#555;margin-bottom:8px;"
                  ),
                  if (!is.null(b$sport) && b$sport != "") {
                    div(
                      class = "p-2 rounded",
                      style = "background:#f0f7f4;border-left:3px solid #1D9E75;",
                      bs_icon(
                        "trophy",
                        style = "color:#1D9E75;margin-right:4px;"
                      ),
                      tags$span(b$sport, style = "font-size:12px;color:#333;")
                    )
                  } else {
                    NULL
                  }
                ),
                card_footer(
                  class = "d-flex justify-content-between align-items-center py-1",
                  tags$a(
                    href = b$url,
                    target = "_blank",
                    class = "btn btn-sm btn-outline-primary",
                    bs_icon("box-arrow-up-right"),
                    " Open resource"
                  ),
                  if (length(b$sections) > 0) {
                    popover(
                      bs_icon(
                        "list-ul",
                        title = paste("What to read in", b$title)
                      ),
                      tags$strong("What to read"),
                      tags$ul(
                        style = "font-size:12px;padding-left:1rem;margin:0;",
                        lapply(b$sections, function(s) {
                          tags$li(
                            style = paste0(
                              "color:",
                              if (s$y) "#085041" else "#999",
                              ";margin-bottom:4px;"
                            ),
                            if (!s$y) tags$s(s$t) else s$t
                          )
                        })
                      ),
                      placement = "left"
                    )
                  } else {
                    NULL
                  }
                )
              )
            })
          ),
          tags$hr(style = "margin:1rem 0 1.25rem 0;")
        )
      }))
    })
  })
}
