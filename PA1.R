setwd("~/Coursera Videos/Reproducible Research/Course Project 1/RepData_PeerAssessment1")
activity <- read.csv("activity.csv")
str(activity)
activity$date <- as.Date(activity$date, format="%Y-%m-%d")
summary(activity$steps)
summary(activity$interval)
table(activity$interval)
table(activity$date)

library(plyr)
datesummary <- ddply(activity, .(date), summarise, total=sum(steps), 
                     mean=mean(steps), median=median(steps))
summary(datesummary)
hist(datesummary$total, breaks=7, xlab="Number of Steps Per Day",
     main="Histogram of Steps Taken Per Day")
with (datesummary, plot(date, total, type="h", ylab="Number of Steps"))
datesummary[,c('date','mean','median')]

timesummary <- ddply(activity, .(interval), summarise, total=sum(steps,na.rm=TRUE), 
                     mean=mean(steps,na.rm=TRUE), median=median(steps,na.rm=TRUE))
with (timesummary, plot(interval, mean, type="l", ylab="Number of Steps"))
maxindex <- which.max(timesummary$mean)
timesummary$mean[maxindex]
timesummary$interval[maxindex]
str(timesummary)

missing <- which(is.na(activity$steps))
str(missing)
length(missing)
activity2 <- merge(activity, timesummary[,c("interval","mean")], by="interval", all=TRUE)
str(activity2)
summary(activity2)
missing <- which(is.na(activity2$steps))

summary(activity2$steps)
summary(activity2$mean[missing])
summary(activity2$steps[missing])
activity2$steps[missing] = activity2$mean[missing]

for (idx in missing) activity2$steps[idx] = activity2$mean[idx]
activity2$steps

activity2$day <- weekdays(activity2$date)
weekday <- data.frame(day=c("Monday","Tuesday","Wednesday","Thursday",
                             "Friday","Saturday","Sunday"),
                       dayindicator=c("weekday","weekday","weekday","weekday",
                                      "weekday","weekend","weekend"))
activity3 <- merge(activity2[,c("day","interval","steps")],weekday,by="day",all=TRUE)
daysummary <- ddply(activity3, .(interval, dayindicator), summarise, 
                     mean=mean(steps))
library(lattice)
xyplot(mean ~ interval | dayindicator, data = daysummary, layout=c(1,2), type='l', 
       ylab='Number of Steps')



par(mfrow=c(2,1))
with (daysummary[daysummary$dayindicator=="weekday",], plot(interval, mean, type="l", 
                       ylab="Number of Steps",main="Weekday"))
with (daysummary[daysummary$dayindicator=="weekend",], plot(interval, mean, type="l", 
                       ylab="Number of Steps",main="weekend"))

str(activity3)
summary(activity3)
summary(daysummary)
library(xtable)

bydate <- with(activity,tapply(steps,date,sum,na.rm=TRUE))
hist(bydate)
str(bydate)
table(bydate)
dimnames(bydate)
data.frame(bydate)
dim(bydate)
str(datesummary)
names(datesummary)
