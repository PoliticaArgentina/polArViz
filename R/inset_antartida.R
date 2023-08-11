#' Agregar Antártida e Islas del Atlántico Sur a mapas de Argentina
#'
#'@description
#' Función para agregar un inset de Antártida e Islas del Atlántico Sur a un mapa de Argentina hecho con ggplot
#'
#'@param ggplot_map Objeto de tipo ggplot que contiene un mapa de Argentina a nivel provincial
#'@param mapping Especifica si los polígonos de AIAS debe rellenarse con el mismo color que Tierra del Fuego e Islas Malvinas (aplica al parámetro fill de la capa). Por default es FALSE
#'@param capa En caso de que mapping sea TRUE, número de capa del objeto ggplot que contiene los datos para buscar el color del fill
#'@param crs Proyección de los datos. Por default es 22197 para darle un aspecto esférico.
#'@param map_fill Color de relleno de los polígonos (cuando mapping es FALSE). Por default es "white"
#'@param map_color Color de las líneas de los polígonos. Por default es "black"
#'@param map_linewidth Grosor de la línea de los polígonos. Por default es 0.1
#'@param box_color Color de las líneas de la caja del inset. Por default es "black". Para borrarlo poner NA
#'@param box_linewidth Grosor de la línea de la caja del inset. Por default es 0.1
#'@param x Posición en la grilla sobre el eje x (se usa cowplot::draw_plot()). Por default es 0.15
#'@param y Posición en la grilla sobre el eje y  (se usa cowplot::draw_plot()). Por default es 0.05
#'@param scale Factor de escala del inset. Por default es 0.3
#'
#' @examples
#'
#'  mapa <- ggplot2::ggplot() +
#'   ggplot2::geom_sf(data = geoAr::get_geo("ARGENTINA","provincia"),
#'    ggplot2::aes(fill = codprov_censo))
#'
#'   polArViz::inset_antartida(mapa, mapping = TRUE, capa = 1)
#'
#' @export

inset_antartida <- function(ggplot_map, mapping = F, capa = 1, crs =  22197,
                            map_fill = "white", map_color = "black", map_linewidth = 0.1,
                            box_color = "black", box_linewidth = 0.1,
                            x = 0.15, y = 0.05, scale = 0.3){

  antartida <- sf::read_sf("https://raw.githubusercontent.com/PoliticaArgentina/data_warehouse/master/geoAr/data_raw/antartida_ign.geojson")

  antartida <- sf::st_transform(antartida, crs = crs)

  if (mapping) {

    scales <- ggplot2::ggplot_build(ggplot_map)

    data_color <- dplyr::pull(dplyr::slice(dplyr::arrange(scales$data[[capa]], dplyr::desc(geometry)),1), "fill")

    antartida_map <- ggplot2::ggplot() +
      ggplot2::geom_sf(data = antartida,
                       fill = data_color, show.legend = F) +
      ggplot2::theme_void() +
      ggplot2::theme(panel.border = ggplot2::element_rect(colour = box_color,
                                                          fill = NA,
                                                          linewidth = box_linewidth))

  } else {

    antartida_map <- ggplot2::ggplot() +
      ggplot2::geom_sf(data = antartida, color = map_color, fill = map_fill,
                       linewidth = map_linewidth, show.legend = F) +
      ggplot2::theme_void() +
      ggplot2::theme(panel.border = ggplot2::element_rect(colour = box_color,
                                                          fill = NA,
                                                          linewidth = box_linewidth))
  }

  cowplot::ggdraw() +
    cowplot::draw_plot(ggplot_map) +
    cowplot::draw_plot(antartida_map, x = x, y = y, height = scale)
}
