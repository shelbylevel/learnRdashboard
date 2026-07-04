## Null-coalescing helper.
##
## Falls back to base R's `%||%` (available since R 4.4.0) when present,
## otherwise defines a local equivalent so the app-package also works on
## older R versions. `x %||% y` returns `y` when `x` is `NULL`.
if (!exists("%||%", mode = "function")) {
  `%||%` <- function(x, y) if (is.null(x)) y else x
}

#' Reading-priority badge
#'
#' Small pill badge summarising how much of a resource to read
#' ("Read all", "Read most", "Selected parts", "Save for later", "Not
#' needed").
#'
#' @param use One of `"all"`, `"most"`, `"parts"`, `"later"`, `"skip"`.
#'
#' @keywords internal
badge_html <- function(use) {
  cfg <- list(
    all = list(bg = "#E1F5EE", color = "#085041", label = "Read all"),
    most = list(bg = "#EEEDFE", color = "#3C3489", label = "Read most"),
    parts = list(bg = "#FAEEDA", color = "#633806", label = "Selected parts"),
    later = list(bg = "#F1EFE8", color = "#5F5E5A", label = "Save for later"),
    skip = list(bg = "#FCEBEB", color = "#A32D2D", label = "Not needed")
  )
  cfg <- cfg[[use]] %||% cfg[["parts"]]
  tags$span(
    cfg$label,
    style = paste0(
      "background:",
      cfg$bg,
      ";color:",
      cfg$color,
      ";",
      "font-size:11px;font-weight:500;padding:2px 8px;border-radius:20px;",
      "white-space:nowrap;display:inline-block;"
    )
  )
}

#' Dataset difficulty-level badge
#'
#' @param lvl One of `"Beginner"`, `"Intermediate"` (anything else falls
#'   back to a neutral badge).
#'
#' @keywords internal
level_badge <- function(lvl) {
  cfg <- list(
    "Beginner" = list(bg = "#E1F5EE", color = "#085041"),
    "Intermediate" = list(bg = "#EEEDFE", color = "#3C3489")
  )
  c <- cfg[[lvl]] %||% list(bg = "#F1EFE8", color = "#5F5E5A")
  tags$span(
    lvl,
    style = paste0(
      "background:",
      c$bg,
      ";color:",
      c$color,
      ";",
      "font-size:11px;font-weight:500;padding:2px 8px;border-radius:20px;",
      "display:inline-block;"
    )
  )
}

#' Phase badge
#'
#' @param ph_label Phase label text (e.g. `"Phase 1"`).
#' @param bg Background colour.
#' @param color Text colour.
#'
#' @keywords internal
phase_badge_html <- function(ph_label, bg, color) {
  tags$span(
    ph_label,
    style = paste0(
      "background:",
      bg,
      ";color:",
      color,
      ";",
      "font-size:11px;font-weight:600;padding:2px 8px;",
      "border-radius:20px;display:inline-block;margin-right:4px;"
    )
  )
}
