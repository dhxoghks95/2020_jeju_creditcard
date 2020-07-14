library(tidyverse)
library(lubridate)
혜연 = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/melted_age_sex.csv")
영화 = read_csv("movie_tidy.csv")
선우 = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/corona_added.csv")

태환 = read.csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/add_weather_fest.csv")
태환 = 태환 %>% mutate(year = as.numeric(year(YYMM)))

colnames(선우)

태환 = 태환 %>% select(-c(X.1, X))

merged %>% select(STD_CLSS_NM) %>% unique()
선우 = 선우 %>% select(-c(X1))
혜연 = 혜연 %>% select(-c(X1))



merged = merge(선우, 태환, by = c("CARD_SIDO_NM", "STD_CLSS_NM", "HOM_SIDO_NM", "AGE", "SEX_CTGO_CD", "FLC", "CSTMR_CNT", "AMT", "CNT", "month", "year"))

temp = merged %>% left_join(혜연, by = c("CARD_SIDO_NM", "AGE", "SEX_CTGO_CD"))

write.csv(merged, "merged_so_data.csv")

영화 = 영화[complete.cases(영화),]
영화 = 영화[-18, -1]
movie = 영화 %>% transmute(CARD_SIDO_NM = 지역, screen_num = 영화상영관수)

temp = temp %>% left_join(movie, by = c("CARD_SIDO_NM"))

write.csv(temp, "merged_data.csv")

tourist = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/외래관광객.csv")
tourist = tourist %>% select(-X1)
tourist_came = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/관광객입도현황.csv")
tourist_came = tourist_came %>% select(-X1)

colnames(tourist) = c("year", "month", "CARD_SIDO_NM", "total_tourist")

temp_merge = temp %>% left_join(tourist, by = c("year", "month", "CARD_SIDO_NM"))

sale_food = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/sm_food_cleaned.csv")
sale_tr = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/us_cleaned.csv")
sale_etc = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/gt_cleaned.csv")

sale_food = sale_food %>% select(-X1)
sale_tr = sale_tr %>% select(-X1)
sale_etc = sale_etc %>% select(-X1)

colnames(sale_food) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")
colnames(sale_tr) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")
colnames(sale_etc) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")

sido = sale_food %>% select(CARD_SIDO_NM) %>% unlist() %>% unique() %>% as.vector()

sale_tr = rep(sido, 4) %>% sort() %>% as.tibble() %>% cbind(sale_tr)
sale_tr = sale_tr[,-1]

colnames(sale_tr) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")
sale_tr$total_sale_by_indst = sale_tr$total_sale_by_indst / length(unique(sale_tr$CARD_SIDO_NM))

sale_by_indst = rbind(sale_food, sale_tr, sale_etc)

final_merge = temp_merge %>% left_join(sale_by_indst, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))

write.csv(final_merge, "final_merge.csv")
