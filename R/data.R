#' Curated R learning roadmap
#'
#' The phase-by-phase list of books/courses that make up the R learning
#' roadmap (the Explorer and Learning Plan tabs). Each phase has a
#' `title`, `sub`(title), theme colors, and a `books` sub-list; each book
#' has `title`, `url`, `use` (`"all"`/`"most"`/`"parts"`/`"later"`/`"skip"`),
#' `featured`, `verdict`, `desc`, `sections`, and an optional `sport` tie-in
#' note.
#'
#' Rebuild this dataset with `data-raw/resources.R`.
#'
#' @format A list with one entry per phase.
#' @source Hand-curated by the package author; see `data-raw/resources.R`.
"resources"

#' Learning roadmap, flattened to one row per resource
#'
#' [resources] flattened to a data frame with one row per book, for the
#' Learning Plan and Progress tracker tabs.
#'
#' Rebuild this dataset with `data-raw/resources.R`.
#'
#' @format A data frame with columns `phase`, `phase_id`, `phase_title`,
#'   `title`, `url`, `use`, `featured`, `verdict`.
#' @source Derived from [resources]; see `data-raw/resources.R`.
"all_books"

#' Hockey dataset catalogue
#'
#' The pre-loaded, pre-cleaned \pkg{ISAR} hockey datasets shown in the
#' Hockey Data tab, along with their descriptions, column glossaries, and
#' the textbook exercises tied to each one.
#'
#' Rebuild this dataset with `data-raw/datasets_meta.R` (requires the
#' \pkg{ISAR} package, listed in Suggests since it's only needed to
#' regenerate this data, not to run the app).
#'
#' @format A list with one entry per dataset (`key`, `name`, `emoji`,
#'   `level`, `pkg`, `rows`, `cols_n`, `data`, `desc`, `col_glossary`,
#'   `exercises`).
#' @source The \pkg{ISAR} package; see `data-raw/datasets_meta.R`.
"datasets_meta"

#' Dataset names, for the Hockey Data tab's `radioButtons()`
#'
#' A named integer vector mapping a display label (emoji + dataset name)
#' to its index in [datasets_meta].
#'
#' Rebuild this dataset with `data-raw/datasets_meta.R`.
#'
#' @format A named integer vector.
#' @source Derived from [datasets_meta]; see `data-raw/datasets_meta.R`.
"dataset_names"
