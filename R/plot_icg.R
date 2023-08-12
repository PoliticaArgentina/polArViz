#' Plot ICG
#'
#' @description
#' Función que permite una visuaizacion rapida de la serie del Indice de Confianza en el Gobierno (ICG)
#'
#' @param data un tibble guardado como objeto en el Enviroment luego de consultar \code{\link[opinAr]{get_icg_raw}} con los microdatos del ICG - UTDT
#'
#' @return Devuelve un objeto de \code{class"gg" "ggplot"} que grafica una serie de tiempo con los valores computados del ICG - UTDT con \code{\link[opinAr]{compute_icg}}

#'
#' @export
#'

plot_icg <- function(data){
  # INPUT


  fechas_ondas <- opinAr::show_waves(data)

  data <- data %>%
    dplyr::left_join(fechas_ondas, by = c('ola'),
                     suffix=c('','.2')) %>%
    dplyr::mutate(anio = dplyr::case_when(is.na(anio) ~ anio.2, TRUE ~ anio),
                  mes = dplyr::case_when(is.na(mes) ~ mes.2, TRUE ~ mes)
    ) %>%
    dplyr::select(- dplyr::contains('.2'))




  data_plot <- opinAr::compute_icg(data = data) %>%
    dplyr::left_join(fechas_ondas, by = 'ola') %>%
    dplyr::mutate(fecha = lubridate::dmy(glue::glue('1/{mes}/{anio}')))


  mean_icg <- mean(data_plot$icg)


  ggplot2::ggplot(data = data_plot,
                  ggplot2::aes(x = fecha, y = icg)) +
    ggplot2::geom_line() +
    ggplot2::geom_point() +
    ggplot2::geom_text(data = data_plot %>%
                         dplyr::slice_tail(),
                       ggplot2::aes(x = fecha + 365,
                                    y = icg,
                                    label = icg),
                       size = 6,
                       color = 'red') +
    ggplot2::geom_hline(yintercept = mean_icg, color = 'blue',
                        linewidth = 1,  alpha = 0.4) +
    ggthemes::theme_fivethirtyeight() +
    ggplot2::scale_x_date(date_breaks = '4 year',
                          date_labels = '%Y')



}
