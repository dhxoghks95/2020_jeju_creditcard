library(tidyverse)
data = read.csv('modeling_data.csv')
temp = read_csv("C:/Users/dhxog/Desktop/데이콘/template.csv")
temp = temp %>% select(-X1)


rain_day = data %>% select(month, CARD_SIDO_NM, rain_day) %>% unique()

age_population = data %>% select(CARD_SIDO_NM, AGE, age_population) %>% unique()

total_sale_by_indst_groupby = data %>% select(CARD_SIDO_NM, STD_CLSS_NM, total_sale_by_indst_groupby) %>% unique()

log_total_sale_by_indst = data %>% select(CARD_SIDO_NM, STD_CLSS_NM, log_total_sale_by_indst) %>% unique()

total_tourist_groupby = data %>% select(year,CARD_SIDO_NM, total_tourist_groupby) %>% unique()

home_ratio = data %>% select(CARD_SIDO_NM, home_ratio) %>% unique()

temp = temp %>% left_join(rain_day, by = c("month", "CARD_SIDO_NM"))

temp = temp %>% left_join(age_population, by = c("CARD_SIDO_NM", "AGE"))

temp = temp %>% left_join(total_sale_by_indst_groupby, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))

log_temp = temp %>% left_join(log_total_sale_by_indst, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))

temp = temp %>% left_join(total_tourist_groupby, by = c("year", "CARD_SIDO_NM"))
log_temp = log_temp %>% left_join(total_tourist_groupby, by = c("year", "CARD_SIDO_NM"))

temp = temp %>% left_join(home_ratio, by = c("CARD_SIDO_NM"))
log_temp = log_temp %>% left_join(home_ratio, by = c("CARD_SIDO_NM"))
log_temp = log_temp %>% select(-total_sale_by_indst_groupby)

write.csv(temp, "template.csv", row.names = F)
write.csv(log_temp, "log_template.csv", row.names = F)

colnames(temp)
colnames(log_temp)
