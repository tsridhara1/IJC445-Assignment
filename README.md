# REGIONAL ENTERPRISE DYNAMICS IN THE UK: A COMPOSITE VISUAL ANALYSIS OF CHURN, NET CHANGE, AND SURVIVAL (ONS BUSINESS DEMOGRAPHY, 2019–2024)

## This project analyses the UK Office for National Statistics (ONS) Business demography reference tables to understand how enterprise births, deaths, net enterprise change, and survival outcomes vary across UK regions over 2019–2024. The project produces a 2×2 composite visualisation (scatter, bump chart, heatmap, and stacked bars) designed for comparative interpretation of “dynamism vs resilience” in regional enterprise ecosystems.

## Research Questions

1. **Regional enterprise dynamics (2019–2024):**  
   How do enterprise births, deaths, net enterprise change, and churn intensity compare across UK regions from 2019 to 2024, when standardised by the active enterprise stock?

2. **Resilience via survival outcomes (2019 cohort):**  
   Where does survival “fall away” across regions for the 2019 enterprise birth cohort (1→2, 2→3, 3→4, 4→5 year intervals), and what does this imply for regional resilience narratives?

## Data Source
- **ONS Business Demography reference tables** (Excel workbook):  
  `businessdemographyexceltables2024.xlsx`
The workflow reads regional births, deaths, and active enterprises (Tables 1.1*, 2.1*, 3.1*) and regional survival (Table 4.1), then derives rate-based indicators to enable fair cross-region comparisons.


## Analytical Techniques

### 1) Data Cleaning and Structuring
- Import ONS reference tables using `readxl`
- Convert ONS placeholders (e.g., `":"`) to missing values (`NA`)
- Standardise region identifiers and reshape to tidy format (region-year panel)

### 2) Rate Construction (comparability across regions)
Derived indicators are computed from ONS counts:
- **Births per 100 active enterprises** = 100 × births / active
- **Deaths per 100 active enterprises** = 100 × deaths / active
- **Churn per 100 active** = births_per100 + deaths_per100
- **Net change per 100 active** = births_per100 − deaths_per100

### 3) Composite Visualisation (2×2 dashboard)
The primary output is a composite layout of four charts:

1. **Churn portfolio (Scatter plot, 2024)**  
   Births per 100 active (x) vs deaths per 100 active (y), with active enterprise stock encoded by colour.

2. **Churn rank shifts (Bump/Slope chart, 2019→2024)**  
   Regions ranked by churn (births+deaths per 100 active), showing movement between 2019 and 2024.

3. **Net-change intensity (Heatmap, 2019–2024)**  
   Net change per 100 active across years, ordered by 2024 net intensity for interpretability.

4. **Where survival falls (Horizontal stacked bars, 2019 cohort)**  
   Interval drops in survival (1→2, 2→3, 3→4, 4→5 years), focusing on top regions by 5-year survival.



## Setup Instructions
1. Prerequisites
Ensure the following are installed:
- R: Version 4.0+
- RStudio
- Git (optional, for version control)
2. Install R and R Studio
  - Download https://posit.co/download/rstudio-desktop/ (Windows/macOS).
  - Use your package manager (Linux).
4. Clone the Repository
- To clone the repository from GitHub: git clone https://github.com/tsridhara1/IJC445-Assignment.git
- Open the `IJC445-Assignment` file in your RStudio working directory.
5. Run Scripts
- viz_code.R
- Make sure the dataset (businessdemographyexceltables2024.xlsx) and 'viz_code.R' are in the working directory.
- Note: You can see the working directory by using 'getwd()'.


## Key Outputs
### Composite Visualisation (2×2):
1. composite_view.png

### Individual chart exports:
1. chart1_churn_portfolio_2024.png
2. chart2_churn_rank_shifts_2019_2024.png
3. chart3_net_change_heatmap_2019_2024.png
4. chart4_survival_attrition_2019_cohort.png

## Key Insights 
### Regional churn and net change (2019–2024)
- Regional enterprise dynamics are heterogeneous even after normalising by active enterprise stock. Some regions occupy a “high churn” profile (high births and high deaths per 100 active), while others reflect lower turnover.
- Relative churn standing (rank) changes between 2019 and 2024 for certain regions, suggesting that single-year snapshots can be misleading when used alone.
- Net change intensity is not uniform across years; the heatmap highlights year-by-year shifts that are not visible from a 2024-only view.

### Survival resilience (2019 cohort)
- Survival losses are not evenly distributed across time; attrition is commonly concentrated in earlier intervals (e.g., 1→2 years), supporting a resilience interpretation that is distinct from annual churn.
- Comparing churn alongside survival helps avoid simplistic conclusions (e.g., “high churn is always good/bad”) by introducing a longer-run persistence lens.

## Limitations
- The analysis is constrained to variables and formatting provided in the published ONS reference tables.
- Rates per 100 active improve comparability, but regional comparisons can still reflect structural differences (sector mix, firm size distribution, and macro conditions).
- Visualisations are descriptive, not causal; they identify patterns rather than mechanisms.

## Future Work
- Extend the composite by integrating sector-level dynamics (SIC group profiles) and linking churn patterns to survival outcomes.
- Add uncertainty/context notes (e.g., definitional constraints, revisions) as part of reproducible metadata reporting.
- Evaluate forecasting baselines (if added later) against time-series methods (ETS/ARIMA) and quantify whether complexity yields meaningful performance gains.
- Automate table validation (sheet existence, header detection, type checks) to make the pipeline more robust to ONS format updates.
