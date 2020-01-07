#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
padronizar_dados <- function(df) {
  nomes <- df %>%
    names() %>%
    stringr::str_extract("[A-Z][a-z]+$") %>%
    stringr::str_to_lower()

  df %>%
    tibble::as_tibble() %>%
    purrr::set_names(nomes) %>%
    dplyr::mutate(symbol = unique(stringr::str_extract(names(df), "^.+(?=\\.)")),
           date = zoo::index(df)) %>%
    dplyr::select(symbol, date, tidyr::everything())
}

#' Title
#'
#' @param codigos
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
pegar_acoes <- function(codigos, ...) {
  env <- new.env()

  quantmod::getSymbols(c(codigos, "^BVSP"), src="yahoo", env=env, ...)

  env %>%
    as.list() %>%
    purrr::map_df(padronizar_dados)
}

#' Title
#'
#' @param df
#' @param periodo
#'
#' @return
#' @export
#'
#' @examples
criar_Ra <- function(df, periodo = "monthly") {
  df %>%
    dplyr::group_by(symbol) %>%
    tidyquant::tq_transmute(select     = adjusted,
                 mutate_fun = periodReturn,
                 period     = periodo,
                 col_rename = "Ra")
}

#' Title
#'
#' @param df
#' @param periodo
#'
#' @return
#' @export
#'
#' @examples
criar_RaRb <- function(df, periodo = "monthly") {
  Ra <- df %>%
    dplyr::filter(symbol != "BVSP") %>%
    criar_Ra(periodo)

  Rb <- df %>%
    dplyr::filter(symbol == "BVSP") %>%
    criar_Ra(periodo) %>%
    dplyr::rename(Rb = Ra)

  dplyr::left_join(Ra, Rb[, -1], "date")
}

