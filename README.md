# GettingNCleaningData
1. The Script:
1.1 Use "read.table" to read features.txt, X_train.txt, Y_train.txt, subject_train.txt, X_test.txt, Y_test.txt, and subject_test.txt
1.2 Use "cbind" to merge the above data and link subject to variables
1.3 Use "grep" to find the features containing "mean" and "std"
1.4 Use a loop for "cbind" to extract the needed data
1.5 Use "sub" to rename variables and replace activity labels
1.6 Use a loop for "tapply" to create the needed data
1.7 make some adjustments and export "outcome.txt"

2. Code book:
2.1 "subject" means the code for 30 volunteers
2.2 "labels" means the 6 kinds of activity names
2.3 other 81 variables is extracted from the 581 features (Please check features.txt) , their name are containing "mean" or "std". Please check features_info.txt for more information