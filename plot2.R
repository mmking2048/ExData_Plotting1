## Set up
# Load sqldf library
# Install it if user doesn't have library
if(!require(sqldf)){
    print("The sqldf package is needed to run this script.");
    print("It will be installed automatically for you.");
    print("Installing sqldf...");
            
    install.packages("sqldf");
        
    if (!require(sqldf)) {
        stop("Could not install sqldf");
    }
}

# Download file if necessary
if (!file.exists("household_power_consumption.txt")){
    print("Downloading data...");
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
    download.file(fileUrl, destfile = "household_power_consumption.zip", mode = "wb");
    unzip("household_power_consumption.zip");
    file.remove("household_power_consumption.zip");
    rm(fileUrl);
}

# Read table if power_consumption is not in the environment
if (!exists("power_consumption")) {
    print("Reading data...");

    power_consumption <<- read.csv.sql("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE,
        sql = "select * from file where Date == '1/2/2007' or Date == '2/2/2007'");
            
    # Close sqldf connections
    closeAllConnections();
        
    # Concatenate date and time columns
    power_consumption$DateTime <- paste(power_consumption$Date, power_consumption$Time)
    # Convert the DateTime column to (duh) datetimes
    power_consumption$DateTime <- strptime(power_consumption$DateTime, format = "%d/%m/%Y %H:%M:%S")
}

print("Drawing graph");

# Set the points to be invisible
par(pch = ".");

# Draw the background grid
par(mfrow = c(1, 1));

# Draw plot in window
plot(power_consumption$DateTime, power_consumption$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l");

# Copy the plot to plot2.R
dev.copy(png, "plot2.png");

# Close the connection
dev.off();

print("Graph has been saved to plot2.png.");