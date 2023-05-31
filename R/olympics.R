library("ggplot2")
theme_set(theme_bw())
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("dplyr")

# dane
world <- ne_countries(scale = "medium", returnclass = "sf")
olympics <- read.csv('../datasets/olympics.csv', sep = ";")

tabledata <- table(olympics$Year)
barplot(tabledata, main='Year', ylab="Count", las=2)

tabledata <- table(olympics$Sport)
tabledata <- tabledata[tabledata > 2000]
barplot(tabledata, main='Sport with frequency > 2000', ylab="Count", las=2)

tabledata <- table(olympics$Sport)
tabledata <- tabledata[tabledata > 5000]
barplot(tabledata, main='Sport with frequency > 5000', ylab="Count", las=2)


tabledata <- table(olympics$Sport)
tabledata <- tabledata[tabledata < 50]
barplot(tabledata, main='Sport with frequency < 100', ylab="Count", las=2)

tabledata <- table(olympics$Type)
barplot(tabledata, main='Type of event', ylab="Count", las=2)

olympics_Germany <- olympics[olympics$Country == 'Germany', ]
tabledata <- table(olympics_Germany$Sport)
tabledata <- tabledata[tabledata > 50]
barplot(tabledata, main='Sports for Germany', ylab="Count", las=2)

olympics_Poland <- olympics[olympics$Country == 'Poland', ]
tabledata <- table(olympics_Poland$Sport)
tabledata <- tabledata[tabledata > 50]
barplot(tabledata, main='Sports for Poland <3', ylab="Count", las=2)

olympics_France <- olympics[olympics$Country == 'France', ]
tabledata <- table(olympics_France$Sport)
tabledata <- tabledata[tabledata > 50]
barplot(tabledata, main='Sports for France', ylab="Count", las=2)

# zliczenie medali na panstwo, dodanie tego do world dla wygody
allMedals = olympics[olympics$Place <= 3,]
goldMedals = olympics[olympics$Place == 1,]

allMedalsCount <- allMedals %>%
                  group_by(Country) %>% 
                  summarise(total_count=n(), .groups = 'drop') %>%
                  as.data.frame()

goldMedalsCount <- goldMedals %>%
                  group_by(Country) %>% 
                  summarise(total_count=n(), .groups = 'drop') %>%
                  as.data.frame()

amc = c()
gmc = c()
for (panstwo in world$name_sort) {
  if (panstwo %in% allMedalsCount$Country) {
    n = allMedalsCount[match(panstwo,allMedalsCount$Country), 2]
    amc <- c(amc, n)
  } else {
    amc <- c(amc, 0)
  }
  if (panstwo %in% goldMedalsCount$Country) {
    n = goldMedalsCount[match(panstwo,goldMedalsCount$Country), 2]
    gmc <- c(gmc, n)
  } else {
    gmc <- c(gmc, 0)
  }
}
world['allMeds'] <- amc
world['goldMeds'] <- gmc

# wykres 1 - slupki medali
allmeds_count_slice = allMedalsCount[order(allMedalsCount$total_count, decreasing=TRUE),][2:16,]
ggplot(allmeds_count_slice, aes(x=reorder(Country, desc(total_count)), y=total_count)) + 
  geom_bar(stat = "identity") + ggtitle("Wszystkie zdobyte medale") 

# wykres 2 - mapa, medale na swiecie
ggplot(data = world) +
  geom_sf(aes(fill = allMeds)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt") +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Wszystkie zdobyte medale")

# wykres 3 - slupki zlotych medali
goldmeds_count_slice = goldMedalsCount[order(goldMedalsCount$total_count, decreasing=TRUE),][2:16,]
ggplot(goldmeds_count_slice, aes(x=reorder(Country, desc(total_count)), y=total_count)) + 
  geom_bar(stat = "identity") + ggtitle("Zdobyte złote medale") 

# wykres 4 - mapa, zlote medale na swiecie
ggplot(data = world) +
  geom_sf(aes(fill = goldMeds)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt") +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Zdobyte złote medale") 

# agregacja polskich wyników co roku
polympics = olympics[olympics$Country == 'Poland',]
polympics = na.omit(polympics)

avg_place = aggregate(polympics$Place, list(polympics$Year), mean)
sum_allmeds = polympics[polympics$Place <= 3,] %>%
              count(Year, name="all_count")
sum_goldmeds = polympics %>%
              group_by(Year) %>%
              summarize(gold_count = sum(Place == 1))

# wykres 5 - wyniki polskich sportowcow w czasie
plot(avg_place$Group.1, avg_place$x, type = "b", pch = 20, 
     col = "red", xlab = "Rok", ylab = "Ilość medali", ylim = c(0, 70))
lines(sum_goldmeds$Year, sum_goldmeds$gold_count, pch = 20, col = "blue", type = "b")
lines(sum_allmeds$Year, sum_allmeds$all_count, pch = 20, col = "green", type = "b")
legend("topleft", legend=c("Średnie miejsce", "Złote medale", "Wszystkie medale"),
       col=c("red", "blue", "green"), lty = 1:1:1, cex=0.8)
title('Wyniki polskich sportowców')

# wykres 6 - wazny polski wykres
plot(avg_place$Group.1, avg_place$x, type = "b", pch = 20, 
     col = "red", xlab = "Rok", ylab = "Ilość medali", ylim = c(0, 70))
lines(sum_goldmeds$Year, sum_goldmeds$gold_count, pch = 20, col = "blue", type = "b")
lines(sum_allmeds$Year, sum_allmeds$all_count, pch = 20, col = "green", type = "b")
legend("topleft", legend=c("Średnie miejsce", "Złote medale", "Wszystkie medale","Pontyfikat Jana Pawła II"),
       col=c("red", "blue", "green","yellow"), lty = 1:1:1:2, cex=0.8)
abline(v=c(1978,2005), col=c("yellow", "yellow"), lty=c(2,2), lwd=c(3, 3))
title('Wpływ objęcia pontyfikatu przez Jana Pawła II na wyniki polskich sportowców')
