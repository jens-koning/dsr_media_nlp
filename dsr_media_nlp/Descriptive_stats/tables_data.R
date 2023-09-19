####    \\    Create descriptives for    //    ####

# Clear working environment and install needed packages
rm(list=ls(all = TRUE))

#### 1. Load needed packages and data ####
# Loading packages
my_packages <- c("tidyverse", "readr", "xtable")
lapply(my_packages, require, character.only = TRUE)

# Loading data
extracted_news_articles_countryspes <- read.csv(
  "~/Documents/Python_projects/dsr_media_nlp/dsr_media_nlp/Script_api/extracted_news_articles_countryspes.csv", 
  sep = ";")

#### 2. Create tables ####

# some data cleaning
extracted_news_articles_countryspes <- extracted_news_articles_countryspes %>% select(
  -c(X, author, published_date_precision, clean_url, rights, authors, media, is_opinion, 
     twitter_account, X_score, X_id, rank, topic, used_params)
)

# shorten number of characters per row
extracted_news_articles_countryspes <- extracted_news_articles_countryspes %>%
  mutate(across(where(is.character), ~substr(., 1, 25)))


extracted_news_articles_countryspes_latex <- xtable(extracted_news_articles_countryspes)

