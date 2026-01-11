# 0) Installing and reading packages

packages <- c(
  "readxl","dplyr","tidyr","stringr","ggplot2","scales",
  "forcats","ggrepel","viridis","colorspace", "patchwork"
)
missing <- packages[!packages %in% rownames(installed.packages())]
if (length(missing) > 0) install.packages(missing, dependencies = TRUE)

library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)
library(forcats)
library(ggrepel)
library(viridis)
library(patchwork)
library(colorspace)


# 1) Loading Excel file

file_path <- "businessdemographyexceltables2024.xlsx"
stopifnot(file.exists(file_path))


# 2) Helper functions

region_regex <- "^(E12[0-9]{6}|W92000004|S92000003|N92000002)$"

to_num <- function(x) {
  x <- str_trim(as.character(x))
  x <- na_if(x, ":")
  suppressWarnings(as.numeric(x))
}

make_region_pretty <- function(x) {
  x <- str_squish(as.character(x))
  str_to_title(str_to_lower(x))
}

make_key <- function(x) {
  str_to_upper(str_squish(as.character(x)))
}


# A) Reading and cleaning, Births (2019–2024) 

t11a <- read_excel(file_path, sheet = "Table 1.1a") # 2019
t11b <- read_excel(file_path, sheet = "Table 1.1b") # 2020
t11c <- read_excel(file_path, sheet = "Table 1.1c") # 2021–2023
t11d <- read_excel(file_path, sheet = "Table 1.1d") # 2024

births_19 <- t11a %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2019` = 3) %>%
  mutate(`2019` = to_num(`2019`))

births_20 <- t11b %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2020` = 3) %>%
  mutate(`2020` = to_num(`2020`))

births_21_22_23 <- t11c %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:5) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2021` = 3, `2022` = 4, `2023` = 5) %>%
  mutate(
    `2021` = to_num(`2021`),
    `2022` = to_num(`2022`),
    `2023` = to_num(`2023`)
  )

births_24 <- t11d %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2024` = 3) %>%
  mutate(`2024` = to_num(`2024`))

births_all <- births_19 %>%
  left_join(births_20 %>% select(RegionCode, `2020`), by = "RegionCode") %>%
  left_join(births_21_22_23 %>% select(RegionCode, `2021`, `2022`, `2023`), by = "RegionCode") %>%
  left_join(births_24 %>% select(RegionCode, `2024`), by = "RegionCode") %>%
  mutate(
    RegionName = make_region_pretty(RegionName_raw),
    RegionKey  = make_key(RegionName_raw)
  )


# B) Reading and cleaning: Deaths (2019–2024)  

t21a <- read_excel(file_path, sheet = "Table 2.1a")
t21b <- read_excel(file_path, sheet = "Table 2.1b")
t21c <- read_excel(file_path, sheet = "Table 2.1c")
t21d <- read_excel(file_path, sheet = "Table 2.1d")

deaths_19 <- t21a %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2019` = 3) %>%
  mutate(`2019` = to_num(`2019`))

deaths_20 <- t21b %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2020` = 3) %>%
  mutate(`2020` = to_num(`2020`))

deaths_21_22_23 <- t21c %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:5) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2021` = 3, `2022` = 4, `2023` = 5) %>%
  mutate(
    `2021` = to_num(`2021`),
    `2022` = to_num(`2022`),
    `2023` = to_num(`2023`)
  )

deaths_24 <- t21d %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2024` = 3) %>%
  mutate(`2024` = to_num(`2024`))

deaths_all <- deaths_19 %>%
  left_join(deaths_20 %>% select(RegionCode, `2020`), by = "RegionCode") %>%
  left_join(deaths_21_22_23 %>% select(RegionCode, `2021`, `2022`, `2023`), by = "RegionCode") %>%
  left_join(deaths_24 %>% select(RegionCode, `2024`), by = "RegionCode") %>%
  mutate(RegionKey = make_key(RegionName_raw))


# C) Reading and cleaning: Active enterprises (2019–2024) 

t31a <- read_excel(file_path, sheet = "Table 3.1a")
t31b <- read_excel(file_path, sheet = "Table 3.1b")
t31c <- read_excel(file_path, sheet = "Table 3.1c")
t31d <- read_excel(file_path, sheet = "Table 3.1d")

active_19 <- t31a %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2019` = 3) %>%
  mutate(`2019` = to_num(`2019`))

active_20 <- t31b %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2020` = 3) %>%
  mutate(`2020` = to_num(`2020`))

active_21_22_23 <- t31c %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:5) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2021` = 3, `2022` = 4, `2023` = 5) %>%
  mutate(
    `2021` = to_num(`2021`),
    `2022` = to_num(`2022`),
    `2023` = to_num(`2023`)
  )

active_24 <- t31d %>%
  filter(str_detect(.[[1]], region_regex)) %>%
  select(1:3) %>%
  rename(RegionCode = 1, RegionName_raw = 2, `2024` = 3) %>%
  mutate(`2024` = to_num(`2024`))

active_all <- active_19 %>%
  left_join(active_20 %>% select(RegionCode, `2020`), by = "RegionCode") %>%
  left_join(active_21_22_23 %>% select(RegionCode, `2021`, `2022`, `2023`), by = "RegionCode") %>%
  left_join(active_24 %>% select(RegionCode, `2024`), by = "RegionCode") %>%
  mutate(RegionKey = make_key(RegionName_raw))


# D) Build region_panel (long) + derived per-100 rates

births_long <- births_all %>%
  pivot_longer(cols = matches("^20(19|20|21|22|23|24)$"),
               names_to = "year", values_to = "births") %>%
  mutate(year = as.integer(year))

deaths_long <- deaths_all %>%
  pivot_longer(cols = matches("^20(19|20|21|22|23|24)$"),
               names_to = "year", values_to = "deaths") %>%
  mutate(year = as.integer(year))

active_long <- active_all %>%
  pivot_longer(cols = matches("^20(19|20|21|22|23|24)$"),
               names_to = "year", values_to = "active") %>%
  mutate(year = as.integer(year))

region_panel <- births_long %>%
  left_join(deaths_long %>% select(RegionCode, year, deaths), by = c("RegionCode","year")) %>%
  left_join(active_long %>% select(RegionCode, year, active), by = c("RegionCode","year")) %>%
  mutate(
    RegionName = make_region_pretty(RegionName),
    RegionKey  = make_key(RegionName),
    births_per100 = 100 * births / active,
    deaths_per100 = 100 * deaths / active,
    churn_per100  = births_per100 + deaths_per100,
    net_per100    = births_per100 - deaths_per100
  ) %>%
  arrange(RegionName, year)

View(region_panel)


# E) Survival tables reader: Table 4.1 / 4.2 

read_table4_survival <- function(path, sheet_name, entity_name = c("Region", "Industry")) {
  entity_name <- match.arg(entity_name)
  
  raw <- read_excel(path, sheet = sheet_name, col_names = FALSE)
  
  header_row <- which(raw[[2]] == "Births")[1]
  if (is.na(header_row)) stop("Could not find the 'Births' header row in column 2.")
  
  df <- raw %>%
    slice((header_row + 1):n()) %>%
    select(1:12) %>%
    setNames(c(
      "Entity", "Births",
      "Surv_1", "Pct_1",
      "Surv_2", "Pct_2",
      "Surv_3", "Pct_3",
      "Surv_4", "Pct_4",
      "Surv_5", "Pct_5"
    )) %>%
    filter(!(is.na(Entity) & is.na(Births))) %>%
    mutate(across(everything(), ~ na_if(str_trim(as.character(.x)), ":"))) %>%
    mutate(CohortYear = if_else(str_detect(Entity, "^\\d{4}$"), as.integer(Entity), NA_integer_)) %>%
    tidyr::fill(CohortYear, .direction = "down") %>%
    filter(!str_detect(Entity, "^\\d{4}$")) %>%
    mutate(across(c(Births, starts_with("Surv_"), starts_with("Pct_")),
                  ~ suppressWarnings(as.numeric(.x)))) %>%
    rename(!!entity_name := Entity)
  
  list(wide = df)
}

# Regions survival (Table 4.1) for Chart 4
t41 <- read_table4_survival(file_path, "Table 4.1", entity_name = "Region")


# chart 1 — Churn portfolio (2024)

chart1_df <- region_panel %>%
  filter(year == 2024) %>%
  mutate(RegionName = make_region_pretty(RegionName))

x_mean <- mean(chart1_df$births_per100, na.rm = TRUE)
y_mean <- mean(chart1_df$deaths_per100, na.rm = TRUE)

p1 <- ggplot(chart1_df, aes(x = births_per100, y = deaths_per100)) +
  geom_vline(xintercept = x_mean, linewidth = 0.6) +
  geom_hline(yintercept = y_mean, linewidth = 0.6) +
  geom_point(aes(colour = active), size = 6, alpha = 0.9) +
  ggrepel::geom_text_repel(aes(label = RegionName), size = 3.6, max.overlaps = 50) +
  scale_colour_viridis_c(option = "viridis", name = "Active enterprises (count)") +
  labs(
    title = "Chart 1 — Churn portfolio (2024)",
    subtitle = "Births vs deaths per 100 active enterprises",
    x = "Births per 100 active enterprises",
    y = "Deaths per 100 active enterprises"
  ) +
  theme_minimal(base_size = 12)

print(p1)


# chart 2 — Churn rank shifts (2019 → 2024)

rank_df <- region_panel %>%
  filter(year %in% c(2019, 2024)) %>%
  group_by(year) %>%
  mutate(churn_rank = rank(-churn_per100, ties.method = "first")) %>%
  ungroup()

chart2_df <- rank_df %>%
  select(RegionName, year, churn_rank) %>%
  pivot_wider(names_from = year, values_from = churn_rank, names_prefix = "rank_") %>%
  mutate(RegionName = fct_reorder(RegionName, rank_2019))

View(chart2_df)

p2 <- ggplot(chart2_df) +
  geom_segment(
    aes(x = 2019, xend = 2024, y = rank_2019, yend = rank_2024, colour = RegionName),
    linewidth = 1.2, show.legend = FALSE
  ) +
  geom_text(aes(x = 2019 - 0.1, y = rank_2019, label = RegionName), hjust = 1, size = 3.6) +
  geom_text(aes(x = 2024 + 0.1, y = rank_2024, label = RegionName), hjust = 0, size = 3.6) +
  scale_x_continuous(breaks = c(2019, 2024), labels = c("2019 (rank)", "2024 (rank)")) +
  scale_y_reverse(breaks = 1:nrow(chart2_df)) +
  labs(
    title = "Chart 2 — Churn rank shifts (2019 → 2024)",
    subtitle = "Rank 1 = highest churn (births+deaths per 100 active)",
    x = NULL,
    y = "Churn rank"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.x = element_blank())

print(p2)


# chart 3 — Net-change intensity by region (2019–2024)

heat_df <- region_panel %>%
  filter(year %in% 2019:2024) %>%
  select(RegionName, year, net_per100)

region_order <- heat_df %>%
  filter(year == 2024) %>%
  arrange(desc(net_per100)) %>%
  pull(RegionName)

chart3_df <- heat_df %>%
  mutate(
    RegionName = factor(RegionName, levels = region_order),
    year = factor(year)
  )

View(chart3_df)

p3 <- ggplot(chart3_df, aes(x = year, y = RegionName, fill = net_per100)) +
  geom_tile() +
  scale_fill_viridis_c(option = "viridis", name = "Net change per 100 active") +
  labs(
    title = "Chart 3 — Net-change intensity by region (2019–2024)",
    subtitle = "(births − deaths) per 100 active enterprises",
    x = "Year",
    y = "Region (sorted by 2024 net intensity)"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid = element_blank())

print(p3)


# chart 4 — Where survival falls by region (2019 cohort) 

region_2019 <- t41$wide %>%
  filter(CohortYear == 2019, !is.na(Pct_5), Region != "Total") %>%
  select(Region, Births, Pct_1, Pct_2, Pct_3, Pct_4, Pct_5) %>%
  arrange(desc(Pct_5), desc(Births)) %>%
  slice(1:10) %>%
  mutate(
    drop_1_2 = Pct_1 - Pct_2,
    drop_2_3 = Pct_2 - Pct_3,
    drop_3_4 = Pct_3 - Pct_4,
    drop_4_5 = Pct_4 - Pct_5
  )

chart4_df <- region_2019 %>%
  select(Region, drop_1_2, drop_2_3, drop_3_4, drop_4_5) %>%
  pivot_longer(cols = starts_with("drop_"), names_to = "Interval", values_to = "Drop") %>%
  mutate(
    Interval = recode(
      Interval,
      "drop_1_2" = "1→2",
      "drop_2_3" = "2→3",
      "drop_3_4" = "3→4",
      "drop_4_5" = "4→5"
    ),

    
    Region = make_region_pretty(Region),
    Region = factor(Region, levels = rev(region_2019 %>% mutate(Region = make_region_pretty(Region)) %>% pull(Region))),
    Region = str_wrap(as.character(Region), width = 20)
  )

View(chart4_df)

p4 <- ggplot(chart4_df, aes(x = Region, y = Drop, fill = Interval)) +
  geom_col(width = 0.78) +
  coord_flip() +
  scale_fill_brewer(palette = "Set2") +
  guides(fill = guide_legend(reverse = TRUE)) +  # legend: 1→2, 2→3, 3→4, 4→5
  labs(
    title = "Chart 4 — Where survival falls by region (2019 cohort)",
    subtitle = "Top 10 regions by 5-year survival",
    x = NULL,
    y = "Survival drop (percentage points)",
    fill = "Year"
  ) +
  theme_minimal(base_size = 12)

print(p4)


#composite Viz
composite_2x2 <-
  (p1 | p2) /
  (p3 | p4) +
  plot_annotation(
    title = "UK Business Demography — Composite View",
  ) &
  theme(
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 10)
  )

print(composite_2x2)

#saving all the charts
ggsave(
  filename = "ONS_Business_Demography_Composite_2x2.png",
  plot     = composite_2x2,
  width    = 18, height = 12, dpi = 2000
)
ggsave(
  filename = "c1.png",
  plot     = p1,
  width    = 10, height = 6, dpi = 2000
)

ggsave(
  filename = "c2.png",
  plot     = p2,
  width    = 15, height = 6, dpi = 2000
)

ggsave(
  filename = "c3.png",
  plot     = p3,
  width    = 10, height = 6, dpi = 2000
)

ggsave(
  filename = "c4.png",
  plot     = p4,
  width    = 10, height = 6, dpi = 2000
)

# charts will be saved in the working directory
getwd()
