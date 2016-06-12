# Scrapes the top 100 artists from billboard.com
scrapeTop50Artists <- function() {
  require('rvest')
  top_artists <- read_html('http://www.billboard.com/charts/artist-100') %>%
    html_nodes('article > div.chart-row__primary > div.chart-row__main-display > div.chart-row__container > div > h2')%>%
    html_text()
  return(top_artists[1:3])
}

