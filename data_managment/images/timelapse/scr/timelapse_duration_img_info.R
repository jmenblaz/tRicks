

# tRciks - data_management - images files - timelapses

# -----------------------------------------------------------------------
# script for counting number of images processed in a timelapses
# calculate the time in which the timelapse was taken

# GitHub: @jmenblaz
# MIT license 
#--------------------------------------------------------------------------



# Install exifr package from CRAN
# install.packages("exifr")
library(exifr)





# folder which contains timelapses images
path <- "C:/Users/J. Menéndez Blázquez/SML_Dropbox/SML Dropbox/data/campaign/240823-CABRERA/instrument/gopro"
format <- "JPG" 

# list folders
f <- list.dirs(path)

# list folder on timelapse in its paths
f <- grep("TimeLapse", f, value = TRUE)


# for timelapses folders
for (t in 1:length(f)) {

  Sys.setenv(LANG = "C") # remove warinings messages
      
  tmlp <- f[t]
  id_tmlp <- basename(tmlp)
  
  images <- list.files(tmlp, pattern = "JPG", full.names = TRUE)
  
  # read metadata of each picture
  imgs_meta <- read_exif(images)
  # extrac information
  num_img <- nrow(imgs_meta)
  
  # format date
  imgs_meta$CreateDate <- as.POSIXct(imgs_meta$CreateDate, format = "%Y:%m:%d %H:%M:%S", tz = "UTC")

  # Calculate time difference between capture (for exampl: 2 min in setting)
  time_diff <- c(0, difftime(imgs_meta$CreateDate[-1], imgs_meta$CreateDate[-nrow(imgs_meta)], units = "mins"))
  
  # identify sub timelapses by baterry changes (> 2 min time difference between capture time)
  group_id <- cumsum(time_diff > 2)
  imgs_meta$Group <- group_id
  
  # Process each sub timelapses
  subtimelapse_info <- lapply(split(imgs_meta, imgs_meta$Group), function(subset) {
    num_img_sub <- nrow(subset)
    duration_sub <- difftime(max(subset$CreateDate), min(subset$CreateDate), units = "mins")
    list(
      num_images = num_img_sub,
      duration = duration_sub
    )
  })
  
  # Imprimir la información para cada subtimelapse
  cat(id_tmlp, "- Total number of images: ", num_img, "\n")
  cat("Subtimelapse information:\n")
  
  for (i in seq_along(subtimelapse_info)) {
    cat(" - Subtimelapse", i, ":\n")
    cat("   Number of images:", subtimelapse_info[[i]]$num_images, "\n")
    cat("   Duration:", subtimelapse_info[[i]]$duration, "min \n")
  }
  cat("\n")

}

