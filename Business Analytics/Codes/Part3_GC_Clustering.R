library(factoextra)
library(FactoMineR)
GC <- read.csv("GermanCredit.csv", stringsAsFactors = F)
str(GC)
GCOrgn <- read.csv("GermanCredit.csv", stringsAsFactors = F)
GC <- GC %>% select(-OBS.,-FURNITURE,-RADIO.TV,-PRESENT_RESIDENT,-AGE,-FOREIGN,
                    -MALE_DIV,-MALE_SINGLE,-MALE_MAR_or_WID,-CO.APPLICANT)
GC2 <- GCOrgn %>% select(-OBS.,-AGE,-FOREIGN,
                    -MALE_DIV,-MALE_SINGLE,-MALE_MAR_or_WID,-CO.APPLICANT)

colnames(GC)

clust_scaled = scale(GC) %>% as_tibble()
clust_scaled2 = scale(GC2) %>% as_tibble()

cs = scale(GCOrgn) %>% as_tibble()
set.seed("123455678")
kmeans1 <- kmeans(clust_scaled,  centers = 2) # 11 attri
kmeans2 <- kmeans(cs, centers = 2) #All attri
kmeans3 <- kmeans(clust_scaled2, centers = 2) # 14 attri

a<-fviz_nbclust(x = clust_scaled, FUNcluster = kmeans, method='wss') + 
  geom_vline(xintercept = 4, linetype = 2)

data_clust$cluster = kmeans1$cluster

fviz_cluster(kmeans1, clust_scaled)+ theme_bw()+theme(
  legend.background = element_rect(color = 'black', 
                                   size = 0.5),plot.margin=margin(50,10,50,10))


fviz_cluster(kmeans2, cs)+ theme_bw()+theme(
  legend.background = element_rect(color = 'black', 
                                   size = 0.5),plot.margin=margin(50,10,50,10))

fviz_cluster(kmeans3, clust_scaled2)+ theme_bw()+theme(
  legend.background = element_rect(color = 'black', 
                                   size = 0.5),plot.margin=margin(50,10,50,10))

GC.res <- PCA(clust_scaled, graph = F)
fviz_contrib(GC.res, choice = "var", axes = 1, top = 7)
fviz_contrib(GC.res, choice = "var", axes = 2, top = 7)

length(kmeans1$cluster)
str(GCOrgn)
GCOrgn <- bind_cols(GCOrgn,kmeans1$cluster)

##Making pivot table

#Pred : Good, Act : Good
GCOrgn %>% select(RESPONSE,...33) %>% 
  filter(RESPONSE == 1 & ...33 == 1) %>% 
  count(RESPONSE)

#Pred : Bad, Act : Bad
GCOrgn %>% select(RESPONSE,...33) %>% 
  filter(RESPONSE == 0 & ...33 == 2) %>% 
  count(RESPONSE)

#Pred : Bad, Act : good
GCOrgn %>% select(RESPONSE,...33) %>% 
  filter(RESPONSE == 1 & ...33 == 2) %>% 
  count(RESPONSE)

#Pred : good, Act : bad
GCOrgn %>% select(RESPONSE,...33) %>% 
  filter(RESPONSE == 0 & ...33 == 1) %>% 
  count(RESPONSE)


##Screening the output 

