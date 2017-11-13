
#####download data#####
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp, mode = "wb")
unzip(temp)


#####read in and merge data#####
#read in column names
setwd("UCI HAR Dataset")
features <- read.table("features.txt", colClasses = "character")
columnLabels <- features[,2]
#read in test data to dataframe, bind subject labes and activity classification columns
testSubject <- read.table("test/subject_test.txt")
testData <- read.table("test/X_test.txt", col.names = columnLabels)
testActivity <- read.table("test/y_test.txt")
testData <- cbind(testSubject, testActivity, testData )
names(testData)[1:2] <- c("subject", "activity")
#read in train data to dataframe, bind subject labels and activity classification columns
trainSubject <- read.table("train/subject_train.txt")
trainData <- read.table("train/X_train.txt", col.names = columnLabels)
trainActivity <- read.table("train/Y_train.txt")
trainData <- cbind(trainSubject, trainActivity, trainData)
names(trainData)[1:2] <- c("subject", "activity")
#merge test and train data
mergedData <- rbind(testData, trainData)


#####Extract Mean and St Dev#####
columnIndex <- grep('mean\\.|std\\.', names(mergedData))
mergedData <- mergedData[,c(1, 2, columnIndex)]

#####Relabel Activities as Descriptive Factors#####
#change activity column to character vector to prepare for substitution
mergedData$activity <- as.character(mergedData$activity)
#read in activity labels
labels <- read.table('activity_labels.txt', colClasses = "character")
names(labels) <- c("number", "name")
for(i in 1:6){
        mergedData$activity <- sub(labels$number[i], labels$name[i], mergedData$activity)
        
}
mergedData$activity <- as.factor(mergedData$activity)

#####Name variables descriptively#####
newNames <- names(mergedData)
newNames <- sub("mean", "Mean", newNames)
newNames <- sub("std", "StandardDeviation", newNames)
newNames <- sub("Mag", "Magnitude", newNames)
newNames <- sub("Acc","Accelerometer", newNames)
newNames <- sub("gyro", "Gyroscope", newNames)
newNames <- sub("^f", "frequency", newNames)
newNames <- sub("^t", "time", newNames)
newNames <- gsub("\\.", "", newNames)
names(mergedData) <- newNames

#####Create Tidy Dataset#####
library(reshape2)
dataMelt <- melt(mergedData, id = c("subject", "activity"), measure.vars = names(mergedData)[3:68])
bySubject <- dcast(dataMelt, subject ~ variable, mean)
byActivity <- dcast(dataMelt, activity ~ variable, mean)
write.csv(bySubject, "meanBySubject.csv")
write.csv(byActivity, "meanByActivity.csv")