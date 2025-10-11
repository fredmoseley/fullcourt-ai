# Roster Projection Table (definition + print behavior)
When I’m instructed to **“print roster projections”**, I will:

**Checklist (3–7 bullets, conceptual):**

* Verify roster order and contents from `current_draft_results.tsv`.
* Pull per-game projections from `rotowire-nba-projections.csv` for each rostered player.
* Match player names; treat any missing projection fields as **0**.
* Compute team per-game sums and **attempt-weighted** FG%/FT%.
* Compute full-season totals using each player’s projected games (`G`).
* Round FG%/FT% to three decimals; leave other numbers unformatted.
* Briefly self-validate rows and totals; if validation fails, self-correct and print again.

**Table build rules:**

* Columns (exact order):
  `Player | G | PTS | 3PM | REB | AST | STL | BLK | FG% | FGA | FGM | FT% | FTA | FTM`
* One row per rostered player, in the **exact order** provided by `current_draft_results.tsv`.
* Do not produce results for rows where the player name is empty.
* If a player is not found in `rotowire-nba-projections.csv` or any field is missing, display **0** for all missing values (both in the row and in all aggregations).

**Summary row at the end:**
 1. **Team — full-season weighted averages**
     - For counting stats: multiply each player's per-game statistic by their number of games played (`G`), then sum the result across all players. For counting stats (PTS, 3PM, REB, AST, STL, BLK). Divide the sum by the total number of games played.
     - For **FG%**: compute `sum(FGM × G) / sum(FGA × G)`.
     - For **FT%**: compute `sum(FTM × G) / sum(FTA × G)`.
- 
**Formatting:**

* Return a **Markdown table** with the headers above, one row per player, then the two summary rows.
* Show **FG%** and **FT%** to **three decimal places** (e.g., `0.700`).
* All other values to **two decimal places** (no percent signs).

**Validation & error handling:**

* After generating the table, briefly confirm that all roster players are present and that the summary logic matches the rules above. If not, regenerate correctly.
* If the roster input is **malformed or missing**, output **only the table headers** in the specified format with no data rows or commentary (i.e., **print only the table**).