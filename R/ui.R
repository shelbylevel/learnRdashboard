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
      bs_icon("person-arms-up"),
      " ",
      tags$strong("Hockey R Learning Hub")
    ),
    theme = bs_theme(
      version = 5,
      bootswatch = "flatly",
      primary = "#1a6fa8",
      success = "#1D9E75",
      font_scale = 0.95
    ),
    bg = "#1a6fa8",
    window_title = "Hockey R Learning Hub",
    header = tags$style(HTML(
      "
      .navbar-nav .nav-link,
      .navbar-nav .nav-link.active,
      .navbar-nav .nav-link:focus,
      .navbar-nav .nav-link:hover,
      .navbar-nav .show > .nav-link {
        color: #ffffff !important;
      }
      .navbar-nav .nav-link.active {
        font-weight: 700;
        opacity: 1;
      }
      .navbar-nav .nav-link:not(.active) {
        opacity: 0.8;
      }
    "
    )),

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
    )
  )
}
