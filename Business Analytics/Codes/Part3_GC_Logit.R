library(Amelia)
library(pscl)

GcLogit <- GCOrgn %>% select(-OBS.,-FURNITURE,-RADIO.TV,-PRESENT_RESIDENT,-AGE,-FOREIGN,
                             -MALE_DIV,-MALE_SINGLE,-MALE_MAR_or_WID,-CO.APPLICANT,-...33)

set.seed(12345)
GcLogit_rand <- GcLogit[order(runif(1000)),]

GcLogit_train <- GcLogit_rand[1:700, ]
GcLogit_test <- GcLogit_rand[701:1000, ]
str(GcLogit_test)

Logitmodel <- glm(RESPONSE ~.,family=binomial(link='logit'),data=GcLogit_train)

summary(Logitmodel)


##check the fit

pR2(Logitmodel)

fitted.results <- predict(Logitmodel,newdata=GcLogit_test),type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
table(fitted.results)

GcLogit_test <- bind_cols(GcLogit_test,fitted.results)

##Making pivot table

#Pred : Good, Act : Good
GcLogit_test %>% select(RESPONSE,...23) %>% 
  filter(RESPONSE == 1 & ...23 == 1) %>% 
  count(RESPONSE)

#Pred : Bad, Act : Bad
GcLogit_test %>% select(RESPONSE,...23) %>% 
  filter(RESPONSE == 0 & ...23 == 0) %>% 
  count(RESPONSE)

#Pred : Bad, Act : good
GcLogit_test %>% select(RESPONSE,...23) %>% 
  filter(RESPONSE == 1 & ...23 == 0) %>% 
  count(RESPONSE)

#Pred : good, Act : bad
GcLogit_test %>% select(RESPONSE,...23) %>% 
  filter(RESPONSE == 0 & ...23 == 1) %>% 
  count(RESPONSE)



