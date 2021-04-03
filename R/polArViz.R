#' \code{polArViz} package
#'
#' Caja de Herramientas para visualizar el universo `polAr`
#' See the README on
#' \href{https://github.com/politicaargentina/polArViz/blob/master/README.md}{Github}
#'
#' @docType package
#' @name polArViz
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines

if(getRversion() >= "2.15.1")  utils::globalVariables(
  c(".",
    "category",
    "coddept",
    "datos",
    "coddepto",
    "codprov",
    "colour",
    "depto",
    "electores",
    "grillas_geofacet",
    "group",
    "lista",
    "listas",
    "listas_fct",
    "n",
    "name_prov",
    "nombre_lista",
    "party_long",
    "party_short",
    "pct",
    "seats",
    "seccion",
    "secciones_pba",
    "totales",
    "votos",
    "word",
    "x",
    "y",
    "year"))
