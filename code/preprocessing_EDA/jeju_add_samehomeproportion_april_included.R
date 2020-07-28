library(tidyverse)
library(lubridate)

library(sqldf)

library(plotly)

library(utf8)

Sys.setlocale("LC_ALL","korean")
data = read.csv("C:/workspace/jeju/2020_jeju_creditcard/data/april_add_merge.csv")

data['home_pp'] = (data$CARD_SIDO_NM == data$HOM_SIDO_NM)
data['x'] = 1


data['YYMM'] = paste(data$year, data$month, sep='-')

data2 = data %>% group_by(YYMM, CARD_SIDO_NM) %>% summarise(total_home = sum(home_pp* CSTMR_CNT)/sum(x * CSTMR_CNT)) %>% ungroup() 

data2['year'] = substr(data2$YYMM, 1,4)%>%as.numeric()
data2['month'] = substr(data2$YYMM, 6,7)%>%as.numeric()

head(data2)

data3 = sqldf("SELECT 

       a.CARD_SIDO_NM, a.STD_CLSS_NM, a.HOM_SIDO_NM, a.AGE,

       a.SEX_CTGO_CD, a.FLC, a.CSTMR_CNT, a.AMT,

       a.CNT, a.festival_count, a.year, a.month, a.rain_day, a.total_tourist, a.corona_confirmed, a.total_sale_by_indst, a.sex_age_population,
       
       b.total_home
      
       FROM data a LEFT OUTER JOIN data2 b on a.CARD_SIDO_NM = b.CARD_SIDO_NM AND a.year = b.year AND a.month = a.month")

head(data3)

#to reduce the file size, represented 'total_home' column rounded into 2 digits!

data3$total_home = round(data3$total_home,2)

# Also, only the 'total home' column has to be newly introduced in data3!
colnames(data)
colnames(data3)

head(data3)

write.csv(data3, 'C:/workspace/jeju/2020_jeju_creditcard/data/april_add_merge_with_homeproportion.csv')
