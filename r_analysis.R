filename <- "getdata_dataset.zip"
unzip(filename)

activity <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

colnames(activity) <- c("activity_id", "activity")
colnames(subject_train) <- "subject_id"
colnames(x_train) <- features[,2]
colnames(y_train) <- "activity_id"

training_data <- cbind(subject_train, x_train, y_train)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

colnames(subject_test) <- "subject_id"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activity_id"

test_data <- cbind(subject_test, x_test, y_test)

combined_data <- rbind(training_data, test_data)

labels <- colnames(combined_data)

mean_std <- (grepl("activity_id", labels) | grepl("subject_id", labels) | grepl("-mean..", labels) | grepl("-std..", labels) & !grepl("-meanFreq..", labels) & !grepl("mean..-", labels) & !grepl("std..-",labels))

combined_data <- combined_data[mean_std == TRUE]

combined_data <- merge(combined_data, activity, by = "activity_id", all.x = TRUE)

labels <- colnames(combined_data)

names(combined_data) <- gsub('Acc',"Acceleration",names(combined_data))
names(combined_data) <- gsub('GyroJerk',"GyroAcceleration",names(combined_data))
names(combined_data) <- gsub('Gyro',"Speed",names(combined_data))
names(combined_data) <- gsub('Mag',"Magnitude",names(combined_data))
names(combined_data) <- gsub('^t',"Time.",names(combined_data))
names(combined_data) <- gsub('^f',"FrequencyN.",names(combined_data))
names(combined_data) <- gsub('\\.mean',".Mean",names(combined_data))
names(combined_data) <- gsub('\\.std',".SD",names(combined_data))
names(combined_data) <- gsub('Freq\\.',"Frequency.",names(combined_data))
names(combined_data) <- gsub('Freq$',"Frequency",names(combined_data))

labels <- colnames(combined_data)

tidy_data2 <- ddply(combined_data, c("subject_id","activity"), numcolwise(mean))
write.table(tidy_data2, file = "tidy_data2.txt")