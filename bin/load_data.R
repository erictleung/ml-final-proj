# Read and Load Data Function

# Load packages
require(dplyr)

# Load data
load_data <- function() {
    red <- read.table(file = "../raw-data/winequality-red.csv",
                      header = TRUE,
                      stringsAsFactors = FALSE,
                      sep = ";") %>% tbl_df()
    white <- read.table(file = "../raw-data/winequality-white.csv",
                        header = TRUE,
                        stringsAsFactors = FALSE,
                        sep = ";") %>% tbl_df()
    list(red=red, white=white)
}