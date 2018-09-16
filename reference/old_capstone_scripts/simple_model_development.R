library(tidytext)
library(tidyverse)

#Load data
blog_sample <- read_lines("blogs.sample.txt")
news_sample <- read_lines("news.sample.txt")
twitter_sample <- read_lines("twitter.sample.txt")
bad_words <- data_frame(words = read_lines("badWords.txt"))

data_corpora <- c(blog_sample, news_sample, twitter_sample)

data_corpora <- data_frame(text=data_corpora)

onegrams <- data_corpora %>% unnest_tokens(words,text,token="words") %>%
    anti_join(bad_words) %>%
    count(words,sort=T) %>%
    rename(input = words)

twograms <- data_corpora %>% unnest_tokens(words,text,token="ngrams",n=2) %>%
    anti_join(bad_words) %>% separate(words,c("word1","word2"), sep=" ") %>%
    filter(!word1 %in% bad_words$words) %>% filter(!word2 %in% bad_words$words) %>%
    count(word1, word2, sort=T) %>% rename(input=word1, output=word2)

trigrams <- data_corpora %>% unnest_tokens(words,text,token="ngrams",n=3) %>%
    anti_join(bad_words) %>% 
    separate(words,c("word1","word2","word3"), sep=" ") %>%
    filter(!word1 %in% bad_words$words) %>% filter(!word2 %in% bad_words$words) %>%
    filter(!word3 %in% bad_words$words) %>% count(word1, word2, word3, sort=T) %>%
    unite(input, word1, word2,sep = " ") %>% rename(output = word3)

calc_discount <- function(data, k=5) {
    data$discount <-1
    
    for (i in k:1) {
        R <- i
        R_prime <- i + 1
        
        N <- sum(data$n == R)
        N_prime <- sum(data$n == R_prime)
        
        D <- (R_prime/R) * (N_prime/N)
        
        data$discount[data$n == R] <- D
    }
    
    return(data)
}
    
leftOverProb <- function(data) {
    left_Over_Prob <- data %>% group_by(input) %>% 
        mutate(discount_n=discount*n) %>%
        summarise(total_DN=sum(discount_n),total_N=sum(n)) %>%
        mutate(leftProb = 1-total_DN/total_N) %>%
        select(input,leftProb)
    return(left_join(data,left_Over_Prob))
}
