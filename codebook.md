---
title: "Tidy Summary codebook"
author: "Becky Carlyle"
date: "March 11th 2018"
output:
  html_document:
    keep_md: yes
---

## Project Description
The aim of this project was to take a collection of poorly organised data from a study of human movement ("Human Activity Recognition Using Smartphones Dataset, Reyes-Ortix et al.,"), and produce a summary table of a subset of the data that conformed to tidy data principles.  

##Study design and data processing
The data was collected by a Samsung Galaxy SII smartphone using the accelerometer and gyroscope.  A group of 30 volunteers were asked to perform 6 different activities, while data was collected about acceleration and velocity in the x,y,z directions.  

###Collection of the raw data
Data was collected about acceleration and velocity in the x,y,z planes.  Data was preprocessed, filtered, and placed into data tables. 

###Notes on the original (raw) data 
The original data is found in three separate files each for both the training and test sets, which must be combined.  For each of these data sets, the subject_ txt file provides the identifier for the subject performing the movement.  The y_ file provides the identifiers for each activity they are performing.  The x_ file provides the values of the measurement described.

##Creating the tidy datafile
When creating the tidy datafile, all six of these separate files must be combined.  This project requests only the values for mean and standard deviation should be kept.  First, I added the features as column names, to make filtering easier.  I made the decision to only include the columns that had both a mean and a std. value for that feature - this meant using a character search for just the mean and stds found before a .. .   Following filtering so that only these columns where retained, I then switched out the numbered activity code for a verbose description (eg. "walking"),  and tidied up some of the column names a bit.  To calculate the means of each column for each subject and activity, I used the summary function grouped by subject and activity.  This produced a wide format tidy table.  

###Guide to create the tidy data file
These notes can be used to understand the r script in this github repo
1) Download the data 
2) Read the data into table format
3) Combine the three tables from each data set (subject_, y_, x_)
4) Use rbind to combine the test and train data sets into one large table
5) Use grep and select to retain only the mean and std columns
6) Use match to replace the numeric activity codes with verbose codes
7) USe gsub to tidy up the variable names a bit
8) Use group_by and summarise.all to find the means of the means and standard deviations for each subject, activity and feature

##Description of the variables in the tiny_data.txt file
The Tidy.summary.txt file has 180 variable columns and 68 observations.

Variables names are:
- subject     
- activity     
- feature      
- Variables 4 to 180 describe the data gained from individual features of activity

###Variable 1: Subject
Subject is a integer between 1-30 that delineates which subject was performing the activity.  

###Variable 2: Activity
Activity is a categorical variable that describe the activity the subject is performing.  It can take 6 levels:
- Laying
- Sitting
- Standing
- Walking
- Walking Downstairs
- Walking Upstairs

###Variable 3: Feature
Variable three is a categorical variable that describes each feature of the data obtained.  There are 33 levels for this variable

###Variables 4 to 180
These are numerical variables indicating average values for each described feature.  The verbose names contain descriptive information for each of the features:

- the first part of the variable name indicates what kind of measurement is being taken.  Measurements are either of time, in seconds, in or frequency, measured in Hertz
- the second part of the variable name describes the type of data being measured.  These refer to accleration or gyroscopic data of different types.
- the third part of the variable name describes whether the summarised data is the mean of means (.mean), or mean of the standard deviation (.std)
- if applicable to this feature, the final component of the variable name describes the axial direction of the measurement in the x,y, or z plane.
