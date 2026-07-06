#' @noRd
.onLoad <- function(libname, pkgname) {
  # Load package data when the package is loaded
  data(package = "learnRdashboard", envir = parent.frame())

  # Serve inst/app/www as static assets at /www, mirroring the leprechaun
  # scaffold. Not currently used (no custom JS/CSS), so the directory may
  # not even exist in a built tarball (R strips empty directories) — guard
  # against that rather than failing package load.
  www_dir <- system.file("app/www", package = pkgname)
  if (nzchar(www_dir)) {
    shiny::addResourcePath("www", www_dir)
  }
}
