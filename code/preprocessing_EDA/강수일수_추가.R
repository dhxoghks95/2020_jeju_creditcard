library(tidyverse)

서울경기 = read.csv("강수일수_서울경기.csv")

서울 = data.frame("서울", 서울경기[3,-c(1, 14,15)])
colnames(서울) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)
경기 = data.frame("경기", 서울경기[3,-c(1, 14,15)])
colnames(경기) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

충남 = read.csv("강수일수_충남.csv")
충남 = data.frame("충남", 충남[3,-c(1, 14,15)])
colnames(충남) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

충북 = read.csv("강수일수_충북.csv")
충북 = data.frame("충북", 충북[3,-c(1, 14,15)])
colnames(충북) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

강원영서 = read.csv("강수일수_강원영서.csv")
강원영서 = data.frame("강원", 강원영서[3,-c(1, 14,15)])
colnames(강원영서) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

강원영동 = read.csv("강수일수_강원영동.csv")
강원영동 = data.frame("강원", 강원영동[3,-c(1, 14,15)])
colnames(강원영동) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

강원 = data.frame("강원")
for(i in 2:13){
  강원[1,i] = mean(강원영동[1,i], 강원영서[1,i])
}

colnames(강원) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

전남 = read.csv("강수일수_전남.csv")
전남 = data.frame("전남", 전남[3,-c(1, 14,15)])
colnames(전남) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

전북 = read.csv("강수일수_전북.csv")
전북 = data.frame("전북", 전북[3,-c(1, 14,15)])
colnames(전북) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

경남 = read.csv("강수일수_경남.csv")
경남 = data.frame("경남", 경남[3,-c(1, 14,15)])
colnames(경남) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

경북 = read.csv("강수일수_경북.csv")
경북 = data.frame("경북", 경북[3,-c(1, 14,15)])
colnames(경북) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

제주 = read.csv("강수일수_제주.csv")
제주 = data.frame("제주", 제주[3,-c(1, 14,15)])
colnames(제주) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

인천 = data.frame("인천", 서울경기[3,-c(1, 14,15)])
colnames(인천) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

대전 = data.frame("대전")
for(i in 2:13){
  대전[1,i] = mean(충북[1,i], 충남[1,i])
}
colnames(대전) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)
세종 = data.frame("세종")
for(i in 2:13){
  세종[1,i] = mean(충북[1,i], 충남[1,i])
}
colnames(세종) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

대구 = data.frame("대구", 경북[1,-c(1,14,15)])
colnames(대구) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

부산 = data.frame("부산", 경남[1,-c(1, 14,15)])
colnames(부산) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

울산 = data.frame("울산", 경남[1,-c(1, 14,15)])
colnames(울산) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

광주 = data.frame("광주", 전남[1,-c(1, 14,15)])
colnames(광주) = c("CARD_SIDO_NM", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12)

weather = rbind(서울, 경기, 충북, 충남, 전북, 전남, 경북, 경남, 제주, 인천, 대전, 세종, 대구, 부산, 울산, 광주, 강원)

library(reshape)
weather = weather %>% melt(id.vars = c("CARD_SIDO_NM"))

colnames(weather) = c("CARD_SIDO_NM", "month", "rain_day")

write.csv(weather, "weather.csv")

data = read.csv("add_fest_data.csv")

data = data %>% mutate(month = month(YYMM))

weather$month = as.numeric(weather$month)

temp = data %>% left_join(weather, by = c("CARD_SIDO_NM", "month"))
                          
temp$festival_count[is.na(temp$festival_count) == T] = 0

write.csv(temp, "add_weather_fest.csv")
