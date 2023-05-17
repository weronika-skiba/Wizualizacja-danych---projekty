# install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", 
#                   "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata"))

library("ggplot2")
theme_set(theme_bw())
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("dplyr")

# dane
world <- ne_countries(scale = "medium", returnclass = "sf")
ski <- read.csv('../datasets/ski-resorts.csv')

for (col in names(ski)) {
    # Calculate the frequency of each category
    freq <- table(ski[col])

    # Create a bar plot
    barplot(freq, main = "Histogram", xlab = col, ylab = "Frequency")
}

# wykres 1 - zliczenie stokow w kazdym panstwie
resorts_count <- ski %>% count(Country, name="nResorts", sort=TRUE)
nResortsWhole = c()
for (panstwo in world$name) {
  if (panstwo %in% resorts_count$Country) {
    n = resorts_count[match(panstwo,resorts_count$Country), 2]
    nResortsWhole <- c(nResortsWhole, n)
  } else {
    nResortsWhole <- c(nResortsWhole, 0)
  }
}
world['numOfResorts'] <- nResortsWhole

# wykres 1
ggplot(data = world) +
  geom_sf(aes(fill = numOfResorts)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt") +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Resorty narciarskie na świecie") 

# wykres 2 - barplot ilosci stokow

resorts_count_slice = resorts_count[1:10, ]
ggplot(resorts_count_slice, aes(x=reorder(Country, desc(nResorts)), y=nResorts)) + 
  geom_bar(stat = "identity")

