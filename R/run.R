#' Run the Hockey R Learning Hub app
#'
#' Launches the Shiny application. This is the only function most users
#' of the package need — everything else (UI/server modules, data
#' loaders) is internal.
#'
#' @param ... Arguments passed on to [shiny::shinyApp()], e.g.
#'   `options = list(port = 8080)`.
#'
#' @return A Shiny app object (invisibly runs when called at the top
#'   level of an interactive session, per usual Shiny behaviour).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' run()
#' }
run <- function(...) {
  shinyApp(ui = ui, server = server, ...)
}
