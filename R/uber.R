uber <- read.csv('../datasets/uber.csv')
head(uber, 5)
hist(uber$fare_amount)

# rows with impossible and non-NY pickup coords cleaned
uber <- uber[uber$pickup_longitude <= -72, ] # 180
uber <- uber[uber$pickup_longitude >= -76, ] # -180

uber <- uber[uber$pickup_latitude <= 41.5, ] # 90
uber <- uber[uber$pickup_latitude >= 40, ] # -90

# rows with impossible and non-NY dropoff coords cleaned
uber <- uber[uber$dropoff_longitude <= -72, ] # 180
uber <- uber[uber$dropoff_longitude >= -76, ] # -180

uber <- uber[uber$dropoff_latitude <= 41.5, ] # 90
uber <- uber[uber$dropoff_latitude >= 39.5, ] # -90

uber = na.omit(uber)

# longitude = east-west   = x
# latitude  = south-north = y
plot(uber$pickup_longitude, uber$pickup_latitude, xlim = c(-75.5, -72), ylim = c(40, 41.5))
plot(uber$dropoff_longitude, uber$dropoff_latitude, xlim = c(-75.5, -72), ylim = c(40, 41.5))

max(uber$pickup_longitude)
min(uber$pickup_longitude)

max(uber$pickup_latitude)
min(uber$pickup_latitude)
