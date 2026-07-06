#' Path to the on-disk progress/notes store
#'
#' Defaults to a per-user, per-package data directory managed by R
#' itself (`tools::R_user_dir()`), so persistence works out of the box
#' for local/interactive use with no configuration.
#'
#' Set the `LEARNRDASHBOARD_DATA_DIR` environment variable (e.g. in
#' `.Renviron`, or as an environment variable on your deployment
#' platform) to point somewhere else instead — for example, a mounted
#' persistent volume when self-hosting, so the data survives container
#' rebuilds.
#'
#' @return A file path (not guaranteed to exist yet).
#'
#' @keywords internal
progress_store_path <- function() {
  dir <- Sys.getenv("LEARNRDASHBOARD_DATA_DIR", unset = "")
  if (!nzchar(dir)) {
    dir <- tools::R_user_dir("learnRdashboard", which = "data")
  }
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  }
  file.path(dir, "progress.rds")
}

#' Read saved progress/notes from disk, if present
#'
#' @return A list with `progress` and `notes` (each a named character
#'   vector keyed by book title), or `NULL` if nothing has been saved
#'   yet or the saved file can't be read.
#'
#' @keywords internal
read_progress_store <- function() {
  path <- progress_store_path()
  if (!file.exists(path)) {
    return(NULL)
  }
  tryCatch(
    readRDS(path),
    error = function(e) {
      warning(
        "Couldn't read saved progress, starting fresh: ",
        conditionMessage(e)
      )
      NULL
    }
  )
}

#' Write progress/notes to disk
#'
#' @param progress,notes Named character vectors keyed by book title
#'   (the current values of the `progress`/`notes` `reactiveVal`s).
#'
#' @keywords internal
write_progress_store <- function(progress, notes) {
  path <- progress_store_path()
  tryCatch(
    saveRDS(list(progress = progress, notes = notes), path),
    error = function(e) {
      warning("Couldn't save progress: ", conditionMessage(e))
    }
  )
}
