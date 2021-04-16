setwd("/Users/ME/Desktop/Works/Major/Business/BA/Assignments/BA_Final/Final_Exam_Datasets-1")
library(arules)
library(dplyr)


##########
#drop the useless column
catalog <- catalog %>% select(-.)
##transform it into logical
catalogLogical <- sapply(catalog, as.logical)

trans2 <- as(catalogLogical,"transactions")
summary(trans2)
str(trans2)
inspect(trans2[1:5])

transrules <- apriori(trans2, 
                      parameter = list(support =0.2, 
                                       confidence = 0.8, minlen = 2))

inspect(transrules)


transDisc <- discretizeDF(catalog)
head(transDisc)
trans2 <- as(transDisc, "transactions")
head(trans2)
inspect(head(trans2))


###the following codes are the trials and errors 

catalog <- read.csv("CatalogCrossSell.csv", stringsAsFactors = F)
str(catalog)
head(catalog)

catalog.list <- split(catalog[1,],catalog[-1,])

#drop the useless column
catalog <- catalog %>% select(-.)

Catalog <- read.transactions("CatalogCrossSell.csv", format =  "basket", sep = ",", header = T)
#                             cols = c("Automotive","Computers",	"Personal Electronics",	
#                             "Garden",	"Clothing",	"Health",	"Jewelry"	,"Housewares"))


Catalog <- read.transactions("CatalogCrossSell.csv", format = "basket",header = T, sep = ",",
                             cols = 1)
summary(Catalog)

data(Catalog)
inspect(Catalog[1:5])
itemFrequency(Catalog[,1:30])


itemFrequencyPlot(catalog, support = 0.1)

itemFrequencyPlot(Catalog, topN = 4)



catalogset = apriori(Catalog, 
                     parameter = list(support = 0.006, 
                                      confidence = 0.25, minlen = 2))


        