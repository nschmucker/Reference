# This file holds various functions for use in analysis / presentation
# To load these functions, call source("./Functions/Functions.R")
library(dplyr)
library(forcats)

# Function to merge my datasets
merge_data <- function() {
  temp_employee <- dplyr::mutate(clean_employee_data, KEY = XXX)
  temp_sales <- dplyr::mutate(clean_sales_data, KEY = YYY)
  
  dplyr::left_join(temp_employee, temp_sales, by = "KEY")
}

# Function to calculate indicator variables
add_indicators <- function(df) {
  
}

# Function to do final aesthetic cleanup (convert characters to factors, drop 
#  unneeded variables, arrange by date, etc.)
beautify <- function(df) {
  df %>% 
    dplyr::mutate(TEXT_COL = toupper(TEXT_COL)) %>% 
    dplyr::mutate(across(where(is.character), forcats::as_factor)) %>% 
    dplyr::select(-SOME_VARIABLE) %>% 
    dplyr::arrange(EMPLOYEE_ID, SALES_DATE)
}

# Function to plot a metric of choice
plot_metric <- function(df, metric) {
  
}