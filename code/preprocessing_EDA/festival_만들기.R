library(tidyverse)
library(lubridate)

# 1) Importing Data
data = read.csv("C:/Users/dhxog/Desktop/데이콘/data/전국문화축제표준데이터.csv")


# 2) 날짜 데이터 변환
data$축제시작일자 = data$축제시작일자 %>% as.character() %>% parse_date()

data$축제종료일자 = data$축제종료일자 %>% as.character() %>% parse_date()

data$start_mon = data$축제시작일자 %>% month()
data$end_mon = data$축제종료일자 %>% month()
data$year = data$축제시작일자 %>% year()

data = data %>% select(-c(축제종료일자, 축제시작일자))


# 3) CARD_SIDO_NM과 CARD_CCG_NM 칼럼 만들기
library(stringr)

sido0 = data %>% select(제공기관명) %>% unlist() %>% as.character() %>% strsplit(" ")
sido1 = data %>% select(소재지도로명주소) %>% unlist() %>% as.character() %>% strsplit(" ") 
sido2 = data %>% select(소재지지번주소) %>% unlist() %>% as.character() %>% strsplit(" ") 
## NA값을 최대한 채우기 위해 주소가 들어있는 세 칼럼을 불러온다

CARD_SIDO_NM = c()
CARD_CCG_NM = c()
for(i in 1:1263){
  CARD_SIDO_NM[i]=sido0[[i]][1]
  
}

for(i in 1:1263){
  if(is.na(sido0[[i]][2]) == T){
    if(is.na(sido1[[i]][2]) == F){
    CARD_CCG_NM[i] = sido1[[i]][2]
    } else{
      CARD_CCG_NM[i] = sido2[[i]][2]
    }
  }else{
    CARD_CCG_NM[i]=sido0[[i]][2]
  }
}


## XX북도, XX남도는 X남, X북으로 만들어주고 나머지는 첫 두 글자를 가져온다(ex 서울특별시 -> 서울)
for(i in 1:1263){
  if(nchar(CARD_SIDO_NM[i]) == 4){
    CARD_SIDO_NM[i] = paste0(substr(CARD_SIDO_NM[i], 1, 1), substr(CARD_SIDO_NM[i], 3, 3))
  } else{
    CARD_SIDO_NM[i] = substr(CARD_SIDO_NM[i], 1, 2)
  }
}


data = cbind(data, CARD_SIDO_NM, CARD_CCG_NM)
festival = data %>% select(축제명, 위도, 경도, year, start_mon, end_mon, CARD_SIDO_NM, CARD_CCG_NM)

## 3) 위도, 경도의 결측치를 채우기 위해 CARD_SIDO_NM, CARD_CCG_NM별 위도 경도 df를 만들자
ll = festival %>% select(CARD_SIDO_NM, CARD_CCG_NM, 위도, 경도) %>% group_by(CARD_SIDO_NM,CARD_CCG_NM) %>% top_n(n = 1) %>% unique()

## 조인시켜주자
festivals = festival %>% select(-c(위도, 경도)) %>% left_join(ll, by = c("CARD_SIDO_NM", "CARD_CCG_NM"))

## 위도, 경도에 결측치가 하나이므로 이건 제거해주고 CARD_SIDO_NM에선 시도가 아닌 값 하나와 CARD_CCG_NM에서는 다솜3로인 행을 지워준다.

festivals = festivals %>% filter(!is.na(위도)) %>% filter(!(CARD_SIDO_NM == '시청')) %>% filter(!(CARD_CCG_NM == '다솜3로'))

## 결측치 없이 잘 만들어졌다!
festivals %>% summary()

## 저장해주자
write.csv(festivals, "festival.csv")
