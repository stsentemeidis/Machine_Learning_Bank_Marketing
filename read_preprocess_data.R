test <- read.csv("data_input/BankCamp_test.csv")
train <- read.csv("data_input/BankCamp_train.csv")

View(test)
View(train)

sum(is.na(train))
sum(is.na(test))

test$y <- "no"

all <- rbind(train, test)

changeval <- c("y", "default", "housing", "loan")



#for (i in changeval) {

#  (all[all$i, i] == 'yes' = 1)
#  (all[all[,i],i]  == 'no' = 0)
#}


all$y = ifelse(all$y=="yes", 1, 0) #yes = 1, no = 0

all$default = ifelse(all$default == "yes", 1, 0) #yes = 1, no = 0

all$housing = ifelse(all$housing == "yes", 1, 0) #yes = 1, no = 0

all$loan = ifelse(all$loan == "yes", 1, 0) #yes = 1, no = 0

summary(all)

write.csv(all, "data_output/all_0_1.csv")

