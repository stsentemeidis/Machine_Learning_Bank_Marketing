BarFillColor <- "#330066"
HBarFillColor <- "#000099"
BarLineColor <- "#FFFAFA"
MissingColor <- "#FF6666"


str(bank_train)


### Exploratory Data Analysis

## Variable Treatment: Missings

numcols <- select_if(bank_train, is.numeric)
missmap(numcols, y.labels = NULL, y.at = NULL, 
        main = 'Missing values per Numeric variable', rank.order = TRUE,
        col = c(MissingColor, HBarFillColor)) #No missing values in Numeric variables

#Numeric Variables: No missings

catcols <- c("default","housing","loan","job","marital","education","contact","month","poutcome","y")
bank_train[,catcols] <- data.frame(apply(bank_train[catcols], 2, as.factor))
missmap(bank_train[,catcols], y.labels = NULL, y.at = NULL, 
        main = 'Missing values per Categorical variable', rank.order = TRUE,
        col = c(MissingColor, HBarFillColor)) #No missing values in Categorical variables

#Categorical Variables: No missings


## Variable Treatment: Outliers

### Numeric Variables
dev.off()
par(mfrow=c(1,4))
for(i in 1:ncol(numcols)) {
  boxplot(numcols[,i], main=names(numcols)[i])
}

### Categorical Variables
par(mfrow=c(1,1))
for(i in 1:length(catcols)) {
  counts <- table(bank_train[,catcols][,i])
  name <- names(bank_train[,catcols])[i]
  barplot(counts, main=name)
}

### Bivariate Analysis: Each variable against Targey (Y)

#Job
mytable <- table(bank_train$job, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("job", "y", "perc")

ggplot(data = tab, aes(x = job, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Job")+
  ylab("Percent")
  
#Blue-collar and Technicians are more likely not to open a deposit.

#Marital Status
mytable <- table(bank_train$marital, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("marital", "y", "perc")

ggplot(data = tab, aes(x = marital, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Marital")+
  ylab("Percent")+
  coord_cartesian(ylim = c(0, 1))

#Single people are more likely to open a deposit. 
#Married people are less likely. 
#Divorced 50%-50%

#Education
mytable <- table(bank_train$education, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("education", "y", "perc")

ggplot(data = tab, aes(x = education, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Education")+
  ylab("Percent")

#Higher education, higher chance of opening a deposit

#Contact
mytable <- table(bank_train$contact, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("contact", "y", "perc")

ggplot(data = tab, aes(x = contact, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Education")+
  ylab("Percent")

#Month
mytable <- table(bank_train$month, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("month", "y", "perc")

ggplot(data = tab, aes(x = month, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Month")+
  ylab("Percent")

#Default
mytable <- table(bank_train$default, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("default", "y", "perc")

ggplot(data = tab, aes(x = default, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Default")+
  ylab("Percent")

#Housing
mytable <- table(bank_train$housing, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("housing", "y", "perc")

ggplot(data = tab, aes(x = housing, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Housing")+
  ylab("Percent")

#Loan
mytable <- table(bank_train$loan, bank_train$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("loan", "y", "perc")

ggplot(data = tab, aes(x = loan, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Loan")+
  ylab("Percent")

