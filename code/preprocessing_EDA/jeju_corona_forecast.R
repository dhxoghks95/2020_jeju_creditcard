library(dplyr)
library(astsa)
library(forecast)
library(TSA)


corona = read.csv('C:/workspace/jeju/2020_jeju_creditcard/data/Corona_timeprovince.csv')
corona = corona%>%filter(substr(date,7,7 ) %in% c(1,2,3,4))%>% select(-c(time,released,deceased))


corona_Seoul = corona%>%filter(province=='Seoul')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Busan = corona%>%filter(province=='Busan')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Daegu = corona%>%filter(province=='Daegu')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Incheon = corona%>%filter(province=='Incheon')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Gwangju = corona%>%filter(province=='Gwangju')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Daejeon = corona%>%filter(province=='Daejeon')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Ulsan = corona%>%filter(province=='Ulsan')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Sejong = corona%>%filter(province=='Sejong')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Gyeonggi_do = corona%>%filter(province=='Gyeonggi-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Gangwon_do = corona%>%filter(province=='Gangwon-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Chungcheongbuk_do = corona%>%filter(province=='Chungcheongbuk-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Chungcheongnam_do = corona%>%filter(province=='Chungcheongnam-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Jeollabuk_do = corona%>%filter(province=='Jeollabuk-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Jeollanam_do = corona%>%filter(province=='Jeollanam-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Gyeongsangbuk_do = corona%>%filter(province=='Gyeongsangbuk-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Gyeongsangnam_do = corona%>%filter(province=='Gyeongsangnam-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)
corona_Jeju_do = corona%>%filter(province=='Jeju-do')%>%select(-province)%>%as.ts()%>%diff()%>%as.data.frame()%>%select(confirmed)

# nrow = nrow(corona_Seoul)
# corona_Seoul$date= 1:nrow
# corona_Busan$date= 1:nrow
# corona_Daegu$date= 1:nrow
# corona_Incheon$date= 1:nrow
# corona_Gwangju$date= 1:nrow
# corona_Daejeon$date= 1:nrow
# corona_Ulsan$date= 1:nrow
# corona_Sejong$date= 1:nrow
# corona_Gyeonggi_do$date= 1:nrow
# corona_Gangwon_do$date= 1:nrow
# corona_Chungcheongbuk_do$date= 1:nrow
# corona_Chungcheongnam_do$date= 1:nrow
# corona_Jeollabuk_do$date= 1:nrow
# corona_Jeollanam_do$date= 1:nrow
# corona_Gyeongsangbuk_do$date= 1:nrow
# corona_Gyeongsangnam_do$date= 1:nrow
# corona_Jeju_do$date= 1:nrow

# need to forecast:
# (may : 31)
# (June : 30)
# July : 31

plot.ts(corona_Seoul) # can autoarima
plot.ts(corona_Busan) # can autoarima
plot.ts(corona_Daegu) # cannot autoarima
plot.ts(corona_Incheon) #can autoarima
plot.ts(corona_Gwangju) #can autoarima
plot.ts(corona_Daejeon) #can autoarima
plot.ts(corona_Ulsan) #can
plot.ts(corona_Sejong) # can autoarima
plot.ts(corona_Gyeonggi_do) #can autoarima
plot.ts(corona_Gangwon_do) #can autoarima
plot.ts(corona_Chungcheongbuk_do) #can autoarima
plot.ts(corona_Chungcheongnam_do) #can autoarima
plot.ts(corona_Jeollabuk_do) #can autoarima
plot.ts(corona_Jeollanam_do) #can autoarima
plot.ts(corona_Gyeongsangbuk_do) #can autoarima
plot.ts(corona_Gyeongsangnam_do)# can autoarima
plot.ts(corona_Jeju_do) #can autoarima


# need to take a different approach only for DAEGU!

auto.arima(corona_Seoul)
Seoul_jul = sarima.for(corona_Seoul,n.ahead = 92, p=0,d=1,q=2,P=0,D=0,Q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Busan) 
Busan_jul = sarima.for(corona_Busan,n.ahead = 92, p=2,d=0,q=2,P=0,D=0,Q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can


plot.ts(corona_Daegu); corona_Daegu
corona_Daegu_real = corona_Daegu[80:nrow(corona_Daegu),1]
auto.arima(corona_Daegu_real)
Daegu_jul = sarima.for(corona_Daegu_real,n.ahead = 92, p=1,d=0,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #have to use only the subset of the data

auto.arima(corona_Incheon)
Incheon_jul = sarima.for(corona_Incheon,n.ahead = 92, p=0,d=1,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Gwangju)
Gwangju_jul = sarima.for(corona_Gwangju, n.ahead=92, p=1,d=0,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Daejeon)
Daejeon_jul = sarima.for(corona_Daejeon, n.ahead=92, p=0,d=0,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Ulsan)
Ulsan_jul = sarima.for(corona_Ulsan, n.ahead=92, p=1,d=0,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Sejong)
Sejong_jul = sarima.for(corona_Sejong, n.ahead=92, p=1,d=0,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Gyeonggi_do)
Gyeonggi_do_jul = sarima.for(corona_Gyeonggi_do, n.ahead=92, p=0,d=1,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can


auto.arima(corona_Gangwon_do)
Gangwon_do_jul = sarima.for(corona_Gangwon_do, n.ahead=92, p=1,d=0,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can


auto.arima(corona_Chungcheongbuk_do)
Chungcheongbuk_do_jul = sarima.for(corona_Chungcheongbuk_do, n.ahead=92, p=1,d=0,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can


auto.arima(corona_Chungcheongnam_do)
Chungcheongnam_do_jul = sarima.for(corona_Chungcheongnam_do, n.ahead=92, p=1,d=0,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Jeollabuk_do)
Jeollabuk_do_jul = sarima.for(corona_Jeollabuk_do, n.ahead=92, p=0,d=0,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Jeollanam_do)
Jeollanam_do_jul = sarima.for(corona_Jeollanam_do, n.ahead=92, p=1,d=0,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Gyeongsangbuk_do)
Gyeongsangbuk_do_jul = sarima.for(corona_Gyeongsangbuk_do, n.ahead=92, p=0,d=1,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Gyeongsangnam_do)
Gyeongsangnam_do_jul = sarima.for(corona_Gyeongsangnam_do, n.ahead=92, p=1,d=0,q=1)$pred%>%ceiling()%>%tail(31)%>%sum #can

auto.arima(corona_Jeju_do)
Jeju_do_jul= sarima.for(corona_Jeju_do, n.ahead=92, p=0,d=1,q=0)$pred%>%ceiling()%>%tail(31)%>%sum #can

# now make a dataframe


Sys.setlocale('LC_CTYPE','ko_KR.UTF-8')
corona_test = corona[corona$date =='2020-04-30',] #arbitrary date
corona_test$date = '2020-07-31'
corona_test$confirmed[1] = Seoul_jul
corona_test$confirmed[2] = Busan_jul
corona_test$confirmed[3] = Daegu_jul
corona_test$confirmed[4] = Incheon_jul
corona_test$confirmed[5] = Gwangju_jul
corona_test$confirmed[6] = Daejeon_jul
corona_test$confirmed[7] = Ulsan_jul
corona_test$confirmed[8] = Sejong_jul
corona_test$confirmed[9] = Gyeonggi_do_jul
corona_test$confirmed[10] = Gangwon_do_jul
corona_test$confirmed[11] = Chungcheongbuk_do_jul
corona_test$confirmed[12] = Chungcheongnam_do_jul
corona_test$confirmed[13] = Jeollabuk_do_jul
corona_test$confirmed[14] = Jeollanam_do_jul
corona_test$confirmed[15] = Gyeongsangbuk_do_jul
corona_test$confirmed[16] = Gyeongsangnam_do_jul
corona_test$confirmed[17] = Jeju_do_jul

write.csv(corona_test,'C:/workspace/jeju/2020_jeju_creditcard/data/corona_july.csv')


