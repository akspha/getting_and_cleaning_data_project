#  run_analysis.R  

# The following program does the following :
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.

#Following program makes these assumptions :
#UCI HAR Dataset is present on your computer 
#R is installed on your computer

#The data set can be procured from 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Set working directory to the UCI HAR Dataset directory
#Change path to run this on your computer
setwd("C:\\Users\\Akshay Tanmay\\Documents\\UCI HAR Dataset")

#gather feature vectors from both train and test files
x <- rbind(read.table("train\\X_train.txt"),read.table("test\\X_test.txt"))

#obtain names of features from features.txt
f <- readLines("features.txt")

#trim collection of feature vectors to contain only those columns whose name
#end in either -mean() or -std()
x <- x[,grep("((mean|std)\\(\\))$",f)]

#The datasets have labels i.e. names corresponding to y-values or classes.Collect them from the working directory
labels <- readLines("activity_labels.txt")

#numbers denoting classes or activity labels are available in train and test directories.Join them
y <- append(readLines("train\\y_train.txt"),readLines("test\\y_test.txt"))

#trim labels to only retain atcivity labels and not numbers
splitLabels <- strsplit(labels," ")
for(i in seq_along(labels)){
  labels[i] <- splitLabels[[i]][2]
}

#replace y-values with corresponding activity labels
for(i in seq_along(y)){
  for(j in 1:length(labels)){
    if(y[i] == as.character(j)){
      y[i] <- labels[j]
    }
  }
}

#obtain a vector of subjects for which the dataset was prepared
subject <- append(readLines("train\\subject_train.txt"), readLines("test\\subject_test.txt"))

#combine feature vectors so that
#rows align with corresponding activity labels and subject IDs
data <- cbind(x,subject,y)


#Create independent tidy data set with the average of each
#variable for each activity and each subject.
adata <-aggregate(data, by=list(y,subject), FUN=mean, na.rm=TRUE)
adata <- adata[,1:(ncol(adata)-2)] #last two cols i.e y and sub now contain only NAs,  remove them.
#Corresponding true values appear now in first two coloumns(group1 and group2)

#Procuring descriptive/acceptable column names for the aggregated data....

#obtain names of features that contain mean() or std() at their end
col_names <- f[grep("((mean|std)\\(\\))$",f)]

#remove col numbers
col_names <- sub("[0-9]+ ", "", col_names)

#change -X to X
along_x <- grep("-X$",col_names)
col_names[along_x] <- sub("-X","X",col_names[along_x])

#change -Y to Y
along_y <- grep("-Y$",col_names)
col_names[along_y] <- sub("-Y","Y",col_names[along_y])

#change -Z to Z
along_z <- grep("-Z$",col_names)
col_names[along_z] <- sub("-Z","Z",col_names[along_z])


#RemoveT and F prefixes
T <- grep("^t",col_names)
col_names[T] <- sub("t","AvgTime",col_names[T])


F <- grep("^f",col_names)
col_names[F] <- sub("f","AvgFreq",col_names[F])



#change -mean() to Mean
m <- grep("-mean\\(\\)",col_names)
col_names[m] <- sub("-mean\\(\\)", "Mean",col_names[m])

#change -std() to Std
m <- grep("-std\\(\\)",col_names)
col_names[m] <- sub("-std\\(\\)", "Std",col_names[m])

#Since there are column names that contain BodyBody, instead of just Body,correct their names
m <- grep("BodyBody",col_names)
col_names[m] <- sub("BodyBody", "Body",col_names[m])

#Christen fields in aggregated data (adata) with the  procured col_names
names(adata)[1:2] <-  c("Activity","Subject")
names(adata)[3:ncol(adata)] <- col_names

#writing this data to a file in current directory
write.table(adata,"tidyData.txt",row.name = FALSE)

#How to read this data
#X <- read.table("tidyData.txt",header = T)
#Please refer CodeBook.md for details about names of fields