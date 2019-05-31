str(bank_train)

str(raw_train)
sort(summary(raw_train$job), dec=T)/nrow(raw_train)


#unbalanced Data Target Variable
qplot(bank_train$y, main = "Frequency of Target")+ xlab("term deposit") +
  ylab("Frequency") + theme(axis.text.x = element_text(hjust = 0.2))
sort(summary(raw_train$y), dec=T)/nrow(raw_train)

# Age vs Y by marital status
qplot(x=bank_train$age, y=bank_train$y, colour= bank_train$marital, xlab="age",
      ylab= " Term deposit", main = "Age by Term Deposit") + theme()

qplot(x=bank_train$age, y=bank_train$y, colour= bank_train$job, xlab="age",
      ylab= " Term deposit", main = "Age by Term Deposit") + theme()

qplot(bank_train$job,fill = bank_train$y==1, main = "Titler")+ xlab("job") +  ylab("Frequency")+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.2))


qplot(x=bank_train$education, fill= bank_train$y==1, xlab="education",
      ylab= " Term deposit", main = "Age by Term Deposit") + theme()

qplot(x=bank_train$job, fill= bank_train$education, colour= bank_train$y==1, xlab="job",
      ylab= " Frequency", main = "Job by Term Deposit") + 
  theme(axis.text.x = element_text(angle = 90,hjust = 0.2))

qplot(x=bank_train$job, fill= bank_train$education, xlab="job",
      ylab= " Frequency", main = "Job by Term Deposit") + 
  theme(axis.text.x = element_text(angle = 90,hjust = 0.2))

str(bank_train)

#People that default do not invest in term deposit
qplot(x=bank_train$default==1,fill=bank_train$y==1, xlab="Default",
      ylab= " Frequency", main = "default by Term Deposit") + 
  theme(axis.text.x = element_text(angle = 90,hjust = 0.2))

