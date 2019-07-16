### Peer-graded Assignment: Plot 1 ###

# Download data and unzip file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip", exdir = getwd()) 

# Estimate time for loading data
library(data.table) # Use data.table to load big file
system.time(hh_power_consumption <- fread("household_power_consumption.txt", na.strings = "?")) # 2.109 elapsed, not too long

# Keep the data for 1/2/2007 and 2/2/2007 only
hh_power_consumption <- data.frame(hh_power_consumption[hh_power_consumption$Date %in% c("1/2/2007", "2/2/2007"),])

# Check for missing value in selected data
apply(is.na(hh_power_consumption), 2, sum) # None NA

# Processing date and time
library(lubridate)
hh_power_consumption$Date <- dmy(hh_power_consumption$Date)
hh_power_consumption$timestamp <- strptime(paste(hh_power_consumption$Date, hh_power_consumption$Time), 
                                           "%Y-%m-%d %H:%M:%S")
hh_power_consumption$timestamp <- as.POSIXct(hh_power_consumption$timestamp)

# Plotting using histogram
par(mar = c(5, 6, 1, 2))

hist(hh_power_consumption$Global_active_power, 
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency", 
     col = "red", 
     main = "Global Active Power")

dev.copy(png, file = "./ExData_Plotting1/plot1.png", width = 480, height = 480)
dev.off()