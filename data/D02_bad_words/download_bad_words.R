# Download the [List of Dirty, Naughty, Obscene, and Otherwise Bad Words](https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/blob/master/README.md)
# provided by [Shutterstock](http://www.shuttertock.com) in a GitHub repository.

## ---- download_bad_words ----

pacman::p_load(here)

download.file("https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en",
              here("data/D02_bad_words/bad_words.txt"))

