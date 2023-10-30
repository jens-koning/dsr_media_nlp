####    \\    Maps and plots     //    ####

# Clear working environment and install needed packages
rm(list=ls(all = TRUE))

#### 1. Load needed packages and data ####
# Loading packages
my_packages <- c("tidyverse", "readr", "sf", "")
lapply(my_packages, require, character.only = TRUE)

#### 