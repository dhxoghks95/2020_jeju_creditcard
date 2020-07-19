# packages
library(tidyverse)
library(plotly)
library(lubridate)
# importing data
data = read.csv("final_merge.csv")
data = data %>% select(-X)

# EDA

data %>% glimpse()

data$rain_day %>% unique()

qrain = data$rain_day %>% summary()


data = data %>% mutate(rain_day_group = case_when(
  rain_day < qrain[2] ~ 1,
  rain_day >= qrain[2] & rain_day < qrain[3] ~ 2,
  rain_day >= qrain[3] & rain_day < qrain[5] ~ 3,
  rain_day >= qrain[5] ~ 4
)) %>% group_by(rain_day_group) %>% mutate(rain_day = mean(rain_day)) %>% ungroup() %>%
  select(-rain_day_group)

data = data %>% mutate(corona_increase = confirmed - released) %>% select(-c(confirmed, released)) %>% 
  mutate(covid = case_when(
    corona_increase > 0 ~ T,
    corona_increase <=0 ~ F
  )) %>% select(-corona_increase)

data = data %>% group_by(CARD_SIDO_NM, AGE) %>% mutate(age_population = sum(sex_age_population)) %>% select(-sex_age_population) %>% mutate(age_group = case_when(AGE == "10s" | AGE == '70s' ~ "10_70",
 AGE == "30s" | AGE == '40s' | AGE == '50s' ~ "30~50",AGE == '20s' | AGE == '60s' ~ '20_60')) %>% group_by(CARD_SIDO_NM, age_group) %>% mutate(age_population = sum(age_population))  %>% ungroup() %>% select(-age_group)




## EDA
data %>% ggplot(aes(x = log(sex_age_population), fill = CARD_SIDO_NM)) + geom_histogram(bins = 400)


data %>% group_by(YYMM, CARD_SIDO_NM, covid) %>% summarise(total_amt = sum(AMT)) %>%
  ggplot(aes(x = YYMM, y = total_amt, color = covid)) + geom_point() + facet_wrap(CARD_SIDO_NM~.)


data %>% group_by(CARD_SIDO_NM, rain_day) %>% summarise(total_amt = sum(AMT)) %>%
  ggplot(aes(x = as.factor(rain_day), y = total_amt, col = as.factor(rain_day))) + geom_boxplot() + facet_wrap(CARD_SIDO_NM~.)

data %>% group_by(CARD_SIDO_NM, AGE) %>% summarise(total_amt = sum(AMT)) %>% ggplot(aes(y = total_amt, col = AGE)) +geom_boxplot() + facet_wrap(CARD_SIDO_NM~.)


data %>% group_by(CARD_SIDO_NM, SEX_CTGO_CD) %>% summarise(total_amt = sum(AMT)) %>% ggplot(aes(y = total_amt, col = as.factor(SEX_CTGO_CD))) +geom_boxplot() + facet_wrap(CARD_SIDO_NM~.)

data %>% group_by(CARD_SIDO_NM, FLC) %>% summarise(total_amt = sum(AMT)) %>% ggplot(aes(y = total_amt, col = as.factor(FLC))) +geom_boxplot() + facet_wrap(CARD_SIDO_NM~.)

data %>% group_by(YYMM, FLC) %>% summarise(total_amt = sum(AMT)) %>% ungroup() %>% plot_ly(x = ~YYMM, y = ~total_amt, color = ~as.factor(FLC), type = 'scatter', mode = 'markers+lines') 
