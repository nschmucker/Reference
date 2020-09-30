# This file holds various utility functions
# To load these functions, call source("./03_Functions/Utils.R")

# Function to capitalize the first letter of each word
totitle <- function(x) {
  s <- strsplit(x, " |_")[[1]]
  paste(
    toupper(substring(s, 1, 1)), tolower(substring(s, 2)),
    sep = "", collapse = " "
  )
}