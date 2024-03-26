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
# Load required libraries
library(sf)
library(dplyr)
library(viridis)
library(rnaturalearth)

# Download world shapefile
world_shapefile <- ne_countries(scale = "medium", returnclass = "sf")

# Exclude Antarctica
world_shapefile <- world_shapefile %>%
  filter(!continent == "Antarctica")

# Assuming labeled_data is your dataset with the variable "country" containing ISO 3166-1 alpha-2 country-codes

# Step 1: Aggregate the number of observations for each country
country_counts <- labled_data %>%
  group_by(country) %>%
  summarize(count = n())

# Step 2: Merge with the world shapefile
merged_data <- merge(world_shapefile, country_counts, by.x = "iso_a2", by.y = "country", all.x = TRUE)

# Set fill color for countries with no observations to "NA"
merged_data$count[is.na(merged_data$count)] <- 0

# Step 3: Create the map and use viridis colors
plot1 <- ggplot() +
  geom_sf(data = merged_data, aes(fill = count), color = "darkgrey", size = 0.2) +
  scale_fill_viridis(name = "Number of \nNews Articles \n(log10)", trans = "log10", na.value = "transparent", labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        legend.position = "right")
ggsave("country_obs_map.jpg", plot1, width = 10, height = 6, dpi = 300)

#### 4. Count country observations with barplot   ####
# Filter countries with values greater than 1
country_counts_filtered <- country_counts %>%
  filter(count > 1)

# Reorder the levels of the "country" factor based on the "count" variable
country_counts_filtered <- country_counts_filtered %>%
  arrange(desc(count)) %>%
  mutate(country = factor(country, levels = country))

# Create the barplot
plot2 <- ggplot(country_counts_filtered, aes(x = country, y = count, fill = count)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis(name = "", trans = "log", na.value = "transparent") +
  labs(x = "Country in Focus", y = "Number of News Articles (log10)") +
  scale_y_continuous(trans = "log", labels = scales::number_format()) +  # Remove the comma separator
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "none")  # Remove the legend
ggsave("country_counts_barplot.jpg", plot2, width = 10, height = 4, dpi = 300)


#### 5. Count numebr of media articles in data ####
counts <- colSums(labled_data[, c("China_media", "India_media", "Japan_media", "US_allies_media", "ASEAN_media")])

# Create plot
plot <- ggplot(data.frame(media = names(counts), count = counts), aes(x = media, y = count)) +
  geom_bar(stat = "identity", fill = "#FF573397") + # Warm tone color
  scale_y_continuous(trans = "log", breaks = scales::trans_breaks("log10", function(x) 10^x), labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Media",
       y = "Frequency")
ggsave("media_counts_plot.jpg", plot, width = 10, height = 6, dpi = 300)

