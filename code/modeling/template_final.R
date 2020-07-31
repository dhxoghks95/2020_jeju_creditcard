# 0. Importing Package
library(tidyverse)

# 1. Importing Datas
template = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/template_july.csv")
template = template %>% select(-X1)

rain = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/rain_july.csv")


indst = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/total_sale_by_indst_july.csv")

indst = indst %>% select(-X1)

tourist = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/tourist_july.csv")

pop = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/pop_july.csv")

corona = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/Corona_july_predicted.csv")

corona = corona %>% select(-X1)


total_home = read_csv("https://raw.githubusercontent.com/dhxoghks95/2020_jeju_creditcard/master/data/total_home_july.csv")

total_home = total_home %>% select(-X1)
total_home = total_home %>% select(-HOM_SIDO_NM) %>% unique()
# 3. merging data

template = template %>% left_join(rain, by = c("month", "CARD_SIDO_NM"))

template = template %>% left_join(indst, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))

template = template %>% left_join(tourist, by = c("year",  "month", "CARD_SIDO_NM"))

template = template %>% left_join(pop, by = c("CARD_SIDO_NM", "SEX_CTGO_CD", "AGE"))

template = template %>% mutate(festival_count = 0)

template = template %>% left_join(corona, by = c("CARD_SIDO_NM","year","month" ))

template = template %>% left_join(total_home, by = c("month", "CARD_SIDO_NM"))

write.csv(template, "template_final.csv", row.names = F)
