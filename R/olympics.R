library("ggplot2")
theme_set(theme_bw())
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("dplyr")

# dane
world <- ne_countries(scale = "medium", returnclass = "sf")
olympics <- read.csv('../datasets/olympics.csv', sep = ";")

# zliczenie medali na panstwo, dodanie tego do world dla wygody
allMedals = olympics[olympics$Place >= 3,]
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
for (panstwo in world$name) {
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

# wykres 1 - mapa, medale na siwecie
ggplot(data = world) +
  geom_sf(aes(fill = allMeds)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt") +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Wszystkie zdobyte medale") 