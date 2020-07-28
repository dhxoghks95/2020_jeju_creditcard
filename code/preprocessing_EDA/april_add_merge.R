# 0. Import P
library(tidyverse)
library(lubridate)
library(sqldf)
data = read_csv("df.csv")
data = data %>% select(-X1)
april = read_csv("202004.csv")

# 1. df와 april 붙이기
april = april %>% select(-c(CARD_CCG_NM, HOM_CCG_NM))

april = april %>% group_by(REG_YYMM, CARD_SIDO_NM, STD_CLSS_NM, HOM_SIDO_NM, AGE, SEX_CTGO_CD, FLC) %>% summarise(CSTMR_CNT = sum(CSTMR_CNT), AMT = sum(AMT) , CNT = sum(CNT)) %>% ungroup()



april = april %>% mutate(REG_YYMM = ymd(paste0(REG_YYMM, "01")))

april = april %>% mutate(year = year(REG_YYMM), month = month(REG_YYMM)) %>% select(CARD_SIDO_NM, STD_CLSS_NM, HOM_SIDO_NM, AGE, SEX_CTGO_CD, FLC, year, month, CSTMR_CNT, AMT, CNT)
data = rbind(data, april)

# 2. 축제 붙이기
festival = read.csv("C:/Users/dhxog/Desktop/데이콘/dacon_competition/festival.csv")
festival = festival %>% select(-X)

festival = festival %>% mutate(start = paste0(year, "-", start_mon, "-01")%>%ymd(), end = paste0(year, "-", end_mon, "-01") %>% ymd())


festival = festival %>% mutate(x = 1)

festival = festival %>% group_by(CARD_SIDO_NM, start, end) %>% summarise(festival_count = sum(x))

data = data %>% mutate(YYMM = paste0(year,'-',month,'-01') %>% as.character() %>% ymd())


data = sqldf("SELECT a.CARD_SIDO_NM, a.STD_CLSS_NM, a.HOM_SIDO_NM, a.AGE,
      a.SEX_CTGO_CD, a.FLC, a.year, a.month, a.CSTMR_CNT, a.AMT,
      a.CNT, a.YYMM, b.festival_count FROM data a
      LEFT OUTER JOIN festival b on a.CARD_SIDO_NM = b.CARD_SIDO_NM AND
      a.YYMM >= b.start AND a.YYMM <= b.end") %>% as_tibble()

data = data %>% group_by(CARD_SIDO_NM, STD_CLSS_NM,  HOM_SIDO_NM, AGE, SEX_CTGO_CD, FLC, CSTMR_CNT, AMT, CNT, YYMM) %>% summarise(festival_count = sum(festival_count))

# 3. weather 붙이기

weather = read.csv("weather.csv")

weather = weather %>% select(-X)
data = data %>% mutate(year = year(YYMM), month = month(YYMM)) %>% select(-YYMM)
data = data %>% left_join(weather, by = c("CARD_SIDO_NM", "month"))

data$festival_count[is.na(data$festival_count) == T] = 0

# 2. tourist 붙이기
tourist = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/외래관광객.csv")
tourist = tourist %>% select(-X1)
tourist_came = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/관광객입도현황.csv")
tourist_came = tourist_came %>% select(-X1)


colnames(tourist) = c("year", "month", "CARD_SIDO_NM", "total_tourist")

colnames(tourist_came) = c("year", "month", "CARD_SIDO_NM", "total_tourist")

ratio = tourist_came %>% filter(year == 2019) %>% select(total_tourist) / tourist %>% filter(CARD_SIDO_NM == "제주") %>% select(total_tourist)

ratio_num = ratio %>% unlist() %>% mean()

tourist = tourist %>% mutate(total_tourist = total_tourist * ratio_num)

tourist = tourist %>% filter(CARD_SIDO_NM != "제주")

tourist = rbind(tourist, tourist_came)

tourist = tourist %>% mutate(total_tourist = round(total_tourist))

loss_rate = (tourist %>% filter(CARD_SIDO_NM == '제주',  month == 2 | month == 3 | month == 4) %>% select(year,month, total_tourist) %>% unique() %>% filter(year == 2020) %>% arrange(year, month) / tourist %>% filter(CARD_SIDO_NM == '제주',  month == 2 | month == 3 | month == 4) %>% select(year, month, total_tourist) %>% unique() %>% filter(year == 2019) %>% arrange(year, month)) %>% select(total_tourist) %>% unlist()

tourist_2019 = tourist  %>% filter(year == 2019)

tourist_2019 = tourist_2019 %>% filter(CARD_SIDO_NM != '제주')

tourist_2020_exp = tourist_2019 %>% group_by(CARD_SIDO_NM) %>% filter(month == 1 | month == 2 | month == 3 | month ==4) %>% select(-year) %>% mutate(total_tourist = case_when(
  month == 1 ~ total_tourist,
  month == 2 ~ round(total_tourist * loss_rate[1]),
  month == 3 ~ round(total_tourist * loss_rate[2]),
  month == 4 ~ round(total_tourist * loss_rate[3])
)) %>% arrange(CARD_SIDO_NM) %>% mutate(year = 2020) %>% as.data.frame()

jeju_2020 = tourist %>% filter(CARD_SIDO_NM == '제주' & year == 2020) %>% as.data.frame()

tour_2020 = rbind(tourist_2020_exp, jeju_2020 )

tour_2019 = tourist %>% filter(year == 2019) %>% as.data.frame()

total_tourist = rbind(tour_2019, tour_2020)

data = data %>% left_join(total_tourist, by = c("year", "month", "CARD_SIDO_NM"))

# 3. corona 붙이기

corona = read.csv("C:\\Users\\dhxog\\Desktop\\데이콘\\data\\corona\\Corona_until_april.csv")

corona = corona %>% select(-X)

colnames(corona) = c("CARD_SIDO_NM", "corona_confirmed", 'year', 'month')

data = data %>% left_join(corona, by = c("year", "month", "CARD_SIDO_NM"))
data$corona_confirmed[is.na(data$corona_confirmed)] = 0
# 4. 산업별 판매량 붙이기

sale_food = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/sm_food_cleaned.csv")
sale_tr = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/us_cleaned.csv")
sale_etc = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/gt_cleaned.csv")

sale_food = sale_food %>% select(-X1)
sale_tr = sale_tr %>% select(-X1)
sale_etc = sale_etc %>% select(-X1)

colnames(sale_food) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")
colnames(sale_etc) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")

sido = sale_food %>% select(CARD_SIDO_NM) %>% unlist() %>% unique() %>% as.vector()

sale_tr = rep(sido, 4) %>% sort() %>% as_tibble() %>% cbind(sale_tr)

colnames(sale_tr) = c("CARD_SIDO_NM", "STD_CLSS_NM", "total_sale_by_indst")

sale_tr$total_sale_by_indst = sale_tr$total_sale_by_indst / length(unique(sale_tr$CARD_SIDO_NM))

sale_by_indst = rbind(sale_food, sale_tr, sale_etc)

sale_by_indst$total_sale_by_indst = sale_by_indst$total_sale_by_indst %>% as.numeric()


amt_by_indst = data %>% select(CARD_SIDO_NM, STD_CLSS_NM, AMT) %>% group_by(CARD_SIDO_NM, STD_CLSS_NM) %>% summarise(total_amt_by_indst = sum(AMT)) %>% ungroup()

sales = amt_by_indst %>% left_join(sale_by_indst, by= c("CARD_SIDO_NM", "STD_CLSS_NM"))
sales = na.omit(sales)
sales = sales %>% mutate(amt_sale_ratio = total_amt_by_indst/total_sale_by_indst)
med_amt_sale_ratio = median(sales$amt_sale_ratio %>% unlist)

data = data %>% left_join(sale_by_indst, by = c("CARD_SIDO_NM", "STD_CLSS_NM"))



data = data %>% group_by(CARD_SIDO_NM, STD_CLSS_NM) %>% mutate(amt_total = sum(AMT)) %>% ungroup() %>% mutate(total_sale_by_indst = case_when(
  is.na(total_sale_by_indst) == T ~ med_amt_sale_ratio * amt_total / length(data$CARD_SIDO_NM %>% unique()),
  is.na(total_sale_by_indst) == F ~ total_sale_by_indst
)) %>% select(-amt_total)

# 5. 인구수 붙이기
age_sex = read_csv("C:/Users/dhxog/Desktop/데이콘/2020_jeju_creditcard/data/melted_age_sex(10-70).csv")

data = data %>% left_join(age_sex, by = c("CARD_SIDO_NM", "AGE", "SEX_CTGO_CD"))


# last 저장

write.csv(data, "april_add_merge.csv", row.names = F)

