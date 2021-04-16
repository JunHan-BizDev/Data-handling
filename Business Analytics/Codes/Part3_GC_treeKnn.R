library(C50)
library(gmodels)
library(tree)
library(class)
library(gmodels)

##using tree
Bank2 <- GCOrgn %>% select(-OBS.,-FURNITURE,-RADIO.TV,-PRESENT_RESIDENT,-AGE,-FOREIGN,
                           -MALE_DIV,-MALE_SINGLE,-MALE_MAR_or_WID,-CO.APPLICANT,-...33)
head(Bank2)

set.seed(12345)
Bank2_rand <- Bank2[order(runif(1000)),]


head(Bank2_rand)
str(Bank2_rand)
head(Bank2)

Bank2_train <- Bank2_rand[1:700, ]
Bank2_test <- Bank2_rand[701:1000, ]
str(Bank2_train)

prop.table(table(Bank2_test$DURATION))
prop.table(table(Bank2_train$DURATION))

Bank2_model <- C5.0(Bank2_train[,-22],as.factor(Bank2_train$RESPONSE))
summary(Bank2_model)

Bank2_pred <- predict(Bank2_model,Bank2_test)

CrossTable(Bank2_test$RESPONSE, Bank2_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual Y', 'predicted Y'))

##pruning 
cv.trees<-cv.tree(Bank2_model, FUN=prune.misclass ) 


#Using kNN

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
normalize(c(1, 2, 3, 4, 5))
normalize(c(10, 20, 30, 40, 50))

BankKNN1 <- GCOrgn %>% select(-OBS.,-FURNITURE,-RADIO.TV,-PRESENT_RESIDENT,-AGE,-FOREIGN,
                              -MALE_DIV,-MALE_SINGLE,-MALE_MAR_or_WID,-CO.APPLICANT,-...33)
str(BankKNN1)

table(BankKNN1$RESPONSE)
BankKNN1$RESPONSE <- factor(BankKNN1$RESPONSE)
#BankKNN1$y <- factor(BankKNN1$y, levels = c("yes", "no"))

BankKNN1$RESPONSE

round(prop.table(table(BankKNN1$RESPONSE)) * 100, digits = 1)
summary(BankKNN1[c(1,2,3,4)])

###
BankKNN1_n <- as.data.frame(lapply(BankKNN1[1:21], normalize))

summary(BankKNN1_n)


set.seed(12345)
BankKNN1_rand <- BankKNN1_n[order(runif(1000)),]

BankKNN1_train <- BankKNN1_rand[1:700, ]
BankKNN1_test <- BankKNN1_rand[701:1000, ]

BankKNN1_train_labels <- BankKNN1[1:700, 22]
BankKNN1_test_labels <- BankKNN1[701:1000, 22]

head(BankKNN1_train_labels)
head(BankKNN1_test_labels)

#run model 
BankKNN1_test_pred <- knn(train = BankKNN1_train, test = BankKNN1_test,cl = BankKNN1_train_labels, k=5)
CrossTable(x = BankKNN1_test_labels, y = BankKNN1_test_pred, prop.chisq=FALSE)


BankKNN1_test_pred <- knn(train = BankKNN1_train, test = BankKNN1_test,
                          cl = BankKNN1_train_labels, k=9)
CrossTable(x = BankKNN1_test_labels, y = BankKNN1_test_pred,
           prop.chisq=FALSE)

