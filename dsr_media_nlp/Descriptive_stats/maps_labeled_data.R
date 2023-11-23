####    \\   Data Preperation and Regression analysis    //    ####

# Clear working environment and install needed packages
rm(list=ls(all = TRUE))

#### 1. Load needed packages and data ####

# Loading packages
my_packages <- c("tidyverse", "readr", "xtable", "stargazer", "gtsummary", "huxtable")
lapply(my_packages, require, character.only = TRUE)

# Load data extracted_news_articles_countryspes <- read.csv(
labled_data <- read.csv("~/Documents/Python_projects/dsr_media_nlp/dsr_media_nlp/Regression_analysis/dsr_articles_berttopiced.csv", 
                        sep = ",")

#### 2. Remove unlabeled articles ####
labled_data <- labled_data %>% filter(!is.na(topic_label) & topic_label != "")

#### 3. Make map ####



#### 4. Count unique events in data ####
# US focus
count1 <- sum(grepl("US", labled_data$country, ignore.case = TRUE))
print(count1)
# China focus 
count2 <- sum(grepl("CN", labled_data$country, ignore.case = TRUE))
print(count2)
