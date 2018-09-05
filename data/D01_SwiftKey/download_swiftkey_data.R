pacman::p_load(here)

dl_file <- here("data/D01_SwiftKey/Coursera-SwiftKey.zip")

if(!file.exists(dl_file)) {
   download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                 dl_file)
}

unzip(zipfile = dl_file, exdir = here("data/D01_SwiftKey/"))

