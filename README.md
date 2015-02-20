##This file explains how files in this repo are related and how run_analysis.R produces tidy data

##This repo contains 
* run_analysis.R script which operates on UCI HAR Dataset to obtain a new file embracing average of values 
in the fields mean and standard deviation
* A code book named CodeBook.md which describes names of the fields of the output data along with summary choices



##To run run_analysis.R
* UCI HAR Dataset should be present on your computer 
* R should be installed on your computer
* Please use read.table("tidyData.txt",header = T) to read the output file 
   (which has been  saved in UCI HAR Dataset directory by run_analysis)
* Please refer CodeBook.md for details about names of fields in the output file

## run_analysis.R  does the following :
* Sets working directory to the UCI HAR Dataset directory



* Gathers feature vectors from both train and test files and combines them itno variable x


* Obtains names of features from features.txt


* Trims x to contain only those columns whose name
ends in either -mean() or -std()



* Collect labels i.e. names corresponding to y-values or classes from the working directory


* Combines numbers denoting classes or activity labels  from train and test directories into a variable y.


* Trims labels to only retain activity labels and not numbers

* Replaces y-values with corresponding activity labels

* Obtains a vector of subjects for which the dataset was prepared(by combining subject ids for
 both training and test set)


* Binds x, activity labels and subjects to create a coherent data set



* Creates independent tidy data set with the average of each
 variable for each activity and each subject.

* Assigns acceptable and descriptive names to fields of the tidy data set by resolving issues like
	
	 removing -, (, ), space, redundant numbers which  invalidate variable  names in R and encumber extraction of columns

	 assuring compliance to CamelCase notation

* Writes this so created tidy data set to a file "tidyData.txt" in UCI HAR Dataset directory
 (which would also be the current directory)

##The dataset so produced has the following attributes:
* One variable per column
* One observation per row
* No NA or NULL values

and can therefore be considered as tidy data.
