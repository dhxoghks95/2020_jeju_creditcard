library(tidyverse)

oh = read.csv("transform_eda.csv")

jo_1 = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/indst_data.csv")

jo_2 = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/log_indst_data.csv")

kim = read.csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/total_tourist_groupby.csv")

oh = oh %>% select(-X)
jo_1 = jo_1 %>% select(-X1) %>% unique()
colnames(jo_1) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst_groupby")
jo_2 = jo_2 %>% select(-X1) %>% unique()
colnames(jo_2) = c("CARD_SIDO_NM", "STD_CLSS_NM", "log_total_sale_by_indst")
kim = kim %>% select(-X) %>% unique()

data = oh %>% left_join(jo_1, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))

data = data %>% left_join(jo_2, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))

data = data %>% left_join(kim, by = c("total_tourist")) 

data = data %>% mutate(count = 1, same = case_when(
  CARD_SIDO_NM == HOM_SIDO_NM ~ 1,
  CARD_SIDO_NM != HOM_SIDO_NM ~ 0
)) %>% group_by(CARD_SIDO_NM) %>% mutate(home_ratio = sum(same * CSTMR_CNT) / sum(count * CSTMR_CNT)) %>% select(-c(count, same))

data = data %>% select(-c(CSTMR_CNT, CNT, YYMM, screen_num, total_tourist, total_sale_by_indst))

write.csv(data, "modeling_data.csv", row.names = F)
