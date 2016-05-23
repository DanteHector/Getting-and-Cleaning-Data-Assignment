#library in order to use melt
library(reshape2)

# Download the zip file from the URL
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="filename.zip", method="curl")

# Unzip the file
unzip("filename.zip")

# Load the activities lables and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Identify all the mean and std measures
measuresWanted <- grep(".*mean|.*std.*",features[,2])
measuresWanted.name <- features[measuresWanted,2]

# Load datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[measuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[measuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge test and training data
allData <- rbind(train,test)
colnames(allData) <- c("subject", "activity", measuresWanted.name)

# turn data into factors
allData$activity <- factor(allData$activity, levels= activity_labels[,1], labels=activity_labels[,2])
allData$subject <- as.factor(allData$subject)
allData.melted <- melt(allData, id=c("subject","activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names=FALSE, quote=FALSE)