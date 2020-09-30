# This file holds various functions for use in analysis / presentation
# To load these functions, call source("./03_Functions/Functions.R")
library(dplyr)
library(purrr)
library(forcats)

# Function to merge my datasets
merge_data <- function() {
  temp_employee <- dplyr::rename(clean_employee_data, KEY = EMP_ID)
  temp_sales <- dplyr::rename(clean_sales_data, KEY = EMP_ID)
  
  dplyr::left_join(temp_employee, temp_sales, by = "KEY")
}

# Function to calculate metrics
calculate_metrics <- function(df) {
  df %>% 
    dplyr::group_by(KEY, NAME) %>% 
    dplyr::summarize(
      TOTAL_REVENUE = sum(REVENUE),
      TOTAL_VOLUME = n(),
      .groups = "drop"
    )
}

# Function to do final aesthetic cleanup (convert characters to factors, drop 
#  unneeded variables, arrange by date, etc.)
beautify <- function(df) {
  df %>% 
    dplyr::mutate(NAME = purrr::map_chr(NAME, totitle)) %>% 
    dplyr::mutate(across(where(is.character), forcats::as_factor)) %>% 
    dplyr::select(-KEY) %>% 
    dplyr::arrange(TOTAL_VOLUME, TOTAL_REVENUE)
}

# Function to plot a metric of choice
plot_metric <- function(df, metric) {
  
}