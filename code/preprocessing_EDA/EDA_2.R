library(tidyverse)
library(lubridate)
library(sqldf)
library(plotly)

data = read_csv("C:/Users/dhxog/Desktop/데이콘/df.csv")
data = data %>% select(-X1)

data = data %>% mutate(YYMM = paste0(year,'-',month,'-01') %>% as.character() %>% ymd())

festival = read.csv("C:/Users/dhxog/Desktop/데이콘/dacon_competition/festival.csv")



festival = festival %>% mutate(start = paste0(year, "-", start_mon, "-01")%>%ymd(), end = paste0(year, "-", end_mon, "-01") %>% ymd())


festival = festival %>% mutate(x = 1)

festival = festival %>% group_by(CARD_SIDO_NM, start, end) %>% summarise(festival_count = sum(x))


data = sqldf("SELECT a.CARD_SIDO_NM, a.STD_CLSS_NM, a.HOM_SIDO_NM, a.AGE,
      a.SEX_CTGO_CD, a.FLC, a.year, a.month, a.CSTMR_CNT, a.AMT,
      a.CNT, a.YYMM, b.festival_count FROM data a
      LEFT OUTER JOIN festival b on a.CARD_SIDO_NM = b.CARD_SIDO_NM AND
      a.YYMM >= b.start AND a.YYMM <= b.end") %>% as_tibble()

data = data %>% group_by(CARD_SIDO_NM, STD_CLSS_NM,  HOM_SIDO_NM, AGE, SEX_CTGO_CD, FLC, CSTMR_CNT, AMT, CNT, YYMM) %>% summarise(festival_count = sum(festival_count))


## 2. EDA
data %>% group_by(YYMM) %>% summarise(amt_per_month = sum(AMT)) %>%
  ggplot(aes(x = YYMM, y = amt_per_month)) + geom_line()

data %>% group_by(YYMM, AGE) %>% summarise(AMT = sum(AMT)) %>% ggplot(aes(x = YYMM, y = AMT, col = AGE)) + geom_line() 



data %>% group_by(YYMM, STD_CLSS_NM) %>% summarise(AMT = sum(AMT)) %>% ungroup() %>%
  plot_ly(x = ~YYMM, y = ~AMT, color = ~STD_CLSS_NM, type = 'scatter', mode = 'markers+lines')

data$FLC = as.factor(data$FLC)

data %>% group_by(YYMM, FLC) %>% summarise(AMT = sum(AMT)) %>%
  ungroup() %>%
  plot_ly(x = ~YYMM, y = ~AMT, color = ~FLC, type = 'scatter', mode = 'markers+lines')



data %>% mutate(home_pp = (CARD_SIDO_NM == HOM_SIDO_NM), x = 1) %>% group_by(YYMM, CARD_SIDO_NM) %>% summarise(total_home = sum(home_pp* CSTMR_CNT)/sum(x * CSTMR_CNT)) %>% ungroup() %>% plot_ly(x = ~YYMM, y = ~total_home, color = ~CARD_SIDO_NM, type = 'scatter', mode = 'markers+lines')

data %>% group_by(YYMM, STD_CLSS_NM) %>% summarise(multi_ratio = mean(CNT/CSTMR_CNT), mean_amt = mean(AMT)) %>% ungroup() %>% group_by(YYMM) %>% mutate(ratio_rank = as.factor(rank(multi_ratio))) %>% ungroup() %>% 
  plot_ly(x = ~YYMM, y = ~mean_amt, color = ~ratio_rank, type = 'scatter', mode = "markers+lines")


temp = data %>% group_by(STD_CLSS_NM) %>% summarise(multi_ratio = mean(CNT/CSTMR_CNT)) %>% ungroup() %>% mutate(ratio_rank = rank(multi_ratio)) %>% mutate(rank_g = case_when(
  ratio_rank > 31 ~ 1,
  ratio_rank > 21 & ratio_rank <=31 ~2,
  ratio_rank > 11 & ratio_rank <=21 ~3,
  ratio_rank <=11 ~ 4
)) %>% select(STD_CLSS_NM, rank_g) %>% right_join(data, by = "STD_CLSS_NM")

temp$rank_g = as.factor(temp$rank_g)

temp %>% group_by(YYMM, rank_g) %>% summarise(mean_amt = mean(AMT)) %>% ungroup()%>% plot_ly(x = ~YYMM, y = ~mean_amt, color = ~rank_g, type = "scatter", mode = "markers+lines")

temp %>% filter(rank_g == 3) %>% select(STD_CLSS_NM) %>% unique()
