# Install and load required packages:

# install.packages("pdftools")
# install.packages("remotes")
# install.packages("tidyverse")
# remotes::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"), INSTALL_opts = "--no-multiarch", dependencies = c("Depends", "Imports"))
# install.packages("rJava")


library(remotes)
library(pdftools)
library(tabulizer)
library(rJava)
library(tidyverse)
library(stringr)

# Replace 'path_to_your_pdf.pdf' with the actual path to your downloaded PDF
pdf_path <- "C:\\Users\\Vishal Pahuja\\Documents\\R_code\\Walmart-10K-Reports-Optimized.pdf"

df <- extract_tables(pdf_path, pages = 56, output = "data.frame") %>% as.data.frame()
df[1,] <- df[1,] %>% str_remove_all("[$]") %>% trimws()

# Assuming we need to clean up column names and remove special characters
colnames(df) <- gsub("[^a-zA-Z0-9.]", "", colnames(df))

# Assuming we want to convert character columns to numeric for further analysis
df[, -1] <- lapply(df[, -1], function(x) as.numeric(gsub(",", "", x)))

# Removing columns with all NA values
df_cleaned <- df %>% select_if(~ !all(is.na(.)))

# Print the cleaned table:
print(df_cleaned)

# For a more interactive exploration of the data:
view(df_cleaned)

#export the data frame to a CSV file
write.csv(df_cleaned, file = "Final_Output.csv", row.names = FALSE)
