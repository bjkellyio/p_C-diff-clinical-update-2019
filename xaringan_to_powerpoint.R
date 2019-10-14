#' ############################
#' load libraries and set seed
#' ############################
library(tidyverse)
library(pagedown)
library(pdftools)
library(glue)
library(rmarkdown)




#' ############################
#' convert HTML slides to PPTX slides
#' see:
#' 
#' https://github.com/gadenbuie/xaringan2powerpoint
#' 
#' ############################



#slides_html <- "slides.html"

# "print" HTML to PDF
#pagedown::chrome_print(input = "slides.html", output = "slides.pdf")

# how many pages?
pages <- pdftools::pdf_info("slides.pdf")$pages

# set filenames
filenames <- sprintf("slides/slides_%02d.png", 1:pages)

# create slides/ and convert PDF to PNG files
dir.create("slides")
pdftools::pdf_convert("slides.pdf", filenames = filenames, dpi = 480)

# Template for markdown containing slide images
slide_images <- glue::glue("
---

![]({filenames}){{width=100%}}

")
slide_images <- paste(slide_images, collapse = "\n")


# R Markdown -> powerpoint presentation source
md <- glue::glue("
---
output: 
  powerpoint_presentation:
    reference_doc: blankslide16-9.pptx
---

{slide_images}
")

cat(md, file = "slides_powerpoint.rmd")

# Render Rmd to powerpoint
rmarkdown::render("slides_powerpoint.rmd")  ## powerpoint!