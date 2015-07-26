library(dplyr)
# Get all data
features <- read.table("UCI HAR Dataset/features.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge Data
data_train <- tbl_df(X_train)
data_train <- cbind(subject_train,Y_train,data_train)
data_test <- tbl_df(X_test)
data_test <- cbind(subject_test,Y_test,data_test)
data_f <- rbind(data_train,data_test)
rm(X_train,Y_train,subject_train,X_test,Y_test,subject_test,data_test,data_train)

# Find which features contain mean() and std()
index_mean <-grep(".mean",as.character(features[,2]))+2
index_std <- grep(".std.",as.character(features[,2]))+2
index_f <- c(index_mean,index_std)

# extract needed columns and rename them
for (i in 1:length(index_f)) {
        if (i == 1) {
                data_f2 <- cbind(data_f[,1:2],data_f[,index_f[i]])
                
        } else {
                data_f2 <- cbind(data_f2,data_f[,index_f[i]])
        }
        names(data_f2)[2+i] <- as.character(features[index_f[i]-2,2])
}
names(data_f2)[1:2] <- c("subject","label")
names(data_f2) <- sub("*-meanFreq..","MeanFreq",names(data_f2))
names(data_f2) <- sub("*MeanFreq.","MeanFreq",names(data_f2))
names(data_f2) <- sub("*-mean..","Mean",names(data_f2))
names(data_f2) <- sub("-","",names(data_f2))
names(data_f2) <- sub("*-std..","Std",names(data_f2))
names(data_f2) <- sub("-","",names(data_f2))

# replace activity labels
data_f2[,2] <- sub(1,"WALKING",data_f2[,2])
data_f2[,2] <- sub(2,"WALKING_UPSTAIRS",data_f2[,2])
data_f2[,2] <- sub(3,"WALKING_DOWNSTAIRS",data_f2[,2])
data_f2[,2] <- sub(4,"SITTING",data_f2[,2])
data_f2[,2] <- sub(5,"STANDING",data_f2[,2])
data_f2[,2] <- sub(6,"LAYING",data_f2[,2])

# create a new dataset
data_f3 <- arrange(data_f2,subject,label)
for (i in 3:81) {
        x <- tapply(data_f3[,i],list(data_f3[,1],data_f3[,2]),mean)
        dim(x) <- c(180,1)
        if (i == 3) {
                data_f4 <- cbind(rep(1:30,6),c(rep("LAYING",30),rep("SITTING",30),rep("STANDING",30),rep("WALKING",30),rep("WALKING_DOWNSTAIRS",30),rep("WALKING_UPSTAIRS",30)),x)
        } else {
                data_f4 <- cbind(data_f4,x)
        }
}
data_f5 <- tbl_df(data.frame(data_f4))
names(data_f5) <- names(data_f2)
data_f6 <- arrange(data_f5,subject,label)
write.table(data_f6, file = "outcome.txt", row.name = FALSE)