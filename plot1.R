# plot1.R
# In Git Bash,
# $ head household_power_consumption.txt >> tst.txt
# gives 1 line of column names and 9 lines of data
# 1 column of date
# 1 column with time
# 7 columns of numerics (8 bytes/numeric)
# $ wc household_power_consumption.txt
# retrieves :
# 2075260 2075260 132960755 household_power_consumption.txt
# so 2075259 rows of data
# estimated memory size to store dataframe :
#   2075259 * 9 * 8 bytes/numeric
# = 149418648 bytes
# = 149418648 / 2^20 bytes/MB
# = 142.50 MB
if (!require("sqldf")) {
  install.packages("sqldf")
}
require("sqldf")

colClassetxt <- c(rep("character",9))
file <- "household_power_consumption.txt"

# Getting data from '1/2/2007' and'2/2/2007'
Elecpowerconsump <- read.csv.sql(file, sql = "select * from file where Date in ('1/2/2007','2/2/2007')",
                                 header=T, sep=";",row.names=NULL, nrows=2075259, colClasses=colClassetxt, stringsAsFactors=F, drv="SQLite")
closeAllConnections()

# Marking NAs 
Elecpowerconsump[Elecpowerconsump=="?"]<-NA

# Conversion of dates
datetime <- paste(as.Date(Elecpowerconsump$Date,"%d/%m/%Y"), Elecpowerconsump$Time)
Elecpowerconsump$Datetime <- as.POSIXct(datetime,tz = "")

# Conversion of Global_active_power
GlobalActivePower <- as.numeric(Elecpowerconsump$Global_active_power)

# plot1
png("plot1.png", width=480, height=480)
hist(GlobalActivePower, main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")
dev.off()