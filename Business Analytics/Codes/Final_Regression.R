##Regression##
library(readxl)
library(dplyr)
library(corrplot)
install.packages("kableExtra")
library(jtools)
library(kableExtra)
library(effects)
car <- read_excel("ToyotaCorolla.xlsx", sheet = 2)
str(car)

sum(is.na(car))

CarCor <- cor(car %>% select(-Model,-Fuel_Type,-Color,-CC))
corrplot(CarCor, type="upper", order="hclust", tl.col="black", tl.srt=45)

AgeGrntee <- lm(Price ~ Age_08_04+Guarantee_Period, car)
summary(AgeGrntee)
summ(AgeGrntee, render = 'normal_print')

AgeAuto <- lm(log(Price) ~ log(Age_08_04)+Automatic, car)
summ(AgeAuto, render = 'normal_print')
summary(AgeAuto)

AgeGrnteeAuto <- lm(log(Price) ~ log(Age_08_04)+log(Guarantee_Period)+
                      Automatic, car)
summ(AgeGrnteeAuto)
#guarantee period, automatic, age
str(car)

##Polynomial model
df <- car 
df$Guarantee_Period <- (df$Guarantee_Period-mean(df$Guarantee_Period))^2
df$Age_08_04 <- (df$Age_08_04)^2

PolynomialOutcomeOrgn <- lm(Price ~ Age_08_04+Guarantee_Period+Automatic, car)
PolynomialOutcome <- lm(Price ~ Age_08_04+Guarantee_Period+Automatic, df)
summ(PolynomialOutcome)
anova(PolynomialOutcome)
par()
dev.off()
plot(PolynomialOutcome)

cor((car$Age_08_04)^2,car$Guarantee_Period)
summary(car$Age_08_04)
summary(car$Guarantee_Period)

model <- allEffects(PolynomialOutcome)
summary(model)
plot(model, multiline = T)


##Interaction model 
df2 <- car 
df2$WarrantyLeft <- df2$Age_08_04 - df2$Guarantee_Period
df2$WarrantyLeft2 <- df2$Age_08_04 - df2$Guarantee_Period

for(i in 1:length(df2$WarrantyLeft)){
  if(df2$WarrantyLeft[i] > 0){
    df2$WarrantyLeft[i] <- 0
  }
  else if(df2$WarrantyLeft[i] > 0){
    df2$WarrantyLeft[i] <- abs(df2$WarrantyLeft[i]) 
  }
}

df2$WarrantyLeft <- abs(df2$WarrantyLeft)
summary(df2$WarrantyLeft)
InteractOutcome <- lm(log(Price+1) ~ log(Age_08_04+1)+log(Guarantee_Period+1)+Automatic+log(WarrantyLeft+1), df2)
summary(InteractOutcome)
summ(InteractOutcome)
plot(InteractOutcome)
model2 <- allEffects(InteractOutcome)
plot(model2)

multicolCheck <- lm(Price+1 ~ Age_08_04+Guarantee_Period+Automatic+WarrantyLeft2, df2)
summary(multicolCheck)
cor(df2$Age_08_04,df2$Guarantee_Period,df2$WarrantyLeft)

###Predictive Regression Analysis### 
PredCar <- car
str(PredCar)
View(PredCar$Model)
##Creating Dummy variables
#1. color (Default : RED)
PredCar$Color_Blue <- ifelse(PredCar$Color == 'Blue',1,0)
PredCar$Color_Silver <- ifelse(PredCar$Color == 'Silver',1,0)
PredCar$Color_Black <- ifelse(PredCar$Color == 'Black',1,0)
PredCar$Color_White <- ifelse(PredCar$Color == 'White',1,0)
PredCar$Color_Grey <- ifelse(PredCar$Color == 'Grey',1,0)
PredCar$Color_Green <- ifelse(PredCar$Color == 'Green',1,0)

#2. Fuel_type(Default : CNG)
PredCar$Fuel_Type_Diesel <- ifelse(PredCar$Fuel_Type == 'Diesel',1,0)
PredCar$Fuel_Type_Petrol <- ifelse(PredCar$Fuel_Type == 'Petrol',1,0)

#3. CC(Default : CC > 1600)
PredCar$CC_Under1600 <- ifelse(as.numeric(PredCar$CC) <= 1600,1,0)

#4. Model(Subtracted)
PredCar <- PredCar %>%  select(-Id,-Model, 
                               -Fuel_Type, -Color, -CC)
View(PredCar)
str(PredCar)

##partition it into 6:4
set.seed(12345)
num_rows <- round(nrow(PredCar)*0.6)
train_index <- sample(1:nrow(PredCar), num_rows)
train_PredCar <- PredCar[train_index,]
validation_PredCar <- PredCar[-train_index,]
str(train_PredCar)
str(validation_PredCar)

##Predictive regression analysis 
CarModel <- lm(Price~ 
              +Age_08_04+Mfg_Month+Mfg_Year
              +KM+HP+Met_Color+Automatic+Doors
              +Cylinders+Gears+Quarterly_Tax+Weight+Mfr_Guarantee
              +BOVAG_Guarantee+Guarantee_Period+ABS+Airbag_1
              +Airbag_2+Airco+Automatic_airco+Boardcomputer+CD_Player
              +Central_Lock+Powered_Windows
              +Power_Steering+Radio+Mistlamps+Sport_Model
              +Backseat_Divider+Metallic_Rim+Radio_cassette
              +Parking_Assistant+Tow_Bar
              +Color_Blue+Color_Silver+Color_Black+Color_White
              +Color_Green+Color_Grey
              +Fuel_Type_Petrol+Fuel_Type_Diesel
              +CC_Under1600
              ,PredCar)
summary(CarModel)
validation_PredCar$Predicted <- predict(CarModel, validation_PredCar)
validation_PredCar$residuals <- validation_PredCar$Price - validation_PredCar$Predicted

mse_car <- mean( (validation_PredCar$Price - validation_PredCar$Predicted)^2 )
rmse_car <- sqrt(mse_car)

#backward regerssion
reduced_Carmodel<-step(CarModel,direction="backward")

summary(reduced_Carmodel)
mse_carRdcd <- mean( (reduced_Carmodel$Price - reduced_Carmodel$predicted)^2 )
rmse_carRdcd <- sqrt(mse_carRdcd)


str(validation_PredCar)
predict.lm(CarModel)
summary(CarModel)
