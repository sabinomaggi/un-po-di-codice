#!/usr/local/bin/Rscript

# load the required libraries
library(pdftools)
library(tidyverse)

# script setup
SEPARATOR <- .Platform$file.sep

# Select the pdf file to process:
# (1) uncomment the line below to run the script from the command line
filename <- commandArgs(trailingOnly = TRUE) %>% basename()
# (2) uncomment one of the two lines below when using RStudio
# filename = "file-da-convertire.pdf"
# filename <- file.choose() %>% basename()

filename_without_extension <- sub(".pdf$", "", filename)


# step #1: read the pdf file and extract the text content 
# trying to keep the layout of the original file
msg <- paste("Reading", filename, sep = " ")
cat(msg, fill = TRUE)
text <- pdf_text(filename) %>% 
    readr::read_lines(skip_empty_rows = FALSE)

# save the extracted text as a csv file
out_filename  <-  paste0(filename_without_extension, ".csv")
msg <- paste("Saving ", out_filename, sep = " ")
cat(msg, fill = TRUE)
write.csv(text, file = out_filename, row.names = TRUE)


# step #2: remove multiple spaces and fix lines
clean_text <- text %>%
    str_squish() %>%
    str_replace_all(" ", " ")

# save cleaned up text as another csv file
out_filename  <-  paste0(filename_without_extension, "-clean.csv")
msg <- paste("Saving ", out_filename, sep = " ")
cat(msg, fill = TRUE)
write.table(clean_text, file = out_filename, row.names = FALSE, quote = FALSE, sep = ", ")
