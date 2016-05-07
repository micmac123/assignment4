# Merge the training and test sets


    if(!file.exists("./data")){dir.create("./data")}
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/Dataset.zip")

    unzip(zipfile="./data/Dataset.zip",exdir="./data")
    path_ref <- file.path("./data" , "UCI HAR Dataset")
    files<-list.files(path_ref, recursive=TRUE)


    x_train <- read.table(file.path(path_ref, "train", "X_train.txt"),header = FALSE)
    y_train <- read.table(file.path(path_ref, "train", "Y_train.txt"),header = FALSE)
    subject_train <- read.table(file.path(path_ref, "train", "subject_train.txt"),header = FALSE)

    x_test <- read.table(file.path(path_ref, "test" , "X_test.txt" ),header = FALSE)
    y_test <- read.table(file.path(path_ref, "test" , "Y_test.txt" ),header = FALSE)
    subject_test <- read.table(file.path(path_ref, "test" , "subject_test.txt"),header = FALSE)

# create data set
    x_data <- rbind(x_train, x_test)
    y_data <- rbind(y_train, y_test)
    subject_data <- rbind(subject_train, subject_test)



# Extract measurements

    features <- read.table(file.path(path_ref, "features.txt"),head=FALSE)


    mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset
    x_data <- x_data[, mean_and_std_features]

# correct names
    names(x_data) <- features[mean_and_std_features, 2]


# Name Activities

    activities <- read.table(file.path(path_ref, "activity_labels.txt"),head=FALSE)

    y_data[, 1] <- activities[y_data[, 1], 2]

    names(y_data) <- "activity"


# Appropriately label

# correct name
    names(subject_data) <- "subject"

# bind all sets
    all_data <- cbind(x_data, y_data, subject_data)


# Create a second, independent tidy data set

    averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
    write.table(averages_data, "tidy.txt", row.name=FALSE)
