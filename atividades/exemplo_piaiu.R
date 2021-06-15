library(magrittr)
"https://piaui.folha.uol.com.br/lupa/2020/12/" %>% 
  rvest::read_html() %>%
  rvest::html_nodes("h2") %>% 
  rvest::html_text()
