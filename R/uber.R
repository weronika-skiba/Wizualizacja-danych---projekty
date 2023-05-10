uber <- read.csv('../datasets/uber.csv')

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

# borderline impossible passenger counts and fares cleaned
uber <- uber[uber$fare_amount <= 60, ]
uber <- uber[uber$fare_amount >= 0, ]
uber <- uber[uber$passenger_count <= 10, ]

uber = na.omit(uber)

# longitude = east-west   = x
# latitude  = south-north = y
plot(uber$dropoff_longitude, uber$dropoff_latitude, xlim = c(-75.5, -72), ylim = c(40, 41.5))
plot(uber$pickup_longitude, uber$pickup_latitude, xlim = c(-75.5, -72), ylim = c(40, 41.5))

# Function that selects only values from a column within a specified range
select_values_within_range <- function(uber, column_name, lower_bound, upper_bound) {
  # Select the column by name
  column <- uber[[column_name]]
  
  # Select values within range
  selected_values <- column[column >= lower_bound & column <= upper_bound]
  
  return(selected_values)
}

# One column histogram
for (col in 2:ncol(uber)) {
  if(is.numeric(uber[1,col]) && ! is.na(min(uber[,col]))){
    hist(uber[,col], breaks=10, main="Histogramy for column", ylab="Count", xlab=colnames(uber)[col], xlim=c(min(uber[,col]), max(uber[,col])) )
  }
}

# hist(uber$fare_amount, col = 'skyblue3', breaks = 30)
hist(uber$passenger_count, , col = 'skyblue3', breaks = 6)

# Column histogram with range
selected_values <- select_values_within_range(uber, "fare_amount", 0, 50)

hist(selected_values, main="Histogram for range 0-50", xlab="Fare amount", ylab="Count", col = 'skyblue3')
