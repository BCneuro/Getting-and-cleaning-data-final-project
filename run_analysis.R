# Part 1 - read in the files and merge to create one data set
#read in files
subject_test <- read.table("test/subject_test.txt", header=FALSE, sep = "" )
#head(subject_test)
y_test <- read.table("test/y_test.txt", header = FALSE, sep = "")
#head(y_test)
x_test <- read.table("test/X_test.txt", header = FALSE, sep = "")
#head(x_test)
features <- read.table("features.txt", header = FALSE, sep = "")
#head(features)
colnames(x_test) <- features$V2
#head(x_test)

subject_train <- read.table("train/subject_train.txt", header=FALSE, sep = "" )
#head(subject_train)
y_train <- read.table("train/y_train.txt", header = FALSE, sep = "")
#head(y_train)
x_train <- read.table("train/X_train.txt", header = FALSE, sep = "")
#head(x_train)
colnames(x_train) <- features$V2

# to combine data need to combine all three test files and all three train files first
df_train <- data.frame(subject=subject_train[,1], y=y_train[,1], x_train)
#head(df_train)

df_test <- data.frame(subject=subject_test[,1], y=y_test[,1], x_test)
#head(df_test)

#then create one large table using rbind
df_data <- rbind(df_train,df_test)

#Part 2
#Extract only the measurements on the mean and standard deviation for each measurement. 

mean_sd <- c(grep("mean..", colnames(df_data), fixed=T), grep("std..", colnames(df_data), fixed=T))
col_keep <- c(1,2,mean_sd)
library(dplyr)
df_ms <- select(df_data, col_keep)
colnames(df_ms)
#looks good!

#Part 3
#Use descriptive activity names to name the activities in the data set
#First need to rename the y column "activity"
df_ms <- rename(df_ms, activity=y)

#Now change the activity number codes to verbose
key <- read.table("/Users/beckycarlyle/Dropbox/Coursera/Data Science/Module 3_Getting_cleaning_data/Final project/UCI HAR Dataset/activity_labels.txt", header=FALSE, sep = "" )
#key

df_ms$activity = key$V2[match(df_ms$activity, key$V1)]
#head(df_ms)

#Part 4
#Appropriately labels the data set with descriptive variable names.
newColnames = gsub("...",".",colnames(df_ms), fixed=T)
newColnames = gsub("..","",newColnames, fixed=T)
newColnames = gsub("^t","time.",newColnames)
newColnames = gsub("^f","freq.",newColnames)
newColnames
colnames(df_ms) = newColnames

#Part 5
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summary.data <- df_ms %>%
  group_by(subject,activity) %>%
  summarise_all(funs(mean))

#head(summary.data)

#Finally, rename the table to something more obvious and write the table
Tidy.summary <- summary.data
#head(Tidy.summary)

write.table(Tidy.summary, file = "Tidy.summary.txt", sep="\t",  col.names = T, row.name=FALSE)
