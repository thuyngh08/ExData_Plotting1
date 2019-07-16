### Peer-graded Assignment: Plot 4 ###

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

# Plotting 4 graphs on 1 plot
par(mar = c(4,4,1,2), mfrow = c(2, 2))
str(hh_power_consumption)

with(hh_power_consumption, {
        plot(Global_active_power ~ timestamp, type = "l", xlab = "", ylab = "Global Active Power")
        plot(Voltage ~ timestamp, type = "l", xlab = "datetime", ylab = "Voltage")
        plot(Sub_metering_1 ~ timestamp, type = "l", xlab="",ylab="Energy sub metering")
        lines(Sub_metering_2 ~ timestamp, col = "red")
        lines(Sub_metering_3 ~ timestamp, col = "blue")
        legend("topright", col = c("black", "red", "blue"), 
               c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
               lty = c(1,1), text.width = strwidth("Sub_metering_1")*1.1, bty = "n") 
        plot(Global_reactive_power ~ timestamp, type = "l", xlab = "datetime", ylab = "Global Reactive Power")
})

dev.copy(png, file = "./ExData_Plotting1/plot4.png", width = 480, height = 480)
dev.off()

