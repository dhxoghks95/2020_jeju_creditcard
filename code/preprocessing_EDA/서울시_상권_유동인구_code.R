#### 서울시 우리마을가게 상권분석서비스 ####

# 시간대1 : 00시1분 ~ 06시, 시간대2 : 06시1분 ~ 11시, 시간대3 : 11시1분 ~ 14시, 시간대4 : 14시1분 ~ 17시, 시간대5 : 17시1분 ~ 21시, 시간대6 : 21시1분 ~ 24시 

# 패키지 불러오기
library(dplyr)

# 데이터셋 불러오기
df.sanggwon <- read.csv('서울시_우리마을가게_상권분석서비스/서울시_우리마을가게_상권분석서비스(상권영역).csv', fileEncoding='EUC-KR')
df.jachigu <- read.csv('서울시_우리마을가게_상권분석서비스/서울시_우리마을가게_상권분석서비스(자치구별 상권변화지표).csv', fileEncoding='EUC-KR')
df.ingu <- read.csv('서울시_우리마을가게_상권분석서비스/서울시_우리마을가게_상권분석서비스(상권배후지_추정유동인구).csv', fileEncoding='EUC-KR')

# 필요없는 컬럼 제거
colnames(df.sanggwon)
df.sanggwon <- df.sanggwon[ , 2:9]
colnames(df.jachigu)
df.jachigu <- df.jachigu[ , 3:4]
colnames(df.ingu)
df.ingu <- df.ingu[ , 1:28]

# 데이터셋 합치기
s <- merge(df.sanggwon, df.jachigu, by='시군구_코드', all.x=TRUE)
colnames(s)
s <- s[c(2:5,1,9,8,6:7)]
df.all <- merge(s, df.ingu, by='상권_코드', all.y=TRUE)

# 데이터셋 열 이름 및 위치 변경하기
colnames(df.all)
df.all <- df.all %>% dplyr::select(-c("상권_구분_코드.x", "상권_구분_코드_명.x", "상권_코드_명.x", "상권_구분_코드.y", "상권_구분_코드_명.y",))
df.all <- df.all %>% rename("상권_코드_명"="상권_코드_명.y")
colnames(df.all)
df.all <- df.all[c(7:8,2:4,1,9,5:6,10:31)]

# NA 확인하기
df.all %>% is.na() %>% colSums()

# 2019년 ~ 2020년 데이터만 추출하기
df.all <- df.all %>% dplyr::filter(기준_년_코드 >= 2019)

# 데이터프레임 저장하기
write.csv(df.all, file='서울시_우리마을가게_상권분석서비스/서울시_상권_유동인구.csv')