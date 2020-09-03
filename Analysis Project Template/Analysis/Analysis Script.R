# SETUP             #### #### #### #### #### #### #### #### #### #### #### ####
#
# All library calls and global option settings go here
#
library(readxl)
library(writexl)
library(dplyr)

source("./Functions/Utils.R")
source("./Functions/Functions.R")

# LOAD DATA         #### #### #### #### #### #### #### #### #### #### #### ####
raw_employee_data <- readxl::read_xlsx()
raw_sales_data <- readxl::read_xlsx()

# CLEAN DATA        #### #### #### #### #### #### #### #### #### #### #### ####
clean_employee_data <- raw_employee_data %>% 
  dplyr::mutate(XXX)

clean_sales_data <- raw_sales_data %>% 
  dplyr::mutate(XXX)

clean_data <- 
  merge_data() %>% 
  add_indicators() %>% 
  beautify()

# VISUALIZE DATA    #### #### #### #### #### #### #### #### #### #### #### ####
#
# Tables and graphs go here
#

# EXPORT DATA       #### #### #### #### #### #### #### #### #### #### #### ####
writexl::write_xlsx(clean_data, "./Clean Data/Clean_Data.xlsx")
