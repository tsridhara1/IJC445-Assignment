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
