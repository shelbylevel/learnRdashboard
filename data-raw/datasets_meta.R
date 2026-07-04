## Build & save `datasets_meta` and `dataset_names`
##
## Loads and cleans the ISAR hockey datasets, and assembles the
## catalogue used by the Hockey Data tab (column glossaries,
## descriptions, and the textbook exercises tied to each dataset).
##
## Run this script (and commit the resulting data/*.rda files) any
## time the ISAR datasets or exercise content change. Not run at
## package build/install time — the package ships the pre-built
## `data/datasets_meta.rda` / `data/dataset_names.rda` instead, so
## end users never need ISAR installed.

library(dplyr)

# ── Pre-load all hockey datasets at startup ───────────────────────────────────

data("nhl_data_hockey_reference", package = "ISAR", envir = environment())
data("nhl_team_stats_2021", package = "ISAR", envir = environment())
data("nhl_team_stats_2022", package = "ISAR", envir = environment())
data("avs_roster_2021", package = "ISAR", envir = environment())
data("avs_roster_2022", package = "ISAR", envir = environment())
data("avs_stats_2021", package = "ISAR", envir = environment())
data("avs_stats_2022", package = "ISAR", envir = environment())
data("dk_edm_col", package = "ISAR", envir = environment())
data("dk_bos_buf", package = "ISAR", envir = environment())
data("dk_nyr_car", package = "ISAR", envir = environment())

# ── Derived / cleaned datasets ────────────────────────────────────────────────

# 1. NHL team stats 2022-23 — cleaned column names for display
nhl_teams_clean <- nhl_team_stats_2022 |>
  select(
    Team = team_name,
    GP = stat_games_played,
    W = stat_wins,
    L = stat_losses,
    OT = stat_ot,
    Pts = stat_pts,
    `Pts%` = stat_pt_pctg,
    `GF/GP` = stat_goals_per_game,
    `GA/GP` = stat_goals_against_per_game,
    `PP%` = stat_power_play_percentage,
    `PK%` = stat_penalty_kill_percentage,
    `S/GP` = stat_shots_per_game,
    `SV%` = stat_save_pctg,
    `S%` = stat_shooting_pctg
  ) |>
  arrange(desc(Pts))

# 2. NHL team stats 2021-22 — same shape for comparison exercises
nhl_teams_2021_clean <- nhl_team_stats_2021 |>
  select(
    Team = team_name,
    GP = stat_games_played,
    W = stat_wins,
    L = stat_losses,
    OT = stat_ot,
    Pts = stat_pts,
    `Pts%` = stat_pt_pctg,
    `GF/GP` = stat_goals_per_game,
    `GA/GP` = stat_goals_against_per_game,
    `PP%` = stat_power_play_percentage,
    `PK%` = stat_penalty_kill_percentage,
    `S/GP` = stat_shots_per_game,
    `SV%` = stat_save_pctg,
    `S%` = stat_shooting_pctg
  ) |>
  arrange(desc(Pts))

# 3. Colorado Avalanche roster + player stats 2022-23 (skaters only, one season)
avs_skaters <- avs_roster_2022 |>
  inner_join(
    avs_stats_2022 |>
      filter(season_start == 2022, !is.na(stat_goals)) |>
      select(
        person_id,
        GP = stat_games,
        G = stat_goals,
        A = stat_assists,
        Pts = stat_points,
        `+/-` = stat_plus_minus,
        SOG = stat_shots,
        `S%` = stat_shot_pct,
        Hits = stat_hits,
        Blk = stat_blocked,
        PPG = stat_power_play_goals,
        PPP = stat_power_play_points,
        TOI = stat_time_on_ice
      ),
    by = "person_id"
  ) |>
  filter(position_abbreviation != "G") |>
  select(
    Player = person_full_name,
    `#` = jersey_number,
    Pos = position_abbreviation,
    GP,
    G,
    A,
    Pts,
    `+/-`,
    SOG,
    `S%`,
    Hits,
    Blk,
    PPG,
    PPP,
    TOI
  ) |>
  arrange(desc(Pts))

# 4. Colorado Avalanche goalie stats 2022-23
avs_goalies <- avs_roster_2022 |>
  inner_join(
    avs_stats_2022 |>
      filter(season_start == 2022, !is.na(stat_wins)) |>
      select(
        person_id,
        GP = stat_games,
        W = stat_wins,
        L = stat_losses,
        OT = stat_ot,
        GAA = stat_goal_against_average,
        `SV%` = stat_save_percentage,
        SO = stat_shutouts,
        SA = stat_shots_against,
        GA = stat_goals_against,
        Saves = stat_saves
      ),
    by = "person_id"
  ) |>
  filter(position_abbreviation == "G") |>
  select(
    Player = person_full_name,
    `#` = jersey_number,
    GP,
    W,
    L,
    OT,
    GAA,
    `SV%`,
    SO,
    SA,
    GA,
    Saves
  ) |>
  arrange(desc(W))

# 5. Multi-season NHL skater data (2019–2023, min 20 GP) — good for joins/trends
nhl_skaters_multi <- nhl_data_hockey_reference |>
  filter(season >= 2019, gp >= 20) |>
  select(
    Player = player,
    Age = age,
    Team = tm,
    Pos = pos,
    Season = season,
    GP = gp,
    G = g,
    A = a,
    Pts = pts,
    `+/-` = x,
    SOG = s,
    `S%` = s_percent,
    `CF%` = cf_percent,
    `FF%` = ff_percent,
    PDO = pdo,
    AvgTOI = atoi
  ) |>
  arrange(Season, desc(Pts))

# 6. DraftKings showdown — Edmonton vs Colorado (2022 playoffs)
dk_edm_col_clean <- dk_edm_col |>
  select(
    Player = name,
    Pos = position,
    Team = team_abbrev,
    `Roster Slot` = roster_position,
    Salary = salary,
    `Avg DK Pts` = avg_points_per_game,
    Game = game_info
  ) |>
  arrange(desc(Salary))

# Named list for UI selector — each entry has display info and the data
datasets_meta <- list(
  list(
    key = "nhl_teams_22",
    name = "NHL Team Stats 2022-23",
    emoji = "🏒",
    level = "Beginner",
    pkg = "ISAR",
    rows = nrow(nhl_teams_clean),
    cols_n = ncol(nhl_teams_clean),
    data = nhl_teams_clean,
    desc = paste0(
      "Season-level statistics for all 32 NHL teams in 2022-23. ",
      "Includes wins, losses, goals for/against, power play %, penalty kill %, ",
      "shots per game, save %, and shooting %. Perfect for beginner exercises — ",
      "every row is one team and the numbers are easy to interpret."
    ),
    col_glossary = list(
      list(col = "Team", def = "Team full name"),
      list(col = "GP", def = "Games played"),
      list(
        col = "W / L / OT",
        def = "Wins, regulation losses, overtime/shootout losses"
      ),
      list(
        col = "Pts",
        def = "Points in the standings (2 for a win, 1 for an OT loss)"
      ),
      list(col = "Pts%", def = "Points earned out of maximum possible (%)"),
      list(col = "GF/GP", def = "Goals scored per game (offensive output)"),
      list(col = "GA/GP", def = "Goals allowed per game (defensive output)"),
      list(
        col = "PP%",
        def = "Power play conversion rate: goals ÷ opportunities"
      ),
      list(col = "PK%", def = "Penalty kill success rate"),
      list(col = "S/GP", def = "Shots on goal per game"),
      list(col = "SV%", def = "Goalie save percentage"),
      list(col = "S%", def = "Team shooting percentage: goals ÷ shots")
    ),
    exercises = list(
      list(
        phase = "Phase 1",
        book = "Hands-On Programming with R",
        title = "Indexing and subsetting",
        desc = "Practice Ch 4–7 indexing skills on real team data.",
        code = 'library(ISAR)\ndata("nhl_team_stats_2022")\n\n# Which teams scored more than 3.5 goals per game?\nnhl_team_stats_2022[nhl_team_stats_2022$stat_goals_per_game > 3.5, "team_name"]'
      ),
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "dplyr basics: filter, arrange, select",
        desc = "Apply Ch 3–5 verbs to find the best and worst teams.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("nhl_team_stats_2022")\n\nnhl_team_stats_2022 |>\n  select(team_name, stat_pts, stat_goals_per_game, stat_goals_against_per_game) |>\n  arrange(desc(stat_pts)) |>\n  head(10)'
      ),
      list(
        phase = "Phase 3",
        book = "R Graphics Cookbook (2e)",
        title = "Scatter plot: offense vs defense",
        desc = "Ch 4–5 recipe: scatter plot with team labels.",
        code = 'library(ggplot2)\nlibrary(ISAR)\ndata("nhl_team_stats_2022")\n\nggplot(nhl_team_stats_2022,\n       aes(x = stat_goals_per_game, y = stat_goals_against_per_game)) +\n  geom_point() +\n  geom_text(aes(label = team_name), size = 2.5, vjust = -0.5) +\n  labs(x = "Goals for per game", y = "Goals against per game",\n       title = "NHL Team Offense vs Defense, 2022-23")'
      ),
      list(
        phase = "Phase 5",
        book = "ModernDive / ISLR",
        title = "Linear regression: does PP% predict wins?",
        desc = "Fit a simple linear model — the entry point for regression in sport analytics.",
        code = 'library(ISAR)\ndata("nhl_team_stats_2022")\n\nmodel <- lm(stat_wins ~ stat_power_play_percentage, data = nhl_team_stats_2022)\nsummary(model)'
      )
    )
  ),

  list(
    key = "avs_skaters",
    name = "Colorado Avalanche Skaters 2022-23",
    emoji = "⛸️",
    level = "Beginner",
    pkg = "ISAR",
    rows = nrow(avs_skaters),
    cols_n = ncol(avs_skaters),
    data = avs_skaters,
    desc = paste0(
      "Individual skater statistics for the Colorado Avalanche's 2022-23 season — ",
      "the same team that won the Stanley Cup the year before. ",
      "23 players, clean one-row-per-player format, ideal for sorting, filtering, ",
      "and plotting player performance. Nathan MacKinnon, Cale Makar, ",
      "and Mikko Rantanen are in here."
    ),
    col_glossary = list(
      list(col = "Player", def = "Player full name"),
      list(col = "#", def = "Jersey number"),
      list(
        col = "Pos",
        def = "Position: C (center), LW/RW (wing), D (defenseman)"
      ),
      list(col = "GP", def = "Games played"),
      list(col = "G / A", def = "Goals and assists"),
      list(col = "Pts", def = "Total points (G + A)"),
      list(
        col = "+/-",
        def = "Plus-minus: on-ice goal differential at even strength"
      ),
      list(col = "SOG", def = "Shots on goal"),
      list(col = "S%", def = "Shooting percentage: G ÷ SOG × 100"),
      list(col = "Hits", def = "Body checks delivered"),
      list(col = "Blk", def = "Shots blocked"),
      list(col = "PPG/PPP", def = "Power play goals / power play points"),
      list(col = "TOI", def = "Total time on ice (seconds)")
    ),
    exercises = list(
      list(
        phase = "Phase 1",
        book = "Hands-On Programming with R",
        title = "Explore objects and data frames",
        desc = "Use HOPR Ch 4–7 skills: inspect structure, pull a column, find the max.",
        code = 'library(ISAR)\ndata("avs_roster_2022")\ndata("avs_stats_2022")\n\n# Explore the roster\nstr(avs_roster_2022)\n\n# How many players are at each position?\ntable(avs_roster_2022$position_abbreviation)'
      ),
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "Join roster and stats (Ch 19 — joins)",
        desc = "The canonical R4DS joins exercise with hockey data.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("avs_roster_2022")\ndata("avs_stats_2022")\n\navs_2023 <- avs_roster_2022 |>\n  inner_join(\n    avs_stats_2022 |> filter(season_start == 2022),\n    by = "person_id"\n  ) |>\n  filter(position_abbreviation != "G") |>\n  select(person_full_name, position_abbreviation,\n         stat_goals, stat_assists, stat_points) |>\n  arrange(desc(stat_points))\n\nhead(avs_2023, 10)'
      ),
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "Group summaries by position (Ch 3)",
        desc = "Summarise goals and points by position — the group_by + summarise pattern.",
        code = 'library(dplyr)\n\n# Assumes avs_skaters is loaded\navs_skaters |>\n  group_by(Pos) |>\n  summarise(\n    n_players   = n(),\n    avg_goals   = mean(G),\n    avg_points  = mean(Pts),\n    avg_plus_minus = mean(`+/-`)\n  ) |>\n  arrange(desc(avg_points))'
      ),
      list(
        phase = "Phase 3",
        book = "R Graphics Cookbook (2e)",
        title = "Bar chart: top scorers",
        desc = "Ch 2–3 recipe: horizontal bar chart of player points.",
        code = 'library(ggplot2)\n\n# Assumes avs_skaters is loaded\navs_skaters |>\n  slice_max(Pts, n = 10) |>\n  ggplot(aes(x = Pts, y = reorder(Player, Pts))) +\n  geom_col() +\n  labs(x = "Points", y = NULL,\n       title = "Colorado Avalanche: Top 10 Scorers, 2022-23")'
      )
    )
  ),

  list(
    key = "avs_goalies",
    name = "Colorado Avalanche Goalies 2022-23",
    emoji = "🥅",
    level = "Beginner",
    pkg = "ISAR",
    rows = nrow(avs_goalies),
    cols_n = ncol(avs_goalies),
    data = avs_goalies,
    desc = paste0(
      "Goalie statistics for Alexandar Georgiev and Pavel Francouz, the two ",
      "Avalanche goalies in 2022-23. Small dataset (2 rows) — perfect for ",
      "a first comparison exercise and for understanding the difference between ",
      "GAA (goals against average) and SV% (save percentage)."
    ),
    col_glossary = list(
      list(col = "Player", def = "Goalie name"),
      list(col = "GP", def = "Games played"),
      list(
        col = "W / L / OT",
        def = "Wins, regulation losses, overtime losses"
      ),
      list(col = "GAA", def = "Goals against average per 60 minutes"),
      list(
        col = "SV%",
        def = "Save percentage: saves ÷ shots faced. Higher is better. Elite: >0.915"
      ),
      list(col = "SO", def = "Shutouts"),
      list(col = "SA", def = "Shots against (total shots the goalie faced)"),
      list(col = "GA", def = "Goals against"),
      list(col = "Saves", def = "Shots saved (SA − GA)")
    ),
    exercises = list(
      list(
        phase = "Phase 1",
        book = "Hands-On Programming with R",
        title = "Compute a new stat with arithmetic",
        desc = "HOPR Ch 2: use R as a calculator to verify save percentage.",
        code = '# SV% = Saves / Shots Against\n# Verify by hand for Georgiev\ngeorgiev_saves <- 1594\ngeorgiev_sa    <- 1744\ngeorgiev_saves / georgiev_sa  # should match the SV% column'
      ),
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "Compute GAA from raw data (mutate, Ch 3)",
        desc = "Use mutate() to add a calculated column: GA per 60 minutes.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("avs_stats_2022")\n\navs_stats_2022 |>\n  filter(season_start == 2022, !is.na(stat_wins)) |>\n  select(person_id, stat_wins, stat_goals_against,\n         stat_shots_against, stat_save_percentage) |>\n  mutate(sv_pct_check = round(1 - stat_goals_against / stat_shots_against, 3))'
      )
    )
  ),

  list(
    key = "nhl_skaters_multi",
    name = "NHL Skaters 2019–2023 (Multi-season)",
    emoji = "📈",
    level = "Intermediate",
    pkg = "ISAR",
    rows = nrow(nhl_skaters_multi),
    cols_n = ncol(nhl_skaters_multi),
    data = nhl_skaters_multi,
    desc = paste0(
      "Skater statistics from Hockey Reference across 5 seasons (2019–2023), ",
      "covering 3,731 player-seasons for players with at least 20 GP. ",
      "Includes traditional stats (G, A, Pts) alongside advanced metrics: ",
      "Corsi For % (CF%), Fenwick For % (FF%), and PDO. ",
      "Great for trend analysis across seasons and for learning about ",
      "possession-based analytics."
    ),
    col_glossary = list(
      list(
        col = "Player / Team / Season",
        def = "Player name, team abbreviation, and season end year (e.g. 2023 = 2022-23)"
      ),
      list(
        col = "GP / G / A / Pts",
        def = "Games played, goals, assists, points"
      ),
      list(col = "+/-", def = "Even-strength goal differential while on ice"),
      list(col = "SOG", def = "Shots on goal"),
      list(col = "S%", def = "Shooting percentage"),
      list(
        col = "CF%",
        def = "Corsi For %: percentage of all shot attempts (on goal, missed, blocked) taken by the player's team while they were on ice. >50% means the team controlled the puck more. A possession metric."
      ),
      list(
        col = "FF%",
        def = "Fenwick For %: like CF% but excludes blocked shots. Considered a slightly cleaner possession proxy."
      ),
      list(
        col = "PDO",
        def = "Team shooting% + goalie SV% while player was on ice × 100. Values near 100 are 'neutral'; much above/below may indicate luck."
      ),
      list(col = "AvgTOI", def = "Average time on ice per game (MM:SS)")
    ),
    exercises = list(
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "Filter + arrange: best single seasons",
        desc = "Combine filter(), arrange(), and slice_max() from R4DS Ch 3.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("nhl_data_hockey_reference")\n\n# Top 10 point seasons from 2019-2023\nnhl_data_hockey_reference |>\n  filter(season >= 2019, gp >= 60) |>\n  select(player, tm, pos, season, gp, g, a, pts) |>\n  slice_max(pts, n = 10)'
      ),
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "Trend analysis: points over seasons (group_by + summarise)",
        desc = "Compute average league-wide scoring by season — shows the 'scoring era'.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("nhl_data_hockey_reference")\n\nnhl_data_hockey_reference |>\n  filter(season >= 2019, gp >= 60) |>\n  group_by(season) |>\n  summarise(\n    n_players      = n(),\n    avg_pts        = mean(pts, na.rm = TRUE),\n    avg_goals      = mean(g, na.rm = TRUE),\n    median_cf_pct  = median(cf_percent, na.rm = TRUE)\n  )'
      ),
      list(
        phase = "Phase 3",
        book = "Fundamentals of Data Visualization",
        title = "Scatter: goals vs Corsi (possession vs production)",
        desc = "Do players who control puck possession score more? A classic hockey analytics question.",
        code = 'library(ggplot2)\nlibrary(dplyr)\nlibrary(ISAR)\ndata("nhl_data_hockey_reference")\n\nnhl_data_hockey_reference |>\n  filter(season == 2023, gp >= 50, pos != "G") |>\n  ggplot(aes(x = cf_percent, y = pts)) +\n  geom_point(alpha = 0.5) +\n  geom_smooth(method = "lm", se = FALSE) +\n  labs(x = "Corsi For % (CF%)",\n       y = "Points",\n       title = "Possession vs Production: NHL Skaters 2022-23")'
      ),
      list(
        phase = "Phase 5",
        book = "Introduction to Statistical Learning (ISLR)",
        title = "Regression: predict points from shots and CF%",
        desc = "Fit a multiple linear regression — Ch 3 of ISLR in action on hockey data.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("nhl_data_hockey_reference")\n\nskaters <- nhl_data_hockey_reference |>\n  filter(season == 2023, gp >= 50, !pos %in% c("G", "D"))\n\nmodel <- lm(pts ~ s + cf_percent + pdo, data = skaters)\nsummary(model)'
      )
    )
  ),

  list(
    key = "dk_edm_col",
    name = "DraftKings: Edmonton vs Colorado (Playoff)",
    emoji = "💰",
    level = "Intermediate",
    pkg = "ISAR",
    rows = nrow(dk_edm_col_clean),
    cols_n = ncol(dk_edm_col_clean),
    data = dk_edm_col_clean,
    desc = paste0(
      "DraftKings daily fantasy salary data for the 2022 Stanley Cup Playoff game ",
      "between the Edmonton Oilers and Colorado Avalanche (May 31, 2022). ",
      "Each row is a player's DK roster slot with their salary and average fantasy ",
      "points per game. Useful for sorting, filtering, and optimization exercises. ",
      "Connor McDavid and Nathan MacKinnon are both in here at the top salary tier."
    ),
    col_glossary = list(
      list(col = "Player", def = "Player name"),
      list(
        col = "Pos",
        def = "C (center), LW/RW (wings), D (defenseman), G (goalie)"
      ),
      list(
        col = "Team",
        def = "Team abbreviation (EDM = Edmonton, COL = Colorado)"
      ),
      list(
        col = "Roster Slot",
        def = "CPT = Captain slot (1.5× points multiplier), FLEX = regular slot"
      ),
      list(
        col = "Salary",
        def = "DraftKings salary in dollars. Total roster salary cap: $50,000"
      ),
      list(
        col = "Avg DK Pts",
        def = "Average DraftKings fantasy points per game (season average)"
      ),
      list(col = "Game", def = "Game matchup and time")
    ),
    exercises = list(
      list(
        phase = "Phase 1",
        book = "Hands-On Programming with R",
        title = "Sort and filter salary data",
        desc = "Practice HOPR Ch 4–7: pull the top-salary players and filter by team.",
        code = 'library(ISAR)\ndata("dk_edm_col")\n\n# Top 5 most expensive players\ndk_edm_col[order(dk_edm_col$salary, decreasing = TRUE), ][1:5, ]\n\n# Filter to Edmonton players only\ndk_edm_col[dk_edm_col$team_abbrev == "EDM", ]'
      ),
      list(
        phase = "Phase 2",
        book = "R for Data Science (2e)",
        title = "Value analysis: points per dollar",
        desc = "Use mutate() and arrange() to find the best 'value' players in DFS.",
        code = 'library(dplyr)\nlibrary(ISAR)\ndata("dk_edm_col")\n\ndk_edm_col |>\n  filter(roster_position == "FLEX") |>  # regular slots only\n  mutate(pts_per_k = avg_points_per_game / (salary / 1000)) |>\n  select(name, team_abbrev, position, salary, avg_points_per_game, pts_per_k) |>\n  arrange(desc(pts_per_k))'
      ),
      list(
        phase = "Phase 4",
        book = "Introduction to Sports Analytics using R",
        title = "DraftKings showdown optimization (ISAR Ch on DFS)",
        desc = "Follow the ISAR textbook chapter on DFS lineup construction with this exact dataset.",
        code = '# This dataset is the exact one used in the ISAR textbook.\n# Follow along with the DraftKings Showdown chapter.\nlibrary(ISAR)\ndata("dk_edm_col")\n\n# Total number of players available\nnrow(dk_edm_col)\n\n# Salary distribution by position\ntapply(dk_edm_col$salary, dk_edm_col$position, mean)'
      )
    )
  )
)

# Build names vector for radioButtons
dataset_names <- setNames(
  seq_along(datasets_meta),
  sapply(datasets_meta, function(d) paste(d$emoji, d$name))
)

usethis::use_data(datasets_meta, dataset_names, overwrite = TRUE)
