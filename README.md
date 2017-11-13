# Download Data

This part of the script creates a temp file to store the downloaded zip file and then unzips it.  
This is only necessary if you don't already have the data

# Read in and merge data

First, the working directory is set.  Then features.txt is read in and the column names are extracted into columnLabels.
Then, test subject ids, data, and activities are read in from subject_test.txt, x_test.txt and y_test.txt respectively.
columnLabels is given as an argument to name testData's columns.
The columns are bound together subject first, then activity, then the rest of the data.
The subject and activity columns are named for readability.
This process is then repeated for the training data, subject ids, and activities.  The resulting frames are merged.

# Extract Mean and St Dev

Grep obtains the name indices containing either 'mean' followed by a period or 'std' followed by a period.
mean() and std() denoted mean and standard deviation measurements in features.txt, but special characters were read in as periods.
These indices (along with 1 and 2 for the subject and activity columns) are used to subset the data.
mergedData now contains subject, activity, and a large number of mean and standard deviation variables.

# Relabel Activities as Descriptive Factors

The activity column is coerced into a character vector for easier substitution.
activity_labels.txt is read into a data frame.  Both columns are stored as a character vector.
A for loop is used to replace numeric strings in the activity column with respective label strings.
The variable is then coerced into a factor.

# Name variables descriptively

A series of subsitutions are performed on the variable names.  
Periods are removed, abbreviations are written out in full, and case adjustments are performed to obtain camel case.
There are no periods, underscores, or whitespace in the resulting names.  Every name component (besides X, Y or Z) is a full word.

# Create Tidy Dataset

The reshape2 package is used to get the data into the desired tidy form.
First, the data is melted using subject and activity as id, and everything else as measured variables.
The mean is then taken for each variable grouped by subject and stored in bySubject.  The same is done for activity in byActivity.
bySubject and byActivity are then written to csv files.  They are stored in separate tables (and thus separate files) because it would be awkard to merge them.


