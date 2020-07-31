library(tidyverse)

data = read.csv("april_add_merge_with_homeproportion.csv")

data = data %>% select(-X)

weather = data %>% select(month, CARD_SIDO_NM, rain_day) %>% filter(month == 7) %>% unique()

write.csv(weather, "rain_july.csv")



