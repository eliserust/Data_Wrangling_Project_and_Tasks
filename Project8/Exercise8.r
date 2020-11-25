# Elise Rust
# Exercise #8
# November 2020

#1. Use rtimes to obtain a web token from http://developer.nytimes.com and obtain articles written on climate change in last 3 years
install.packages("devtools")
devtools::install_github("ropengov/rtimes")
library("rtimes")

#http://developer.nytimes.com/
article_key <- "hucqNDA0bwCAKL5Uu91tdFqQFRMoizFU"
article_search_climate <- as_search(q="Climate Change",begin_date="20171104",end_date='20201104',key=article_key)
names(article_search_climate)
article_search_climate$meta
article_search_climate$data
article_search_climate$data[3]


#2. Use twitter credentials and obtain tweets talking about earth hour
install.packages("twitteR")
library(twitteR) 

consumer_key <- "tVsBEOZRhrnMDfUUduPIRSdTl"
consumer_secret <-"uoB4OscKRePaswge4k7ye0OGOJvEUVuDQLpjfUzZIuyeS3cPkc"
access_token <- "1057953109392138240-ZABy6nzGAmSrkHVRpkVwlsgsX5F9Ti"
access_secret <- "LgUNGIRyzJWVGE9mX40iJ4tzYSSdwEhfpNdTAjR2ulSEC" 
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

earth_hour = searchTwitter('#earth hour', n = 1e4, since = '2017-11-05', retryOnRateLimit = 1e3)
tweets = twListToDF(earth_hour)

tweets$text
