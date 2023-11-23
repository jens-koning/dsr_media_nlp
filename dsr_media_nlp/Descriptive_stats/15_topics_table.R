####    \\    Create table of 15 topipcs    //    ####

# Clear working environment and install needed packages
rm(list=ls(all = TRUE))

#### 1. Load needed packages and data ####
# Loading packages
my_packages <- c("tidyverse", "readr", "xtable")
lapply(my_packages, require, character.only = TRUE)

# Loading data
top_15 <- read.csv(
  "~/Documents/Python_projects/dsr_media_nlp/dsr_media_nlp/Topic_model/top_15_topics.csv", 
  sep = ",")

#### 2. Create tables ####
top_15_clean <- top_15 %>% select(
  -c(Representative_Docs)
)

top_15_clean_ltx <- xtable(top_15_clean)
