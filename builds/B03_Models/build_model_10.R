## Build N-Grams on 10% data set
script_start <- Sys.time()
args <- commandArgs(trailingOnly = T)

print(args[1])

pacman::p_load(tidyverse, tidytext, tokenizers, here, glue, stringr)

bad_words <- paste0(read_lines(here("data/D02_bad_words/bad_words.txt")), collapse = "|")

ngram_score <- function(grams, data) {
   data %>%
      unnest_tokens(ngram, value, token = "ngrams", n = grams) %>%
      filter(!is.na(ngram),
             !str_detect(ngram, bad_words),
             !grepl("[[:digit:]]|(^| )[[:punct::]]( |$)|_", ngram)) %>%
      mutate(word = word(ngram, -1)) %>%
      mutate(ngram = str_trim(str_replace(ngram, paste0(word, "$"), ""))) %>%
      count(ngram, word, sort = T) %>%
      group_by(ngram) %>%
      mutate(score = n / sum(n),
             n_grams = grams) %>%
      arrange(desc(score)) %>%
      ungroup() %>%
      write_csv(here(glue("builds/B03_Models/sample10_{grams}grams.csv")))
}

sample_10 <- read_csv(here("builds/B01_Sample_Dataset/sample_dataset_10.csv"),
                      col_types = "cic")

ngram_score(as.integer(args[1]) ,data = sample_10)

script_end <- Sys.time()

print(script_end - script_start)