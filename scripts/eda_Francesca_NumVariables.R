#Let's have a look at the numerical variables
library(ggplot2)
library(plotly)
library(ggthemes)

head(numcols)

#ggplot(numcols, aes(x = age)) +  geom_histogram(alpha = 0.8,fill = BarFillColor) + labs(x= 'Age',y = 'Count', title = paste("Distribution of", ' Age ')) +theme_bw()
#ggplot(numcols, aes(x = balance)) +  geom_histogram(alpha = 0.8,fill = BarFillColor) + labs(x= 'Balance',y = 'Count', title = paste("Distribution of", ' Balance ')) +theme_bw()
#ggplot(numcols, aes(x = day)) +  geom_histogram(alpha = 0.8,fill = BarFillColor) + labs(x= 'Day',y = 'Count', title = paste("Distribution of", ' Day ')) +theme_bw()
#ggplot(numcols, aes(x = duration)) +  geom_histogram(alpha = 0.8,fill = BarFillColor) + labs(x= 'Duration',y = 'Count', title = paste("Distribution of", ' Duration ')) +theme_bw()

#Histogram of all the Numerical Variables

dev.off()
par("mar")
par(mar=c(2,2,2,2))
par(mfrow=c(4,2))

cols <- numcols[,c(1,3,6,7,8,9,10)]

for(i in 1:ncol(cols)) {
  hist(cols[,i], main=names(cols)[i], col="darkturquoise", border="white")
}

#Age

#binning the age values to make the graphs more clear

bank_train$agebin <- cut(bank_train$age, c(20,30,40,50,60,70,100))

mytable <- table(bank_train$agebin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("age", "y", "perc")

ggplot(data = tab, aes(x = age, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Age")+
  ylab("Percent")


#Balance ??

#need to bin also 

mytable <- table(bank_train$balance, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("balance", "y", "perc")

ggplotly(ggplot(data = tab, aes(x = balance, y = perc, fill = y)) + 
           geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
           theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
           xlab("balance")+
           ylab("Percent"))


#Day

bank_train$daybin <- cut(bank_train$day, c(1,7,14,21,31))

mytable <- table(bank_train$daybin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("day", "y", "perc")

ggplotly(ggplot(data = tab, aes(x = day, y = perc, fill = y)) + 
           geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
           theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
           xlab("day")+
           ylab("Percent"))


#Duration

bank_train$durationbin <- cut(bank_train$duration, c(0,500,1000,1500,2000))

mytable <- table(bank_train$durationbin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("duration", "y", "perc")

ggplotly(ggplot(data = tab, aes(x = duration, y = perc, fill = y)) + 
           geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
           theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
           xlab("duration")+
           ylab("Percent"))

#Campaign
bank_train$campaignbin <- cut(bank_train$campaign, c(0,5,10,15,20))


mytable <- table(bank_train$campaignbin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("campaign", "y", "perc")

ggplotly(ggplot(data = tab, aes(x = campaign, y = perc, fill = y)) + 
           geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
           theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
           xlab("campaign")+
           ylab("Percent"))


#pdays

#how do we treat -1?

#previous
bank_train$prev_bin <- cut(bank_train$previous, c(0,5,10,15,20))

mytable <- table(bank_train$prev_bin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("previous", "y", "perc")

ggplotly(ggplot(data = tab, aes(x = previous, y = perc, fill = y)) + 
           geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
           theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
           xlab("previous")+
           ylab("Percent"))
