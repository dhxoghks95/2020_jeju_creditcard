library(tidyverse)

library(lubridate)

library(sqldf)

library(plotly)

library(utf8)

Sys.setlocale("LC_ALL","korean")
data = read.csv("C:/workspace/jeju/2020_jeju_creditcard/data/final_merge.csv")
data = data %>% select(-X)

data['home_pp'] = (data$CARD_SIDO_NM == data$HOM_SIDO_NM)
data['x'] = 1

data2 = data %>% group_by(YYMM, CARD_SIDO_NM) %>% summarise(total_home = sum(home_pp* CSTMR_CNT)/sum(x * CSTMR_CNT)) %>% ungroup() 



data3 = sqldf("SELECT a.CARD_SIDO_NM, a.STD_CLSS_NM, a.HOM_SIDO_NM, a.AGE,

       a.SEX_CTGO_CD, a.FLC, a.CSTMR_CNT, a.AMT,

       a.CNT, a.month, a.year, a.confirmed, a.released, a.deceased, a.YYMM, a.festival_count , a.rain_day, a.sex_age_population, a.screen_num, 
       a.total_tourist, a.total_sale_by_indst, b.total_home
      
       FROM data a LEFT OUTER JOIN data2 b on a.CARD_SIDO_NM = b.CARD_SIDO_NM AND
 
       a.YYMM = b.YYMM")

write.csv(data3, 'C:/workspace/jeju/2020_jeju_creditcard/data/data_with_same_home_proportion.csv')
