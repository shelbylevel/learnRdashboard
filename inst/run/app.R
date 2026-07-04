# Standalone dev entry point.
#
# Loads the package in development mode and launches the app, without
# needing to install it first. Mirrors the file leprechaun::scaffold()
# generates at inst/run/app.R.
#
# Usage (from the package root):
#   pkgload::load_all()
#   learnRdashboard::run()
#
# or simply source this file from an R session opened at the package root.

if (requireNamespace("pkgload", quietly = TRUE)) {
  pkgload::load_all()
} else {
  devtools::load_all()
}

run()
