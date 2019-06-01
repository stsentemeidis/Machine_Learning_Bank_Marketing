BarFillColor <- "#330066"
HBarFillColor <- "#000099"
BarLineColor <- "#FFFAFA"
MissingColor <- "#FF6666"

# Palette Colour
color1 = 'black'
color2 = 'white'
color3 = 'azure'
color4 = 'darkorchid3'
font1 = 'Impact'
font2 = 'Helvetica'

# Copy dataframe for the plots
bank_train_plot <- bank_train

###########################################################################################
### Exploratory Data Analysis

## Variable Treatment: Missings

numcols <- c('age','balance','day','duration','campaign','pdays')
Amelia::missmap(bank_train_plot[,numcols], y.labels = NULL, y.at = NULL, 
        main = 'Missing values per Numeric variable', rank.order = TRUE,
        col = c(MissingColor, HBarFillColor)) #No missing values in Numeric variables

#Numeric Variables: No missings

catcols <- c("default","housing","loan","job","marital","education","contact","month","poutcome","y")
bank_train_plot[,catcols] <- data.frame(apply(bank_train[catcols], 2, as.factor))
Amelia::missmap(bank_train[,catcols], y.labels = NULL, y.at = NULL, 
        main = 'Missing values per Categorical variable', rank.order = TRUE,
        col = c(MissingColor, HBarFillColor)) #No missing values in Categorical variables
#Categorical Variables: No missings


###########################################################################################
## Variable Treatment: Outliers
# bank_train_plot$y <- as.numeric(bank_train_plot$y)
### Numeric Variables
# dev.off()
# par(mfrow=c(1,4))
# for(i in numcols) {
#   boxplot(bank_train[,i], main=names(bank_train[,i]))
# }


# Need to fix the way it works some parameter is missing
for (i in numcols){
    assign(paste0(i,'_box_plot'), ggplot(bank_train, aes_string(x=i, y=y)) +
             geom_boxplot(fill = color4)+
             theme_tufte(base_size = 5, ticks=F)+
             theme(plot.margin = unit(c(10,10,10,10),'pt'),
                   axis.title=element_blank(),
                   axis.text = element_text(colour = color2, size = 7, family = font2),
                   axis.text.x = element_text(hjust = 1, size = 7, family = font2, angle = 45),
                   legend.position = 'None',
                   plot.background = element_rect(fill = color1)))}

age_box_plot
balance_box_plot
day_box_plot
duration_box_plot
campaign_box_plot
pdays_box_plot


# 1. Need Histograms for the numerical variables
# for (i in numcols){
#   assign(paste0(i,'_hist_plot'), ggplot(data=bank_train_plot, aes(x=i)) + 
#            geom_histogram(col=color4,aes(fill=color3), fill = color3) +
#            theme_tufte(base_size = 5, ticks=F)+
#            theme(plot.margin = unit(c(10,10,10,10),'pt'),
#                  axis.title=element_blank(),
#                  axis.text = element_text(colour = color2, size = 10, family = font2),
#                  axis.text.x = element_text(hjust = 1, size = 10, family = font2),
#                  legend.position = 'None',
#                  plot.background = element_rect(fill = color1)))}
# 
# age_hist_plot
# balance_hist_plot
# day_hist_plot
# duration_hist_plot
# campaign_hist_plot
# pdays_hist_plot

ggplot(data=bank_train_plot, aes(x=balance)) + 
  geom_histogram(col=color4,aes(fill=color3), fill = color3,binwidth = 100) +
  scale_x_continuous(limits = c(0, 25000))+
  scale_y_continuous(limits = c(0, 4000))+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color2, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))

###########################################################################################
### Categorical Variables
# par(mfrow=c(1,1))
# for(i in 1:length(catcols)) {
#   counts <- table(bank_train[,catcols][,i])
#   name <- names(bank_train[,catcols])[i]
#   barplot(counts, main=name)
# }

for (i in catcols){
  if (i == 'job' | i == 'month'){
    bank_train_plot[, i] <- as.factor(bank_train_plot[,i])
    assign(paste0(i,'_factor_plot'), ggplot(bank_train_plot, aes_string(x=i)) +
           geom_bar(fill = color4)+
           theme_tufte(base_size = 5, ticks=F)+
           theme(plot.margin = unit(c(10,10,10,10),'pt'),
                 axis.title=element_blank(),
                 axis.text = element_text(colour = color2, size = 7, family = font2),
                 axis.text.x = element_text(hjust = 1, size = 7, family = font2, angle = 45),
                 legend.position = 'None',
                 plot.background = element_rect(fill = color1)))}
  else{
    bank_train_plot[, i] <- as.factor(bank_train_plot[,i])
    assign(paste0(i,'_factor_plot'), ggplot(bank_train_plot, aes_string(x=i)) +
             geom_bar(fill = color4)+
             theme_tufte(base_size = 5, ticks=F)+
             theme(plot.margin = unit(c(10,10,10,10),'pt'),
                   axis.title=element_blank(),
                   axis.text = element_text(colour = color2, size = 7, family = font2),
                   axis.text.x = element_text(hjust = 1, size = 7, family = font2),
                   legend.position = 'None',
                   plot.background = element_rect(fill = color1)))
  }
}
default_factor_plot
housing_factor_plot
loan_factor_plot
job_factor_plot
marital_factor_plot
education_factor_plot
contact_factor_plot
month_factor_plot
poutcome_factor_plot
y_factor_plot

grid.arrange(default_factor_plot,
             housing_factor_plot,
             loan_factor_plot,
             job_factor_plot,
             marital_factor_plot,
             education_factor_plot,
             contact_factor_plot,
             month_factor_plot,
             poutcome_factor_plot,
             y_factor_plot )

###########################################################################################
### Bivariate Analysis: Each variable against Target (Y)

#Job
mytable <- table(bank_train_plot$job, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("job", "y", "perc")

ba_job_plot <- ggplot(data = tab, aes(x = job, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) + 
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Job")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_job_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Job",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

#Blue-collar and Technicians are more likely not to open a deposit.

###########################################################################################
#Marital Status
mytable <- table(bank_train_plot$marital, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("marital", "y", "perc")

ba_marital_plot <- ggplot(data = tab, aes(x = marital, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Marital")+
  ylab("Percent")+
  coord_cartesian(ylim = c(0, 1))+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_marital_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Marital",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))
#Single people are more likely to open a deposit. 
#Married people are less likely. 
#Divorced 50%-50%

###########################################################################################
#Education
mytable <- table(bank_train_plot$education, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("education", "y", "perc")

ba_education_plot <- ggplot(data = tab, aes(x = education, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Education")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_education_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Education",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))
#Higher education, higher chance of opening a deposit

###########################################################################################
#Contact
mytable <- table(bank_train_plot$contact, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("contact", "y", "perc")

ba_contact_plot <- ggplot(data = tab, aes(x = contact, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Contact")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_contact_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Contact",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

###########################################################################################
#Month
mytable <- table(bank_train_plot$month, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("month", "y", "perc")

ba_month_plot <- ggplot(data = tab, aes(x = month, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Month")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_month_plot
grid.text(unit(0.2, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Month",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

###########################################################################################
#Default
mytable <- table(bank_train_plot$default, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("default", "y", "perc")

ba_default_plot <- ggplot(data = tab, aes(x = default, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Default")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_default_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Default",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

###########################################################################################
#Housing
mytable <- table(bank_train_plot$housing, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("housing", "y", "perc")

ba_housing_plot <- ggplot(data = tab, aes(x = housing, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Housing")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_housing_plot
grid.text(unit(0.62, 'npc'), unit(0.97,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Housing",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

###########################################################################################
#Loan
mytable <- table(bank_train_plot$loan, bank_train_plot$y)
tab <- as.data.frame(prop.table(mytable, 2))
colnames(tab) <-  c("loan", "y", "perc")

ba_loan_plot <- ggplot(data = tab, aes(x = loan, y = perc, fill = y)) + 
  geom_bar(stat = 'identity', position = 'dodge', alpha = 2/3) +
  theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
  xlab("Loan")+
  ylab("Percent")+
  theme_tufte(base_size = 5, ticks=F)+
  theme(plot.margin = unit(c(10,10,10,10),'pt'),
        axis.title=element_blank(),
        axis.text = element_text(colour = color3, size = 10, family = font2),
        axis.text.x = element_text(hjust = 1, size = 10, family = font2),
        legend.position = 'None',
        plot.background = element_rect(fill = color1))
ba_loan_plot
grid.text(unit(0.6, 'npc'), unit(0.9,"npc"), check.overlap = T,just = "left",
          label="Bivariate Analysis - Loan",
          gp=gpar(col=color3, fontsize=13, fontfamily = font2))

