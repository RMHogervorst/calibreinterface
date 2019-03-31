###

result <- system(command = "calibre --version",intern = TRUE)

library(DBI)
library(RSQLite)
library(dplyr)
library(dbplyr)
con <- dbConnect(RSQLite::SQLite(), "~/Calibre Library-all/metadata.db")
result <- DBI::dbGetQuery(con,
                 "SELECT id, title,
               (SELECT name FROM books_authors_link AS bal JOIN authors ON(author = authors.id) WHERE book = books.id) authors,
               (SELECT name FROM publishers WHERE publishers.id IN (SELECT publisher from books_publishers_link WHERE book=books.id)) publisher,
               (SELECT rating FROM ratings WHERE ratings.id IN (SELECT rating from books_ratings_link WHERE book=books.id)) rating,
               (SELECT MAX(uncompressed_size) FROM data WHERE book=books.id) size,
               (SELECT name FROM tags WHERE tags.id IN (SELECT tag from books_tags_link WHERE book=books.id)) tags,
               (SELECT format FROM data WHERE data.book=books.id) formats,
               isbn,
               path,
               pubdate
        FROM books")

authors <- tbl(con, "authors")
authors %>% head()
books <- tbl(con, "books")
series <- tbl(con, "series")
ratings <- tbl(con, "ratings")
sqlite_stat1 <- tbl(con,"sqlite_stat1")
sqlite_sequence <- tbl(con, "sqlite_sequence")
tags <- tbl(con, "tags")
# mostly need books and authors


# linking tables
tbl(con, "books_authors_link") # id, book, author
#books_custom_column_1_link (many of this one)
tbl(con,"books_plugin_data") # empty
tbl(con, "comments") # gelinkt aan book., this is what is description of book
tbl(con, "meta") # doesn't work
tbl(con, "feeds") # emtpy (because I don't have feeds)
tbl(con, "data") # has book names, pdf
tbl(con, "identifiers") # DOI or isbn,e tc. # book, id
## tst, book 250, has isbn 9780199545988The Pursuit of Unhappiness: The Elusive Psychology of Well-Being, works in book.
library_id
preferences
