

# tRciks - data_management - audio files

# -----------------------------------------------------------------------
# Obtain audio files duration with R. Useful for huge number of audio files

# GitHub: @jmenblaz

#--------------------------------------------------------------------------


# install.packages(soundgen)
# install.pacjages(doParallel)

library(soundgen)   # A usefull packgae for use and manage audio files (CRAN)
library(doParallel)

# 0. folder with contain the audio files --------------------------------------
# (or sub-directories with these files) 
# folder 
f <- "C:/path/"

format <- ".WAV"


# list all audio files to process
audio_files <- list.files(f, pattern = format, recursive = TRUE, full.names = TRUE)


# 1. process ------------------------------------------------------------------
# number of files to proces
num_files <- length(audio_files)

# extract number of cores
cores = detectCores()
# get audio files duration
files_info <- getDuration(audio_files, cores = (cores-2)) # duration in sec

# result
recording_sec <- sum(files_info$duration) 
recording_min <- recording_sec/60
recording_hours <- recording_min/60

cat("Total duration of audio files is:", recording_hours, "h\n")
cat("Number of files processed:", num_files, "\n")
