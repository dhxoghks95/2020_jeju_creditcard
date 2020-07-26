library(tidyverse)
library(lubridate)
library(plotly)
library(tidyquant)
setwd("C:/Users/dhxog/Desktop/데이콘/dacon_competition")
data = read.csv("final_merge.csv")

data = data %>% select(-X)

loss_rate = (data %>% filter(CARD_SIDO_NM == '제주',  month == 2 | month == 3) %>% select(YYMM, total_tourist) %>% unique() %>% filter(year(YYMM) == 2020) %>% arrange(YYMM) / data %>% filter(CARD_SIDO_NM == '제주',  month == 2 | month == 3) %>% select(YYMM, total_tourist) %>% unique() %>% filter(year(YYMM) == 2019) %>% arrange(YYMM)) %>% select(total_tourist) %>% unlist() %>% mean()


tourist = data %>% select(YYMM, CARD_SIDO_NM, total_tourist) %>% unique()

tourist_2019 = tourist %>% mutate(month = month(YYMM)) %>% filter(year(YYMM) == 2019)

tourist_2019 = tourist_2019 %>% filter(CARD_SIDO_NM != '제주')

tourist_2020_exp = tourist_2019 %>% group_by(CARD_SIDO_NM) %>% filter(month == 1 | month == 2 | month == 3) %>% select(-YYMM) %>% mutate(total_tourist = case_when(
  month == 1 ~ total_tourist,
  month == 2 | month == 3 ~ total_tourist * loss_rate
)) %>% arrange(CARD_SIDO_NM) %>% mutate(year = 2020) %>% as.data.frame()

jeju_2020 = tourist %>% filter(CARD_SIDO_NM == '제주' & year(YYMM) == 2020) %>% mutate(month = month(YYMM), year = 2020) %>% select(-YYMM) %>% as.data.frame()

tour_2020 = rbind(tourist_2020_exp, jeju_2020 )

tour_2019 = tourist %>% filter(year(YYMM) == 2019)  %>% mutate(month = month(YYMM), year = 2019) %>% select(-YYMM) %>% as.data.frame()

total_tourist = rbind(tour_2019, tour_2020)


data = data %>% select(-total_tourist) %>% left_join(total_tourist, by = c("CARD_SIDO_NM", "year", "month"))

data = data %>% as_tibble()

write.csv(data, "tourist_merge_data.csv")

seoul_tour = data %>% filter(CARD_SIDO_NM == '제주') %>% select(YYMM, total_tourist) %>% unique() 
colnames(seoul_tour) = c("date", "total_tourist")

tour_xts = tk_xts(seoul_tour, date_col = date)

autoplot(tour_xts)

tour_ts = tour_xts %>% as.ts()

acf(tour_ts)
pacf(tour_ts)

tour_ts %>% auto.arima() %>% forecast %>% autoplot()

fits = arima(tour_ts, c(1,1,1))

forecast(fits, h = 4) %>% autoplot
