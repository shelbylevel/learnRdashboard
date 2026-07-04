## Build & save `resources` and `all_books`
##
## `resources` is the phase-by-phase curated learning roadmap (the
## Explorer and Learning Plan tabs); `all_books` is it flattened to
## one row per resource (used by the Learning Plan and Progress
## tracker tabs).
##
## Run this script (and commit the resulting data/*.rda files) any
## time the roadmap content changes.

resources <- list(
  list(
    phase = "Phase 1",
    phase_id = "p1",
    title = "Getting started",
    sub = "Months 1–2",
    color = "#085041",
    bg = "#E1F5EE",
    books = list(
      list(
        title = "Hands-On Programming with R",
        url = "https://rstudio-education.github.io/hopr/",
        use = "all",
        featured = TRUE,
        verdict = "Read every page. The single best first book for someone with zero coding experience.",
        desc = "Built for non-programmers, teaching you how to think like a programmer through fun projects — dice, cards, slot machines — rather than dry syntax. By the end you'll understand objects, functions, loops, and how R actually works.",
        sections = list(
          list(
            y = TRUE,
            t = "Part 1 (Ch 1–3): R basics, console, packages, help pages — all essential"
          ),
          list(
            y = TRUE,
            t = "Part 2 (Ch 4–7): R objects, data frames, indexing — critical for sport data"
          ),
          list(
            y = TRUE,
            t = "Part 3 (Ch 8–12): environments, loops, S3 objects — read it, don't stress if it's slow to click"
          )
        ),
        sport = "When you finish this book, replace the example datasets with a sport CSV — hockey box scores, game results — and redo the same exercises."
      ),
      list(
        title = "fasteR: Fast Lane to Learning R",
        url = "https://github.com/matloff/faster#less6",
        use = "parts",
        featured = FALSE,
        verdict = "Use as a companion practice tool alongside HOPR, not as a replacement for it.",
        desc = "Short and console-focused — good for drilling the basics without reading a full chapter.",
        sections = list(
          list(
            y = TRUE,
            t = "Lessons 1–10: vectors, data frames, table(), tapply() — use for extra practice"
          ),
          list(
            y = TRUE,
            t = "Lessons 11–18: plotting basics, lm() intro — worth reading through"
          ),
          list(
            y = FALSE,
            t = "Lessons 19+: more advanced base R; skip until Phase 2 is done"
          )
        ),
        sport = "Grab a hockey CSV and run through the early lessons using your own data instead of the built-in examples."
      ),
      list(
        title = "R for Graduate Students",
        url = "https://bookdown.org/yih_huynh/Guide-to-R-Book/",
        use = "parts",
        featured = FALSE,
        verdict = "Optional safety net — use it if HOPR ever feels too fast, not alongside it.",
        desc = "Very gentle pacing written for grad students who have never coded. If HOPR feels overwhelming at any point, this is the backup.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–6: R setup, basics, data types, data frames — supplementary reading only"
          ),
          list(
            y = TRUE,
            t = "Ch 7–10: visualization and data manipulation basics"
          ),
          list(
            y = FALSE,
            t = "Ch 11+: statistics sections — covered better by ModernDive in Phase 4"
          )
        ),
        sport = NULL
      ),
      list(
        title = "An Introduction to R",
        url = "https://intro2r.com",
        use = "parts",
        featured = FALSE,
        verdict = "Bookmark it as a reference. Don't read it linearly.",
        desc = "Comprehensive but dry. Better for looking up specific questions than reading cover-to-cover.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–3: installing R and RStudio, basic setup — useful early on"
          ),
          list(y = FALSE, t = "Ch 4–9: covered better in HOPR and R4DS"),
          list(
            y = FALSE,
            t = "Statistics chapters — covered better later by ModernDive"
          )
        ),
        sport = NULL
      )
    )
  ),
  list(
    phase = "Phase 2",
    phase_id = "p2",
    title = "Core R & the tidyverse",
    sub = "Months 2–5 · the most important phase",
    color = "#3C3489",
    bg = "#EEEDFE",
    books = list(
      list(
        title = "R for Data Science (2e)",
        url = "https://r4ds.hadley.nz",
        use = "most",
        featured = TRUE,
        verdict = "The most important book on this entire list. Read nearly all of it.",
        desc = "This is where you go from 'I can write R code' to 'I can actually do data analysis.' The tidyverse is the lingua franca of R analytics, and this book teaches it better than anything else.",
        sections = list(
          list(
            y = TRUE,
            t = "Whole Game (Ch 1–8): read every word — this is your foundation"
          ),
          list(
            y = TRUE,
            t = "Visualize (Ch 9–11): ggplot2 layers, EDA, chart communication — essential"
          ),
          list(
            y = TRUE,
            t = "Transform (Ch 12–19): strings, factors, dates, joins — all critical for sport data"
          ),
          list(y = TRUE, t = "Program (Ch 25–26): functions and iteration"),
          list(y = TRUE, t = "Communicate (Ch 28–29): Quarto chapters"),
          list(
            y = FALSE,
            t = "Import Ch 22–23 (Arrow, hierarchical data): can wait"
          ),
          list(
            y = FALSE,
            t = "Ch 27 (base R field guide): come back after 6 months"
          )
        ),
        sport = "The joins chapter (Ch 19) is especially important — sport data almost always lives across multiple tables (players, teams, games, stats) that need combining."
      ),
      list(
        title = "R Programming for Data Science",
        url = "https://bookdown.org/rdpeng/rprogdatascience/",
        use = "parts",
        featured = FALSE,
        verdict = "Selected chapters only — fills conceptual gaps that R4DS doesn't cover.",
        desc = "Goes deeper on how R works under the hood. A few chapters will prevent a lot of future frustration.",
        sections = list(
          list(y = TRUE, t = "Ch 4–6: R nuts and bolts, getting data in/out"),
          list(y = TRUE, t = "Ch 13: debugging and profiling"),
          list(
            y = TRUE,
            t = "Ch 14: vectorized operations — short and important"
          ),
          list(
            y = FALSE,
            t = "Ch 7–12 and 15+: overlaps with HOPR or not needed yet"
          )
        ),
        sport = NULL
      ),
      list(
        title = "R Cookbook (2e)",
        url = "https://rc2e.com",
        use = "parts",
        featured = FALSE,
        verdict = "Keep it bookmarked and search it constantly — don't read it linearly.",
        desc = "Structured as Q&A: 'how do I do X in R?' Invaluable when working on real sport data.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–5: basics, navigating R, data structures, I/O — scan these early"
          ),
          list(
            y = TRUE,
            t = "Ch 6 (data transformation) and Ch 10 (graphics): return here when stuck"
          ),
          list(
            y = FALSE,
            t = "Statistics chapters: use for R syntax lookup only, not stat concepts"
          )
        ),
        sport = NULL
      ),
      list(
        title = "Tidyverse Style Guide",
        url = "https://style.tidyverse.org",
        use = "parts",
        featured = FALSE,
        verdict = "Read the first half once, keep as a reference.",
        desc = "Writing clean, readable code matters — especially when sharing work with a team or in a portfolio.",
        sections = list(
          list(
            y = TRUE,
            t = "Files, syntax, functions sections — read once after Phase 1"
          ),
          list(
            y = FALSE,
            t = "Pipes and ggplot2 sections: read when you get there in R4DS"
          )
        ),
        sport = NULL
      )
    )
  ),
  list(
    phase = "Phase 3",
    phase_id = "p3",
    title = "Visualization",
    sub = "Parallel with Phase 2",
    color = "#633806",
    bg = "#FAEEDA",
    books = list(
      list(
        title = "R Graphics Cookbook (2e)",
        url = "https://r-graphics.org",
        use = "parts",
        featured = TRUE,
        verdict = "The most practical visualization book. Use it like a recipe book.",
        desc = "When you know the chart you want but can't remember the ggplot2 code, this is where you go. Scatter plots, bar charts, line charts — all covered with copy-paste code.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 2–3: bar charts and lines — most common sport analytics charts"
          ),
          list(
            y = TRUE,
            t = "Ch 4–5: scatter plots and line graphs — essential for performance data"
          ),
          list(
            y = TRUE,
            t = "Ch 8: axes, scales, legends — you'll need this constantly"
          ),
          list(
            y = TRUE,
            t = "Ch 10–11: custom themes, colors — makes charts look professional"
          ),
          list(
            y = FALSE,
            t = "Ch 13–15 (3D, maps, network graphs): save for later"
          )
        ),
        sport = "Scatter plots (player efficiency), bar charts (team stats), line charts (player development over a season) — this book covers all of them."
      ),
      list(
        title = "Fundamentals of Data Visualization",
        url = "https://clauswilke.com/dataviz/",
        use = "parts",
        featured = FALSE,
        verdict = "Read the conceptual chapters — no R code, but essential design thinking.",
        desc = "About WHY certain charts work and others don't. Valuable for sport analytics where you're often presenting to coaches or front offices.",
        sections = list(
          list(
            y = TRUE,
            t = "Part I (Ch 2–9): mapping data, coordinate systems, color — essential design thinking"
          ),
          list(
            y = TRUE,
            t = "Ch 17–19: proportional ink, overlapping points — directly applicable to shot charts"
          ),
          list(y = FALSE, t = "Part III and technical notes: save for later")
        ),
        sport = NULL
      ),
      list(
        title = "Data Visualization (Healy)",
        url = "https://socviz.co",
        use = "parts",
        featured = FALSE,
        verdict = "Read Ch 1 and dip into examples — the craft advice is universally useful.",
        desc = "Great for learning how to make charts tell a story, which is exactly what sport analytics presentations need.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1: look at data — a must-read on how to think about visualization"
          ),
          list(
            y = TRUE,
            t = "Ch 3–5: ggplot2 basics, refining plots — practical and sport-applicable"
          ),
          list(
            y = FALSE,
            t = "Ch 7–8: maps and specialized graphs — skip for now"
          )
        ),
        sport = NULL
      ),
      list(
        title = "ggplot2 (3e)",
        url = "https://ggplot2-book.org",
        use = "later",
        featured = FALSE,
        verdict = "Save for later — after R4DS and the Graphics Cookbook.",
        desc = "The definitive deep reference on ggplot2, written by the package author. Goes far deeper than a beginner needs.",
        sections = list(
          list(
            y = FALSE,
            t = "Save until after completing R4DS and practicing for several months"
          ),
          list(
            y = TRUE,
            t = "When you do read it: Part I and Part II (layers) are most useful for sport analytics"
          )
        ),
        sport = NULL
      )
    )
  ),
  list(
    phase = "Phase 4",
    phase_id = "p4",
    title = "Sport analytics applied",
    sub = "Months 4–8 · the sport-specific bridge",
    color = "#0C447C",
    bg = "#E6F1FB",
    books = list(
      list(
        title = "Introduction to Sports Analytics using R",
        url = "https://www.prospectpressvt.com/textbooks/elmore-sports-analytics",
        use = "all",
        featured = TRUE,
        verdict = "Read all of it. The only book on this list built specifically for sport analytics in R.",
        desc = "Elmore & Urbaczewski (2024) — covers data acquisition, web scraping, regression, prediction, simulation, visualization, and cluster models. Sports covered include basketball, football, ice hockey, soccer, golf. Companion ISAR R package includes real datasets.",
        sections = list(
          list(
            y = TRUE,
            t = "All chapters — this book is the direct application of Phases 1–2 to sport data"
          ),
          list(
            y = TRUE,
            t = "Regression and prediction chapters: the analytical core of sport analytics"
          ),
          list(
            y = TRUE,
            t = "Cluster models chapter: powerful for player archetype and position analysis"
          ),
          list(
            y = TRUE,
            t = "Web scraping and data acquisition: essential for building your own datasets"
          )
        ),
        sport = "Install the ISAR package (install.packages('ISAR')) to access the real datasets used throughout the book — including ice hockey data."
      )
    )
  ),
  list(
    phase = "Phase 5",
    phase_id = "p5",
    title = "Statistics & machine learning",
    sub = "Months 6–12+",
    color = "#993C1D",
    bg = "#FAECE7",
    books = list(
      list(
        title = "Statistical Inference via Data Science (ModernDive)",
        url = "https://moderndive.com",
        use = "all",
        featured = TRUE,
        verdict = "Read all of it. The perfect bridge from R4DS to statistics.",
        desc = "Written for people who know how to use R but don't yet know statistics. Covers regression, hypothesis testing, and bootstrapping using tidyverse tools.",
        sections = list(
          list(
            y = TRUE,
            t = "All chapters — not long, and every part is relevant to sport analytics"
          )
        ),
        sport = "Regression is the backbone of sport analytics: predicting outcomes, player valuation, identifying factors that drive winning."
      ),
      list(
        title = "Introduction to Statistical Learning (ISLR)",
        url = "https://www.statlearning.com",
        use = "parts",
        featured = FALSE,
        verdict = "Selected chapters — where sport analytics gets serious.",
        desc = "The canonical ML textbook. Several chapters are directly essential for predicting match outcomes, classifying player types, and clustering similar players.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–3: introduction and linear regression — read carefully"
          ),
          list(
            y = TRUE,
            t = "Ch 4: classification (logistic regression) — key for predicting win/loss"
          ),
          list(
            y = TRUE,
            t = "Ch 5: resampling (cross-validation, bootstrap) — essential for model evaluation"
          ),
          list(
            y = TRUE,
            t = "Ch 8: tree-based methods, random forests — widely used in sport analytics"
          ),
          list(
            y = TRUE,
            t = "Ch 12: unsupervised learning, clustering — great for player archetype analysis"
          ),
          list(
            y = FALSE,
            t = "Ch 6, 7, 9: regularization, non-linear, SVMs — optional"
          ),
          list(y = FALSE, t = "Ch 10–11 (deep learning): save for much later")
        ),
        sport = "Clustering (Ch 12) is particularly powerful: grouping players by playing style, identifying positional archetypes, finding comparable historical players."
      ),
      list(
        title = "Tidy Modeling with R",
        url = "https://www.tmwr.org",
        use = "parts",
        featured = FALSE,
        verdict = "Read after ISLR — this is how you implement ML in R properly.",
        desc = "Where ISLR teaches the concepts, tidymodels teaches the framework for building and evaluating models in a clean, reproducible workflow.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–9: tidymodels fundamentals, recipes, workflows — read carefully"
          ),
          list(
            y = TRUE,
            t = "Ch 10–12: resampling, comparing models — important for sport model evaluation"
          ),
          list(
            y = FALSE,
            t = "Ch 13–20: advanced feature engineering, ensembles — save for later"
          )
        ),
        sport = NULL
      ),
      list(
        title = "Forecasting: Principles & Practice",
        url = "https://otexts.com/fpp3/",
        use = "parts",
        featured = FALSE,
        verdict = "Selected chapters — time series is critical for sport analytics.",
        desc = "Sport analytics is full of time series: player performance over a career, team momentum over a season, fatigue effects over a schedule.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–5: time series basics, decomposition, simple forecasting"
          ),
          list(
            y = TRUE,
            t = "Ch 8: ARIMA models — useful for player and team trend analysis"
          ),
          list(y = FALSE, t = "Ch 9–12: more advanced models — optional")
        ),
        sport = "Season-long trend analysis, hot streaks, fatigue patterns — all time series problems."
      ),
      list(
        title = "Hands-on Machine Learning with R",
        url = "https://bradleyboehmke.github.io/HOML/",
        use = "parts",
        featured = FALSE,
        verdict = "Read alongside ISLR — better R code examples, same concepts.",
        desc = "Where ISLR is theory-forward, this is practice-forward with better implementation examples.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 2, 4, 5: modeling process, linear and logistic regression — start here"
          ),
          list(
            y = TRUE,
            t = "Ch 9–10: random forests, gradient boosting — most useful ML for sport"
          ),
          list(y = FALSE, t = "Deep learning chapters: skip for now")
        ),
        sport = NULL
      ),
      list(
        title = "Causal Inference in R",
        url = "https://www.r-causal.org",
        use = "later",
        featured = FALSE,
        verdict = "Save for 12–18 months in — important but needs statistical foundations first.",
        desc = "The most interesting sport analytics questions are causal: does this player cause their team to win? Does this training intervention actually improve performance?",
        sections = list(),
        sport = "Increasingly used in serious sport analytics orgs. Earmark for Year 2."
      )
    )
  ),
  list(
    phase = "Phase 6",
    phase_id = "p6",
    title = "Shiny & Quarto output",
    sub = "Start whenever curious — months 5–10",
    color = "#085041",
    bg = "#E1F5EE",
    books = list(
      list(
        title = "Mastering Shiny (2e)",
        url = "https://mastering-shiny.org",
        use = "parts",
        featured = TRUE,
        verdict = "Start after Phase 2 is complete — Shiny dashboards are a major sport analytics output.",
        desc = "Interactive dashboards are how sport analysts communicate with front offices and coaching staffs who don't run R themselves.",
        sections = list(
          list(
            y = TRUE,
            t = "Ch 1–5: your first app, basic UI, reactive programming — read carefully"
          ),
          list(
            y = TRUE,
            t = "Ch 6–8: layouts, graphics in Shiny, user feedback — practical"
          ),
          list(
            y = FALSE,
            t = "Ch 9–14: modules, testing, performance — save for bigger apps"
          ),
          list(y = FALSE, t = "Ch 15+: advanced patterns — much later")
        ),
        sport = "A Shiny dashboard showing shot charts, player comparison sliders, or live game data is exactly the kind of deliverable that gets noticed in sport analytics roles."
      ),
      list(
        title = "Quarto (quarto.org)",
        url = "https://quarto.org",
        use = "parts",
        featured = FALSE,
        verdict = "Learn the basics early — Quarto is how sport analysts share their work.",
        desc = "Every sport analytics report and presentation you produce should be a Quarto document. Reproducible, professional, shareable.",
        sections = list(
          list(
            y = TRUE,
            t = "Get started guide and HTML documents section — read these first"
          ),
          list(
            y = TRUE,
            t = "Presentations (revealjs) — great for sharing analysis with coaching staff"
          ),
          list(
            y = FALSE,
            t = "Websites, books, manuscripts: save for when you need them"
          )
        ),
        sport = "Being able to hand a coach a polished, reproducible HTML report of player analysis is a real professional differentiator."
      ),
      list(
        title = "Engineering Production-Grade Shiny",
        url = "https://engineering-shiny.org",
        use = "later",
        featured = FALSE,
        verdict = "Save for when building serious deployed Shiny apps.",
        desc = "The golem framework, testing, deployment, modules — professional Shiny engineering.",
        sections = list(),
        sport = NULL
      )
    )
  )
)

# Flatten resources for progress tracker
all_books <- do.call(
  rbind,
  lapply(resources, function(ph) {
    do.call(
      rbind,
      lapply(ph$books, function(b) {
        data.frame(
          phase = ph$phase,
          phase_id = ph$phase_id,
          phase_title = ph$title,
          title = b$title,
          url = b$url,
          use = b$use,
          featured = b$featured,
          verdict = b$verdict,
          stringsAsFactors = FALSE
        )
      })
    )
  })
)

usethis::use_data(resources, all_books, overwrite = TRUE)
