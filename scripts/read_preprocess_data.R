test <- read.csv("data_input/BankCamp_test.csv")
train <- read.csv("data_input/BankCamp_train.csv")

View(test)
View(train)

sum(is.na(train))

str(train)

test$y <- NA

all <- rbind(train, test)
str(all)
