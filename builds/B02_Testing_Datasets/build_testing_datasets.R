pacman::p_load(tidyverse, tidytext, here, tools, glue)

# Dependencies:
# Requires data files retrieved by running the following script
# data/D01_SwiftKey/download_swiftkey_data.R

# Load the file paths English data files
en_files <- list.files(path = here("data/D01_SwiftKey/final/en_US"),
                       full.names = T)

training_sets <- read_csv(here("builds/B01_Sample_Dataset/all_sample_entries.csv"))

# Helper function to read in a data file, select a fractional sample, and return 
# a data frame which includes the name of the source file and the original line number

read_data <- function(file) {
   filename <- basename(file_path_sans_ext(file))
   
   data <- read_lines(file) %>%
      as_tibble() %>%
      mutate(source_line = row_number(),
             source = filename)
   
   return(data)
}

set.seed(521)

corpus <- map_df(en_files, read_data) %>%
   anti_join(training_sets) %>%
   sample_n(100000) %>%
   unnest_tokens(sentence, value, token = "sentences") %>%
   sample_n(nrow(.))

write_test_set <- function(start, data = corpus) {
   file_name <- here(glue("builds/B02_Testing_Datasets/testing_set_{start%/%500}.csv"))
   write_csv(data[start:(start+499),], file_name)
}

walk(seq(1, 10000, by = 500), write_test_set)
