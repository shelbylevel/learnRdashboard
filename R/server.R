#' Main application server
#'
#' Instantiates every module's server logic. Each module is
#' self-contained (its own reactives/outputs live behind its namespace),
#' so this function is intentionally just a list of module calls.
#'
#' @param input,output,session Standard Shiny server arguments.
#'
#' @keywords internal
server <- function(input, output, session) {
  explorer_server("explorer")
  learning_plan_server("plan")
  hockey_data_server("data")
  progress_server("progress")
}
