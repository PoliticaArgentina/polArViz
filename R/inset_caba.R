#' Zoom de CABA en un mapa de Argentina
#'
#'@description
#' Función para agregar un inset de CABA a un mapa de Argentina hecho con ggplot. La/s capa/s de datos deben contener la variable codprov_censo que viene con geoAr::get_geo() para poder filtrar la información
#'
#'@param ggplot_map Objeto de tipo ggplot que contiene un mapa de Argentina a nivel provincial
#'@param x Desplazamiento horizontal del inset respecto del centroide de CABA. Por default es 500.
#'@param y Desplazamiento vertical del inset respecto del centroide de CABA. Por default es 0
#'@param box_color Color de las líneas del contenedor del inset. Por default es "black". Para borrarlo poner NA
#'@param box_linewidth Grosor de la línea del contenedor del inset. Por default es 0.5
#'@param scale Factor de escala del polígono de CABA. Por default es 15. En caso de aumentar el mismo, tener en cuenta que puede solaparse con el mapa base y devolver error
#'@param radius Radio del círculo contenedor del inset. Por default es 15
#'
#' @examples
#'
#'  mapa <- ggplot2::ggplot() +
#'   ggplot2::geom_sf(data = geoAr::get_geo("ARGENTINA","provincia"),
#'    ggplot2::aes(fill = codprov_censo))
#'
#'   polArViz::inset_caba(mapa)
#'
#' @export

inset_caba <- function(ggplot_map, x = 500, y = 0,
                       box_color = "black", box_linewidth = 0.5,
                       scale = 15, radius = 15){

  scales <- ggplot2::ggplot_build(ggplot_map)

  data_layer <- purrr::is_empty(scales$plot$layers[[1]]$data)
  mapping_layer <- purrr::is_empty(scales$plot$layers[[1]]$mapping)

  if (data_layer == F) {

    centroide <- sf::st_centroid(sf::st_geometry(subset(scales$plot$layers[[1]]$data, codprov_censo == "02")))

  } else {

    centroide <- sf::st_centroid(sf::st_geometry(subset(scales$plot$data, codprov_censo == "02")))

  }

  n_layers <- length(scales$plot$layers)

  if (n_layers == 1) {

    if (data_layer == F) {
      mapa <- ggplot_map +
        ggmapinset::geom_sf_inset(data = subset(scales$plot$layers[[1]]$data, codprov_censo == "02"),
                                  mapping = scales$plot$layers[[1]]$mapping, show.legend = F,
                                  stat = ggmapinset::StatSfInset)
    } else if (data_layer == T & mapping_layer == F) {
      mapa <- ggplot_map +
        ggmapinset::geom_sf_inset(data = subset(scales$plot$data, codprov_censo == "02"),
                                  mapping = scales$plot$layers[[1]]$mapping, show.legend = F,
                                  stat = ggmapinset::StatSfInset)
    } else {
      mapa <- ggplot_map +
        ggmapinset::geom_sf_inset(data = subset(scales$plot$data, codprov_censo == "02"),
                                  mapping = scales$plot$mapping, show.legend = F,
                                  stat = ggmapinset::StatSfInset)
    }
  } else {

    if (data_layer & mapping_layer) {

      mapa <- ggplot_map +
        ggmapinset::geom_sf_inset(data = subset(scales$plot$data, codprov_censo == "02"),
                                  mapping = scales$plot$mapping, show.legend = F,
                                  stat = ggmapinset::StatSfInset) +
        purrr::map(.x = 2:n_layers, ~
                     ggmapinset::geom_sf_inset(data = subset(scales$plot$layers[[.x]]$data, codprov_censo == "02"),
                                               mapping = scales$plot$layers[[.x]]$mapping, show.legend = F, inherit.aes = F,
                                               stat = ggmapinset::StatSfInset))

    } else if (data_layer == T & mapping_layer == F) {

      mapa <- ggplot_map +
        ggmapinset::geom_sf_inset(data = subset(scales$plot$data, codprov_censo == "02"),
                                  mapping = scales$plot$layers[[1]]$mapping, show.legend = F,
                                  stat = ggmapinset::StatSfInset) +
        purrr::map(.x = 2:n_layers, ~
                     ggmapinset::geom_sf_inset(data = subset(scales$plot$layers[[.x]]$data, codprov_censo == "02"),
                                               mapping = scales$plot$layers[[.x]]$mapping, show.legend = F, inherit.aes = F,
                                               stat = ggmapinset::StatSfInset))
    } else {

      mapa <- ggplot_map +
        purrr::map(.x = 1:n_layers, ~
                     ggmapinset::geom_sf_inset(data = subset(scales$plot$layers[[.x]]$data, codprov_censo == "02"),
                                               mapping = scales$plot$layers[[.x]]$mapping, show.legend = F,
                                               stat = ggmapinset::StatSfInset))
    }
  }

  mapa <- mapa +
    ggmapinset::geom_inset_frame(color = box_color,
                                 linewidth = box_linewidth,stat = ggmapinset::StatSfInset) +
    ggmapinset::coord_sf_inset(inset = ggmapinset::configure_inset(centre = centroide, scale = scale,
                                                                   translation = c(x, y), radius = radius))
  mapa
}
