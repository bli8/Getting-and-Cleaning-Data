library(dplyr)
library(data.table)
library(tidyr)

feature <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/features.txt")
activity <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/activity_labels.txt")

xtrain <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/train/X_train.txt",header=FALSE)
ytrain <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/train/Y_train.txt",header=FALSE)
sub_train <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/train/subject_train.txt",header=FALSE)

xtest <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/test/X_test.txt",header=FALSE)
ytest <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/test/Y_test.txt",header=FALSE)
sub_test <- read.table("C:/Users/lbw92/Desktop/UCI HAR Dataset/test/subject_test.txt",header=FALSE)

#part 1
xdata <- rbind(xtrain,xtest)
dim(xdata)
ydata <- rbind(ytrain,ytest)
dim(ydata)
subdata <- rbind(sub_train,sub_test)
dim(subdata)

#part 2
mean.sd <- grep("mean\\(\\)|std\\(\\)",feature[,2])
length(mean.sd)

xmean.sd <- xdata[,mean.sd]
dim(xmean.sd)

#part 3
names(xmean.sd) <- feature[mean.sd,2]
names(xmean.sd) <- tolower(names(xmean.sd))
names(xmean.sd) <- gsub("\\(|\\)","",names(xmean.sd))

activity[,2] <- tolower(as.character(activity[,2]))
activity[,2] <- gsub("_","",activity[,2])

ydata[,1] = activity[ydata[,1],2]
colnames(ydata) <- "activity"
colnames(subdata) <- "subject"

#part 4 
merged <- cbind(subdata,ydata,xmean.sd)
head(merged[,c(1:4)])

#part 5
datanew <- aggregate(merged[,3:68],by=list(subject=merged$subject,
                                        activity=merged$activity),mean)
write.table(data,file="data_tidy.txt",row.name=FALSE)