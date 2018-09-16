# Build a sample dataset that will be easier to work with in our analysis

pacman::p_load(tidyverse, here, tools)

# Dependencies:
# Requires data files retrieved by running the following script
# data/D01_SwiftKey/download_swiftkey_data.R

# Load the file paths English data files
en_files <- list.files(path = here("data/D01_SwiftKey/final/en_US"),
                       full.names = T)

# Helper function to read in a data file, select a fractional sample, and return 
# a data frame which includes the name of the source file and the original line number

read_sample <- function(file, sample_size, seed = 11885) {
   set.seed(seed)
   
   filename <- basename(file_path_sans_ext(file))
   
   data <- read_lines(file) %>%
      as_tibble() %>%
      mutate(source_line = row_number(),
             source = filename) %>%
      sample_frac(size = sample_size)
   
   return(data)
}

# Collect a 0.1% sample from all English data files and combine into a single data frame

sample_data <- map_df(en_files, read_sample, sample_size = 0.001)

# Save the sample data as a csv file for later use

write_csv(sample_data, here("builds/B01_Sample_Dataset/sample_dataset.csv"))

