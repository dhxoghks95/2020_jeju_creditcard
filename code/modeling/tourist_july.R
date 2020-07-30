library(tidyverse)


tourist = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/외래관광객.csv")
tourist = tourist %>% select(-X1)
tourist_came = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/관광객입도현황.csv")
tourist_came = tourist_came %>% select(-X1)

tourist_jeju = tourist_came %>% filter(year == 2019)


colnames(tourist) = c("year", "month", "CARD_SIDO_NM", "total_tourist")

colnames(tourist_came) = c("year", "month", "CARD_SIDO_NM", "total_tourist")

ratio = tourist_came %>% filter(year == 2019) %>% select(total_tourist) / tourist %>% filter(CARD_SIDO_NM == "제주") %>% select(total_tourist)

ratio_num = ratio %>% unlist() %>% mean()

tourist = tourist %>% mutate(total_tourist = total_tourist * ratio_num)

tourist = tourist %>% filter(CARD_SIDO_NM != "제주")

tourist = rbind(tourist, tourist_came)

tourist = tourist %>% mutate(total_tourist = round(total_tourist))

tourist_july = rbind(tourist %>% filter(month == 7), tourist_jeju %>% filter(month == 7))

tourist_july = tourist_july %>% unique()

tourist_july = tourist_july %>% mutate(year = 2020)

write.csv(tourist_july, "tourist_july.csv")

