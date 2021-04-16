setwd("/Users/ME/Desktop/Works/Major/Business/BA/Assignments/BA_Final/Final_Exam_Datasets-1")


Blog <- read.csv("blogData.csv", header = F, stringsAsFactors = F)
View(Blog)
##Preprocessing 

# essential attributes : 52,54,55,57,59,60,61,264~269,270~276,280
# interaction term : 57 * 52, 56 / 280
sum(is.na(Blog))
BlogOrgn <- Blog
Blog <- BlogOrgn %>% 
  mutate(BlogOrgn, V300 = V57 * V52) %>% 
  mutate(BlogOrgn, V301 = V56 / (V280+1)) %>% 
  select(-c(1:50),-c(63:262),-c(55,58,60,269,270),-c(272:279)) 

View(Blog)

#1. 
#partition the data into 7:3 

num_rows_blog <- round(nrow(Blog)*0.7)
train_index_blog <- sample(1:nrow(Blog), num_rows_blog)
train_Blog <- Blog[train_index_blog,]
validation_Blog <- Blog[-train_index_blog,]

View(validation_Blog)

#modeling
BlogModel <- lm(V281 ~ .,train_Blog)
summary(BlogModel)
summ(BlogModel)
head(validation_Blog)

validation_Blog$V282 <- predict(BlogModel, validation_Blog)
validation_Blog$V283 <- validation_Blog$V281 - validation_Blog$V282

View(validation_Blog)
mse <- mean( (validation_Blog$V281 - validation_Blog$V282)^2 )
rmse <- sqrt(mse)

# model reduce
reduced_model<-step(BlogModel,direction="backward")

# view best model
summary(reduced_model)
summ(reduced_model)


#add 55,60,269,280 & interaction term to elimated model

Refined_Blog <- Blog %>% 
  mutate(Blog, V300 = V57 * V52) %>% 
  mutate(Blog, V301 = V56 / (V280+1)) %>% 
  select(-c(1:50),-c(63:262),-c(58,270),-c(272:279)) 

View(Refined_Blog)

#partition the data into 7:3 

num_rows_blog_rfnd <- round(nrow(Refined_Blog)*0.7)
train_index_blog_rfnd <- sample(1:nrow(Refined_Blog), num_rows_blog_rfnd)
train_Blog_rfnd <- Refined_Blog[train_index_blog_rfnd,]
validation_Blog_rfnd <- Refined_Blog[-train_index_blog_rfnd,]
View(validation_Blog_rfnd)
#modeling 
BlogModel_Refined <- lm(V281 ~ .,train_Blog_rfnd)

summary(BlogModel_Refined)
summ(BlogModel_Refined)
head(validation_Blog)

validation_Blog_rfnd$V282 <- predict(BlogModel_Refined, validation_Blog_rfnd)
validation_Blog_rfnd$V283 <- validation_Blog_rfnd$V281 - validation_Blog_rfnd$V282

View(validation_Blog)
mse_rfnd <- mean( (validation_Blog_rfnd$V281 - validation_Blog_rfnd$V282)^2 )
rmse_rfnd <- sqrt(mse_rfnd)


cc <- 
(eqn <- paste("Y =", paste(round(cc[1],2), 
                           paste(round(cc[-1],2), 
                                 names(cc[-1]), sep=" * ",
                                 collapse=" + "), 
                           sep=" + "), "+ e"))

