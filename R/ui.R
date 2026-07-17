#' Main application UI
#'
#' Builds the `page_navbar()` shell and wires in each tab's module UI
#' function. Called once per Shiny session.
#'
#' @param request The Shiny `request` object (used by dynamic UI / bookmarking;
#'   unused here but kept so the function can be passed directly to
#'   `shinyApp(ui = ui, ...)`).
#'
#' @keywords internal
ui <- function(request) {
  page_navbar(
    title = tags$span(
      icon("hockey-puck"),
      tags$strong("Hockey R Learning Hub")
    ),
    theme = slbrand::theme_sl(),
    # bg = brand_colors("palette")[["faded-jade-10"]],
    window_title = "Hockey R Learning Hub",

    explorerUI("explorer"),
    learning_planUI("plan"),
    hockey_dataUI("data"),
    progressUI("progress"),

    nav_spacer(),
    nav_item(
      tags$a(
        href = "https://www.bigbookofr.com",
        target = "_blank",
        class = "nav-link",
        bs_icon("box-arrow-up-right"),
        " Big Book of R"
      )
    ),
    slbrand::logo_nav_item(),
    header = slbrand::logo_header()
  )
}
