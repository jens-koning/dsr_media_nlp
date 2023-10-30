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

#### 3. Filter news media by location  ####
#### Chinese media 
labled_data$China_media <- 0
for (i in 1:nrow(labled_data)) {
  if (grepl("\\.cn$", labled_data$clean_url[i])) {
    labled_data$China_media[i] <- 1
  }
}
# add chinese .com news sources 
for (i in 1:nrow(labled_data)) {
  if (grepl("xinhuanet.com|cgtn.com|sina.com|china-embassy.org|cctv.com|huawei.com", labled_data$clean_url[i])) {
    labled_data$China_media[i] <- 1
  }
}

#### India media
labled_data$India_media <- 0
for (i in 1:nrow(labled_data)) {
    if (grepl("\\.in$", labled_data$clean_url[i])) {
      labled_data$India_media[i] <- 1
    }
}
# add indian media with .com domain
for (i in 1:nrow(labled_data)) {
  if (grepl("devdiscourse.com|india.com|financialexpress.com|news18.com|firstpost.com|sify.com|
            indiatimes.com|businesstoday.in|indianexpress.com|deccanchronicle.com|businessworld.in|business-standard.com|
            scroll.in|thequint.com|hindustantimes.com|thehindu.com", labled_data$clean_url[i])) {
    labled_data$China_media[i] <- 1
  }
}

#### Japanese media
labled_data$Japan_media <- 0
for (i in 1:nrow(labled_data)) {
  if (grepl("\\.jp$", labled_data$clean_url[i])) {
    labled_data$Japan_media[i] <- 1
  }
}
# add japnese media with .com domain
for (i in 1:nrow(labled_data)) {
  if (grepl("japantoday.com|asahi.com|nippon.com|jpost.com", labled_data$clean_url[i])) {
    labled_data$Japan_media[i] <- 1
  }
}

#### US/European/Korea/Taiwan media 
labled_data$US_allies_media <- 0 
# manually add US/European/Korea/Taiwan media 
for (i in 1:nrow(labled_data)) {
  if (grepl("cfr.org|thediplomat.com|thehill.com|nationalinterest.org|bignewsnetwork.com|defenseone.com|techspot.com|globenewswire.com|yahoo.com|businesswire.com|financialcontent.com|benzinga.com|foreignpolicy.com|axios.com|businessinsider.com|thestreet.com|chathamhouse.org|businessinsider.nl|atlanticcouncil.org|greekreporter.com|prnewswire.com|nikkei.com|canberratimes.com.au|
            adnkronos.com|tmcnet.com|wbtv.com|nbc12.com|apnews.com|finanznachrichten.de|scoop.co.nz|telegraph.co.uk|france24.com|newsnow.co.uk|prnewswire.co.uk|lightreading.com|defensenews.com|kptv.com|newswire.ca|fox19.com|wcax.com|einnews.com|hawaiinewsnow.com|theguardian.com|google.com|zerohedge.com|mehrnews.com|streetinsider.com|substack.com|thetimes.co.uk|thewest.com.au|
            marketscreener.com|oilprice.com|globalsecurity.org|sott.net|theepochtimes.com|dailytimes.com.pk|techcrunch.com|bloombergquint.com|politifact.com|mises.org|washingtonexaminer.com|freerepublic.com|ft.com|chosun.com|digitaljournal.com|news.com.au|koreaherald.com|cnbc.com|express.co.uk|foxbusiness.com|nbcboston.com|wilsoncenter.org|economist.com|msn.com|slideshare.net|
            ibtimes.com|foxnews.com|perthnow.com.au|7news.com.au|gazette.com|dailymail.co.uk|courthousenews.com|todayonline.com|wnd.com|financialpost.com|trust.org|thebulletin.org|theglobeandmail.com|reuters.com|haberler.com|odt.co.nz|swissinfo.ch|bloomberg.com|nationalpost.com|rfa.org|politico.eu|stuff.co.nz|netscape.com|breitbart.com|forbes.com|wordpress.com|theatlantic.com|
            cbn.com|nasdaq.com|globalresearch.ca|taiwannews.com.tw|abc.net.au|unz.com|csis.org|duluthnewstribune.com|inforum.com|independent.co.uk|foreignaffairs.com|washingtontimes.com|afr.com|aol.com|lexology.com|dw.com|lawfareblog.com|politico.com|listverse.com|salon.com|thenation.com|counterpunch.org|alternet.org|elpais.com|
            bbc.co.uk|bbc.com|mylondon.news|mondediplo.com|newsweek.com|theregister.com|thefederalist.com|follow.it|rferl.org|sydney.edu.au|lareviewofbooks.org|buzzfeednews.com|techradar.com|hrw.org|wn.com|itproportal.com|freedomhouse.org|texasmonthly.com",
            labled_data$clean_url[i])) {
    labled_data$US_allies_media[i] <- 1
  }
}

#### SEA media 
labled_data$ASEAN_media <- 0
for (i in 1:nrow(labled_data)) {
  if (grepl("straitstimes.com|cnnphilippines.com|bangkokpost.com|channelnewsasia.com|asiatimes.com|scmp.com|asiaone.com|thestar.com.my|inquirer.net|manilatimes.net|dhakatribune.com|todayonline.com|rappler.com|abs-cbn.com|thejakartapost.com|info.gov.hk|asiasociety.org",
            labled_data$clean_url[i])) {
    labled_data$ASEAN_media[i] <- 1
  }
}

#### Other media
labled_data$Other_media <- 0
for (i in 1:nrow(labled_data)) {
  if (grepl("menafn.com|alarabiya.net|guardian.ng|rt.com|sputniknews.com|businesslive.co.za|vanguardngr.com|al-monitor.com|nation.com.pk|africanews.com|
zawya.com|undp.org|thedailystar.net|tribune.com.pk|voanews.com|weforum.org|arabnews.com|standardmedia.ke|dawn.com|khaleejtimes.com|aljazeera.com|belta.by|allafrica.com|dailysabah.com|thenationalnews.com|tasnimnews.com|iol.co.za|gulf-times.com|thenews.com.pk|mg.co.za|albawaba.com|heritage.org|mdpi.com|hindawi.com|protocol.com",
            labled_data$clean_url[i])) {
    labled_data$Other_media[i] <- 1
  }
}

#### 4. Create Dummy Variables for Different Topics ####
labled_data$Chinese_digital_alt <- 0 
labled_data$BRI_digital_coop <- 0 
labled_data$B3W_alt_BRI <- 0 
labled_data$China_gulf_coop <- 0 
labled_data$BRI_dept_trap <- 0 
labled_data$Strategic_comp <- 0 
labled_data$HR_abuse_Xinjiang <- 0 
labled_data$IOT_digiservice <- 0 
labled_data$China_ASEAN_rcep <- 0 
labled_data$China_Arab_ningxia <- 0 
labled_data$Tech_education <- 0 
labled_data$Xi_CCP <- 0
labled_data$Central_asia_coop <- 0
labled_data$CIIE_expo_tech_export <- 0

# loop through and assign values to dummy variables  
for (i in 1:nrow(labled_data)) {
  if (grepl("Chinese Digital Alternative", labled_data$topic_label[i])) {
    labled_data$Chinese_digital_alt[i] <- 1
  }
  if (grepl("BRI Digital Cooperation", labled_data$topic_label[i])) {
    labled_data$BRI_digital_coop[i] <- 1
  }
  if (grepl("B3W as Alternative to BRI", labled_data$topic_label[i])) {
    labled_data$B3W_alt_BRI[i] <- 1
  }
  if (grepl("GCC and China-Gulf Cooperation", labled_data$topic_label[i])) {
    labled_data$China_gulf_coop[i] <- 1
  }
  if (grepl("BRI Dept Trap", labled_data$topic_label[i])) {
    labled_data$BRI_dept_trap[i] <- 1
  }
  if (grepl("Strategic Competition", labled_data$topic_label[i])) {
    labled_data$Strategic_comp[i] <- 1
  }
  if (grepl("Technology and HR Abuses in Xinjiang", labled_data$topic_label[i])) {
    labled_data$HR_abuse_Xinjiang[i] <- 1
  }
  if (grepl("IOT and Digital Services", labled_data$topic_label[i])) {
    labled_data$IOT_digiservice[i] <- 1
  }
  if (grepl("China-ASEAN digital trade & RCEP", labled_data$topic_label[i])) {
    labled_data$China_ASEAN_rcep[i] <- 1
  }
  if (grepl("Ningxia Expo and China-Arab Cooperation", labled_data$topic_label[i])) {
    labled_data$China_Arab_ningxia[i] <- 1
  }
  if (grepl("Technology Education", labled_data$topic_label[i])) {
    labled_data$Xi_CCP[i] <- 1
  }
  if (grepl("Xi Jinping and Chinese Communist Party", labled_data$topic_label[i])) {
    labled_data$Xi_CCP[i] <- 1
  }
  if (grepl("Central Asia", labled_data$topic_label[i])) {
    labled_data$Central_asia_coop[i] <- 1
  }
  if (grepl("CIIE Expo and Chinese Tech Export", labled_data$topic_label[i])) {
    labled_data$CIIE_expo_tech_export[i] <- 1
  }
}

#### 5. Regression Analysis #### 

#Fitting binomial regression models
mod1 <- glm(Chinese_digital_alt ~ US_allies_media, 
                         family = binomial, data = labled_data)
mod2 <- glm(Chinese_digital_alt ~ China_media,
                            family = binomial, data = labled_data)
mod3 <- glm(BRI_digital_coop ~ US_allies_media,
                         family = binomial, data = labled_data)
mod4 <- glm(BRI_digital_coop ~ China_media,
                            family = binomial, data = labled_data)

#asean media focus
mod_5 <- glm(Chinese_digital_alt ~ ASEAN_media,
                              family = binomial, data = labled_data)
mod_6 <- glm(BRI_digital_coop ~ ASEAN_media,
                              family = binomial, data = labled_data)

#indian media focus
#log_mod_4_indiamedia_1 <- glm(Chinese_digital_alt ~ India_media, family = binomial, data = labled_data)
#log_mod_4_indiamedia_2 <- glm(BRI_digital_coop ~ India_media, family = binomial, data = labled_data)

# explore models with stargazer
stargazer(mod_1_usmed, mod_1_chmed, type="text")
stargazer(mod_2_usmed, mod_2_chmed, type="text")
stargazer(mod_3_aseanmed_1, mod_3_aseanmed_2, type="text")
stargazer(mod1, mod2, mod3, mod4, mod_5, mod_6, type="text")
# create latex table
latex_table <- stargazer(mod1, mod2, mod3, mod4, mod_5, mod_6)

#### 6. Making marginal effects plot ####
library(broom)
library(ggtheme)

# Get tidy data frames of the coefficients, including confidence intervals
tidy_mod3 <- tidy(mod3, conf.int = TRUE)
tidy_mod4 <- tidy(mod4, conf.int = TRUE)
tidy_mod6 <- tidy(mod_6, conf.int = TRUE)


# Add a column to indicate which model each coefficient belongs to
tidy_mod3$model <- "US & Allies Media (Mod 3)"
tidy_mod4$model <- "China State Media (Mod 4)"
tidy_mod6$model <- "ASEAN Media (Mod 6)"

# Combine the results into one data frame
results <- rbind(tidy_mod3, tidy_mod4, tidy_mod6)

# Filter the results to include only the terms of interest (if necessary)
results <- results[results$term != "(Intercept)", ]

# Convert the log-odds and their confidence intervals to probabilities
results <- results %>%
  mutate(
    prob = exp(estimate) / (1 + exp(estimate)),
    conf.low = exp(conf.low) / (1 + exp(conf.low)),
    conf.high = exp(conf.high) / (1 + exp(conf.high))
  )

# Make the plot
plot <- ggplot(results, aes(x = model, y = prob, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar(position = position_dodge(width = 0.2), width = 0.1, size = 1.2, color = "lightblue") +
  geom_point(position = position_dodge(width = 0.2), size = 3, color = "grey60") +
  labs(y = "Predicted Probability", x = NULL) +
  scale_y_continuous(labels = scales::percent_format(), breaks = seq(0, 1, by = 0.25), limits = c(0, 1)) +
  theme_minimal() +
  theme(panel.border = element_rect(colour = "grey60", fill=NA, size=0.5)) +
  coord_flip()
ggsave("pred_medialoc_BRIcoop.jpg", plot, width = 20, height = 7, units = "cm")

