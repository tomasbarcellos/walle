links <- c("https://br.financas.yahoo.com/industries/Energia-Petroleo-Gas",
           "https://br.financas.yahoo.com/industries/Industria-Financeira",
           "https://br.financas.yahoo.com/industries/Saude-Farmaceutica",
           "https://br.financas.yahoo.com/industries/Telecomunicacoes-Tecnologia",
           "https://br.financas.yahoo.com/industries/Industria-Alimenticia",
           "https://br.financas.yahoo.com/industries/Industria-Manufatureira",
           "https://br.financas.yahoo.com/industries/Servicos-diversos",
           "https://br.financas.yahoo.com/industries/Varejo",
           "https://br.financas.yahoo.com/industries/Construcao-Equipamentos",
           "https://br.financas.yahoo.com/industries/Bens-de-consumo",
           "https://br.financas.yahoo.com/industries/Industrias-em-geral")

pegar_lista_acoes <- function(link) {
  link %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    magrittr::extract2(1)
}

acoes_yahoo <- links %>%
  map_df(pegar_lista_acoes)

usethis::use_data(acoes_yahoo)
