# regression.R
#
# 
#
#
#
#
#
#
#
#
# ----------------------

# Set Working Directory: (e.g.)
setwd("~/Coding/projects/scripts/regression")

# Load our libraries:
library(data.table)
library(ggplot2)

# Include another function housed in an external file:
source("multiplot.R")

# ----------------------
# DATA
# ----------------------

# Load the sample data:
dat.listings <- read.csv('data/listings.csv', header=TRUE, stringsAsFactors=FALSE)
dat.bookings <- read.csv('data/bookings.csv',  header=TRUE)

# Tidy up the listings data to remove redundant information: (note: we need to transform the strings to their numeric equivalents)
dat.listings$prop_type <- gsub("Property type ", "", dat.listings$prop_type)
dat.listings$neighborhood <- gsub("Neighborhood ", "", dat.listings$neighborhood)

dat.listings <- transform(dat.listings, prop_type = as.numeric(prop_type), neighborhood = as.numeric(neighborhood))

#head(dat.listings)
#head(dat.bookings)


# Extract the column of property ids:
prop_ids = data.frame(id=seq(1, max(dat.listings$prop_id)), prop_id=dat.listings$prop_id)


# Convert the bookings to a data frame based on occurrence:
bookings <- as.data.frame(table(dat.bookings$prop_id))
colnames(bookings) <- c('prop_id', 'num_bookings')


# Merge the data frames:
bookings <- merge(bookings, prop_ids, by = "prop_id", all.y = TRUE)


# Perform some data frame manipulations to get the data in a format we want: (NOTE: there is probably a better way!)


bookings <- bookings[,2:3]

# Get rid of the NA's:
bookings$num_bookings[is.na(bookings$num_bookings)] <- 0


# Sort the data:
bookings <- bookings[order(bookings$id),]


# Rearrange:
bookings <- bookings[,c("id", "num_bookings")]
colnames(bookings) <- c("prop_id", "num_bookings")

# Combine the bookings data with our listings data:
dat.listings["num_bookings"] <- bookings$num_bookings



# Tidy the workspace:
rm(bookings, prop_ids, dat.bookings)



# ----------------------
# EXPLORATION
# ----------------------


# Intuition: as price increases, fewer bookings
p1 <- ggplot(dat.listings, aes(x = log(price), y = log(num_bookings))) + geom_point() + ggtitle("Effect of Price on Bookings")

# Intuition: as picture_count increases, more bookings
p2 <- ggplot(dat.listings, aes(x = log(picture_count), y = log(num_bookings))) + geom_point() + ggtitle("Effect of Picture Count on Bookings")

# Intuition: as description_length increases, more bookings (possibly up until a point)
p3 <- ggplot(dat.listings, aes(x = log(description_length), y = log(num_bookings))) + geom_point() + ggtitle("Effect of Description Length on Bookings")

# Intuition: as person_capacity increases, less bookings (possibly due to younger couples traveling rather than families)
p4 <- ggplot(dat.listings, aes(x = log(person_capacity), y = log(num_bookings))) + geom_point() + ggtitle("Effect of Person Capacity on Bookings")

# Intuition: as tenure_months increases, more bookings (listings arnd for longer have more booking opportunities and avoid saturation effects)
p5 <- ggplot(dat.listings, aes(x = log(tenure_months), y = log(num_bookings))) + geom_point() + ggtitle("Effect of Tenure Months on Bookings")


multiplot(p1, p2, p3, p4, p5, cols=2)

# ----------------------
# FILTERING
# ----------------------

# Remove all neighborhoods with fewer than 10 listings:

neighborhoods <- as.data.frame(table(dat.listings$neighborhood))
colnames(neighborhoods) <- c("id", "num_listings")
neighborhoods.sub <- subset(neighborhoods, num_listings >= 10)

#head(neighborhoods)
#head(neighborhoods.sub)

# Subset the listings data based on our filtered neighborhoods:
dat.listings.sub <- dat.listings[dat.listings$neighborhood %in% neighborhoods.sub$id, ]


# Tidy the workspace:
rm(neighborhoods, neighborhoods.sub)


# ----------------------
# REGRESSION
# ----------------------

# OLS fitting:
# OLS linear regression of price, person_capacity, and description_length as the independent variables against total bookings per listing as the dependent variable.
lm.fit <- lm(log(num_bookings) ~ log(price) + log(person_capacity) + log(description_length), data=dat.listings.sub, subset=(num_bookings > 0 & person_capacity > 0 & description_length > 0))


# Summary:
summary(lm.fit)


# Individual Regression:
lm.fit <- lm(log(num_bookings) ~ log(price), data=dat.listings.sub, subset=(num_bookings > 0 & price > 0))
print("price")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(person_capacity), data=dat.listings.sub, subset=(num_bookings > 0 & person_capacity > 0))
print("person_capacity")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(description_length), data=dat.listings.sub, subset=(num_bookings > 0 & description_length > 0))
print("description_length")
summary(lm.fit)$r.squared




# Repeat OLS fitting, but now for all data in listings against the total bookings:
lm.fit <- lm(log(num_bookings) ~ log(prop_type) + log(neighborhood) + log(price) + log(person_capacity) + log(picture_count) + log(description_length) + log(tenure_months), data=dat.listings.sub, subset=(num_bookings > 0 & price > 0 & person_capacity > 0 & picture_count > 0 & description_length > 0 & tenure_months > 0))


# Summary:
summary(lm.fit)


# Individual Regression:
lm.fit <- lm(log(num_bookings) ~ log(prop_type), data=dat.listings.sub, subset=num_bookings > 0)
print("prop_type")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(neighborhood), data=dat.listings.sub, subset=num_bookings > 0)
print("neighborhood")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(price), data=dat.listings.sub, subset=(num_bookings > 0 & price > 0))
print("price")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(person_capacity), data=dat.listings.sub, subset=(num_bookings > 0 & person_capacity > 0))
print("person_capacity")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(picture_count), data=dat.listings.sub, subset=(num_bookings > 0 & picture_count > 0))
print("picture_count")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(description_length), data=dat.listings.sub, subset=(num_bookings > 0 & description_length > 0))
print("description_length")
summary(lm.fit)$r.squared

lm.fit <- lm(log(num_bookings) ~ log(tenure_months), data=dat.listings.sub, subset=(num_bookings > 0 & tenure_months > 0))
print("tenure_months")
summary(lm.fit)$r.squared











# ----------------------
# EOS