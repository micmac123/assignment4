##Download the file

    if(!file.exists("./data")){dir.create("./data")}
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
    
    unzip(zipfile="./data/Dataset.zip",exdir="./data")
    path_ref <- file.path("./data" , "UCI HAR Dataset")
    files<-list.files(path_ref, recursive=TRUE)
    
##Read the Files
    
    dataActTest  <- read.table(file.path(path_ref, "test" , "Y_test.txt" ),header = FALSE)
    dataActTrain <- read.table(file.path(path_ref, "train", "Y_train.txt"),header = FALSE)

    dataSubjTrain <- read.table(file.path(path_ref, "train", "subject_train.txt"),header = FALSE)
    dataSubjTest  <- read.table(file.path(path_ref, "test" , "subject_test.txt"),header = FALSE)

    dataFeatTest  <- read.table(file.path(path_ref, "test" , "X_test.txt" ),header = FALSE)
    dataFeatTrain <- read.table(file.path(path_ref, "train", "X_train.txt"),header = FALSE)
    
##Merges the training and the test sets
    
    dataSub <- rbind(dataSubjTrain, dataSubjTest)
    dataAct<- rbind(dataActTrain, dataActTest)
    dataFeat<- rbind(dataFeatTrain, dataFeatTest)
    
##Set Variable Names  
    
    names(dataSubj)<-c("subject")
    names(dataAct)<- c("activity")
    dataFeatNames <- read.table(file.path(path_ref, "features.txt"),head=FALSE)
    names(dataFeat)<- dataFeatNames$V2  

## Merge Columns
    
    dataCombine <- cbind(dataSubject, dataActivity)
    Data <- cbind(dataFeatures, dataCombine)
    
##Extract measures

    subdataFeatNames<-dataFeatNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeatNames$V2)]
    selectedNames<-c(as.character(subdataFeatNames), "subject", "activity" )
    Data<-subset(Data,select=selectedNames)

   
##Name the activities
        
    activityLabels <- read.table(file.path(path_ref, "activity_labels.txt"),header = FALSE)
    names(Data)<-gsub("^t", "time", names(Data))
    names(Data)<-gsub("^f", "frequency", names(Data))
    names(Data)<-gsub("Acc", "Accelerometer", names(Data))
    names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
    names(Data)<-gsub("Mag", "Magnitude", names(Data))
    names(Data)<-gsub("BodyBody", "Body", names(Data))
    
##Create second data set
    
    library(plyr);
    Data2<-aggregate(. ~subject + activity, Data, mean)
    Data2<-Data2[order(Data2$subject,Data2$activity),]
    write.table(Data2, file = "tidydata.txt",row.name=FALSE)
    
    
    