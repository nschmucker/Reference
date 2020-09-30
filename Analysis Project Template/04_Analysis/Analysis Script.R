# SETUP             #### #### #### #### #### #### #### #### #### #### #### ####
#
# All library calls and global option settings go here
#
library(readxl)
library(writexl)
library(dplyr)
library(ggplot2)

source("./03_Functions/Utils.R")
source("./03_Functions/Functions.R")

raw_data_path <- "./01_Raw Data/Raw Data.xlsx"

# LOAD DATA         #### #### #### #### #### #### #### #### #### #### #### ####
raw_employee_data <- readxl::read_xlsx(raw_data_path, sheet = "Employee")
raw_sales_data <- readxl::read_xlsx(raw_data_path, sheet = "Sales")

# CLEAN DATA        #### #### #### #### #### #### #### #### #### #### #### ####
clean_employee_data <- raw_employee_data %>% 
  dplyr::mutate(
    TITLE = dplyr::if_else(NAME == "thomas jefferson", "diplomat", TITLE)
  )

clean_sales_data <- raw_sales_data %>% 
  dplyr::mutate(
    PRODUCT = dplyr::if_else(PRODUCT == "feather pen", "quill pen", PRODUCT)
  )

clean_data <- 
  merge_data() %>% 
  calculate_metrics() %>% 
  beautify()

# VISUALIZE DATA    #### #### #### #### #### #### #### #### #### #### #### ####
ggplot2::ggplot(clean_data, ggplot2::aes(x = NAME, y = TOTAL_REVENUE)) +
  ggplot2::geom_col() +
  ggplot2::theme_light()

# EXPORT DATA       #### #### #### #### #### #### #### #### #### #### #### ####
writexl::write_xlsx(clean_data, "./02_Clean Data/Clean_Data.xlsx")
