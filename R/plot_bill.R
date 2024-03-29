#' Visualizar resultado de una votación (Plot voto)
#'
#'@description
#' Función que grafica el resultado de una votación.
#'
#'@param id Parametro en el que se especifica el id del proyecto obtenido con \code{legislAr::show_available_bills}
#'
#' @examples
#'
#' polArViz::plot_bill(id = "244-DIPUTADOS")
#'
#' @seealso \code{\link[legislAr]{show_available_bills}}, \code{\link[legislAr]{get_bill_votes}}
#'
#' @export


plot_bill <- function(id = NULL){

  bill <-   legislAr::get_bill_votes(bill = id) %>%
    dplyr::mutate(id = id)

  chamber <- dplyr::case_when(stringr::str_detect(string = id, pattern = "DIP") ~ "diputados",
                              TRUE ~ "senadores")

  bill_metadata <- legislAr::show_available_bills(viewer = FALSE, chamber = chamber) %>%
    dplyr::filter(id == unique(bill$id))

  voto_count <-  bill %>%
    dplyr::count(voto)


  voto <- tibble::tibble(voto = c("AFIRMATIVO", "AUSENTE", "NEGATIVO",
                                  "PRESIDENTE", "ABSTENCION")) %>%
    dplyr::left_join(voto_count, by = "voto") %>%
    dplyr::mutate(n = ifelse(is.na(n), 0, n))


  bill_df <- data.frame(
    house = dplyr::case_when(
      dim(bill)[1] == 257 ~ "Diputados",
      dim(bill)[1] == 72 ~ "Senadores"),
    party_long = c(voto$voto[1],voto$voto[2], voto$voto[3], voto$voto[4], voto$voto[5]),
    party_short = c("afirmativo", "ausente", "negativo", "presidente", "abstencion"),
    seats = c(voto$n[1],voto$n[2], voto$n[3],  voto$n[4], voto$n[5])
  )

  bill_df <- bill_df %>%
    dplyr::mutate(party_long = paste0(party_long, " (",seats, ")"),
                  order = c(4,2,1, 3, 5),
                  colour = dplyr::case_when(
                    party_short == "afirmativo" ~ "#2E6B23",
                    party_short == "negativo" ~ "#D93C3C",
                    party_short == "ausente" ~ "#5C5C5C",
                    party_short == "presidente" ~ "#0D0D0D",
                    party_short == "abstencion" ~ "#c2b670"))


  expand_bill_df <- ggparliament::parliament_data(bill_df,
                                                  type = "semicircle",
                                                  parl_rows =6,
                                                  party_seats = bill_df$seats,
                                                  plot_order = bill_df$order) %>%
    dplyr::mutate(colour = as.character(colour))

  expand_bill_df %>%
    ggplot2::ggplot(ggplot2::aes(x, y, colour = party_long)) +
    ggparliament::geom_parliament_seats(size = 7) +
    ggparliament::geom_parliament_bar(colour = colour, party = party_short) +
    ggplot2::scale_colour_manual(values = expand_bill_df$colour,
                                 limits = expand_bill_df$party_long)  +
    ggplot2::guides(colour = ggplot2::guide_legend(nrow = 2)) +
    ggplot2::labs(title = "",
                  subtitle = "",
                  colour = "",
                  x = "",
                  y = "")  +
    ggthemes::theme_fivethirtyeight() +
    ggplot2::theme(
      panel.grid =  ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.text = ggplot2::element_text(size = 16)
    ) +
    ggplot2::labs(title = paste0("<b>", unique(bill_df$house), "</b><br>
                               <span style = 'font-size:10pt'> ",
                                 bill_metadata$description , "</span>")) +
    ggplot2::theme(
      plot.title.position = "plot",
      plot.title = ggtext::element_textbox_simple(
        size = 13,
        lineheight = 1,
       # padding = ggplot2::margin(5.5, 5.5, 5.5, 5.5),
       # margin = ggplot2::margin(0, 0, 5.5, 0),
        fill = "lightgrey"))



}
