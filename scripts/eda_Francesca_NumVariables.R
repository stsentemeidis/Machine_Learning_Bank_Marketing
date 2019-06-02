#Let's have a look at the numerical variables
library(ggplot2)
library(plotly)
library(ggthemes)

head(numcols)

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

bank_train$agebin <- cut(bank_train$age, c(20,30,35,40,50,60,100))

mytable <- table(bank_train$agebin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("age", "y", "perc")


ba_age_plot <- ggplot(data = tab, aes(x = age, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Age")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_age_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Age",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

#Balance 

#need to bin also 

bank_train$balancebin <- cut(bank_train$balance, 10)
mytable <- table(bank_train$balance, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("balance", "y", "perc")


ba_balance_plot <- ggplot(data = tab, aes(x = balance, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Balance")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_balance_plot

grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Balance",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))


#Day

bank_train$daybin <- cut(bank_train$day, c(1,7,14,21,31))

mytable <- table(bank_train$daybin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("day", "y", "perc")


ba_day_plot <- ggplot(data = tab, aes(x = day, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Day")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_day_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Day",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

#Duration

bank_train$durationbin <- cut(bank_train$duration, c(0,100,300,500,1000,5000))

mytable <- table(bank_train$durationbin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("duration", "y", "perc")


ba_duration_plot <- ggplot(data = tab, aes(x = duration, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Duration")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_duration_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Duration",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

#Campaign

bank_train$campaignbin <- cut(bank_train$campaign, c(0,2,3,5,100))


mytable <- table(bank_train$campaignbin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("campaign", "y", "perc")


ba_campaign_plot <- ggplot(data = tab, aes(x = campaign, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Campaign")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_campaign_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Campaign",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

#pdays

bank_train$pdaysbin <- cut(bank_train$pdays, c(-2,0,200,400,900))

mytable <- table(bank_train$pdaysbin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("pdays", "y", "perc")

ba_pdays_plot <- ggplot(data = tab, aes(x = pdays, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Pdays")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_pdays_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Pdays",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))


#previous
bank_train$prev_bin <- cut(bank_train$previous, c(0,3,5,60))

mytable <- table(bank_train$prev_bin, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("previous", "y", "perc")

ba_previous_plot <- ggplot(data = tab, aes(x = previous, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Previous")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

ba_previous_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Previous",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))
