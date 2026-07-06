# Deployment entry point for shinyapps.io / Posit Connect.
#
# rsconnect deploys whatever directory you point it at. Because this
# directory also contains a DESCRIPTION file, rsconnect treats it as an
# installable R package: it bundles the package source, installs it
# (and its declared Imports) on the server, then runs this file as the
# app itself.
#
# Keep this file minimal — all real app logic lives in the learnRdashboard
# package (R/ui.R, R/server.R, R/mod_*.R, etc.), not here.

# Prevent Shiny's runApp() from also trying to source R/ as loose
# "supporting files" (it would otherwise warn and re-source package code
# outside the package's own loading mechanism — see ?shiny::loadSupport).
# All real app code loads properly via library(learnRdashboard) below.
options(shiny.autoload.r = FALSE)

library(learnRdashboard)

run()
