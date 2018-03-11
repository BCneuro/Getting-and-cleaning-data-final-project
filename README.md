# Tidy Summary README
Becky Carlyle  
March 11th 2018  

## Project Description
The aim of this project was to take a collection of poorly organised data from a study of human movement ("Human Activity Recognition Using Smartphones Dataset, Reyes-Ortix et al.,"), and produce a summary table of a subset of the data that conformed to tidy data principles.  While the full code (along with commented sanity checks) can also be found in the Github Repo, the appropriate sections are provided in this readme for easy analysis.  This code should work as long as the files downloaded from Samsung (link below) are in your working directory.

##Study design and data processing
The data was collected by a Samsung Galaxy SII smartphone using the accelerometer and gyroscope.  A group of 30 volunteers were asked to perform 6 different activities, while data was collected about acceleration and velocity in the x,y,z directions.  

###Collection of the raw data
Data was collected about acceleration and velocity in the x,y,z planes.  Data was preprocessed, filtered, transformed and placed into data tables. These data tables can be downloaded from here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

###Notes on the original (raw) data 
The original data is found in three separate files each for both the training and test sets, which must be combined.  For each of these data sets, the subject_txt file provides the identifier for the subject performing the movement.  The y_ file provides the identifiers for each activity they are performing.  The x_ file provides the values of the measurement described.


```r
# Part 1 - read in the files and merge to create one data set

#read in files
subject_test <- read.table("test/subject_test.txt", header=FALSE, sep = "" )
y_test <- read.table("test/y_test.txt", header = FALSE, sep = "")
x_test <- read.table("test/X_test.txt", header = FALSE, sep = "")
# read in feature names too
features <- read.table("features.txt", header = FALSE, sep = "")
#apply feature names to columns of x_
colnames(x_test) <- features$V2

subject_train <- read.table("train/subject_train.txt", header=FALSE, sep = "" )
y_train <- read.table("train/y_train.txt", header = FALSE, sep = "")
x_train <- read.table("train/X_train.txt", header = FALSE, sep = "")
colnames(x_train) <- features$V2

# to combine data need to combine all three test files and all three train files first
df_train <- data.frame(subject=subject_train[,1], y=y_train[,1], x_train)

df_test <- data.frame(subject=subject_test[,1], y=y_test[,1], x_test)

#then create one large table using rbind
df_data <- rbind(df_train,df_test)
```


##Creating the tidy datafile
When creating the tidy datafile, all six of these separate files must be combined.  


```r
# to combine data need to combine all three test files and all three train files first
df_train <- data.frame(subject=subject_train[,1], y=y_train[,1], x_train)

df_test <- data.frame(subject=subject_test[,1], y=y_test[,1], x_test)

#then create one large table using rbind
df_data <- rbind(df_train,df_test)
```


This project requests only the values for mean and standard deviation should be kept.  The fact that we have already added the verbose column names makes this part easier.  I made the decision to only include the columns that had both a mean and a std. value for that feature - this meant using a character search for just the mean and stds found before a .. . 


```r
mean_sd <- c(grep("mean..", colnames(df_data), fixed=T), grep("std..", colnames(df_data), fixed=T))
col_keep <- c(1,2,mean_sd)
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.4.1
```

```r
df_ms <- select(df_data, col_keep)
```


Following filtering so that only these columns where retained, you can switch out the numbered activity code for a verbose description (eg. "walking"),  and tidy up some of the column names, getting rid of extra punctuation and clarifying "time" and "Frequency".  


```r
#First need to rename the y column "activity"
df_ms <- rename(df_ms, activity=y)

#Now change the activity number codes to verbose
key <- read.table("activity_labels.txt", header=FALSE, sep = "" )

df_ms$activity = key$V2[match(df_ms$activity, key$V1)]

#Appropriately labels the data set with descriptive variable names.
newColnames = gsub("...",".",colnames(df_ms), fixed=T)
newColnames = gsub("..","",newColnames, fixed=T)
newColnames = gsub("^t","time.",newColnames)
newColnames = gsub("^f","freq.",newColnames)
colnames(df_ms) = newColnames
```


To calculate the means of each column for each subject and activity, I used the summary function grouped by subject and activity.  This produced a wide format tidy table.  


```r
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summary.data <- df_ms %>%
  group_by(subject,activity) %>%
  summarise_all(funs(mean))

#Finally, rename the table to something more obvious and write the table
Tidy.summary <- summary.data

write.table(Tidy.summary, file = "Tidy.summary.txt", sep="\t",  col.names = T)
```


##Description of the variables in the tiny_data.txt file
The Tidy.summary.txt file has 180 variable columns and 68 observations.  See the codebook for detailed descriptions.
