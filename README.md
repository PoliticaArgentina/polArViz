
<!-- README.md is generated from README.Rmd. Please edit that file -->

# polArViz

<!-- badges: start -->

[![R-CMD-check](https://github.com/TuQmano/polArViz/workflows/R-CMD-check/badge.svg)](https://github.com/TuQmano/polArViz/actions)
<!-- badges: end -->

Librería auxiliar del `polArverse` que contiene funciones para
visualizaciones que permiten explorar radpidamente la variedad de datos
del universo político de Argentina:

<img src="https://raw.githubusercontent.com/PoliticaArgentina/data_warehouse/master/hex/polArViz.png" style="width:30.0%" />

### {electorAr}

-   `plot_results()` devuelve un gráfico con el restulado agregado de
    una elección determianda (para el flujo de datos obtenidos con el
    parámetro `source = data`). Automáticamente ajusta el modo de
    visulización según el nivel de agregación (nacional / provincial /
    departamental)

-   `tabulate_results()` devuelve una tabla con el restulado agregado de
    una elección determianda (para el flujo de datos obtenidos con el
    parámetro `source = data`).

-   `map_results()` devuelve una tabla con el restulado de una elección
    determianda (para el flujo de datos obtenidos con el parámetro
    `source = data`). Un mapa de Argentina para elecciones
    presidenciales, y mapas provinciales para diputados o senadores.

### {discursAr}

-   `plot_speech()` permite una rápida visualización de la frecuencia de
    palabras de un discurso determinado (en su versión `tidy`).

### {legislAr}

-   `plot_bill()` grafica el resultado de la votación de una ley en una
    cámara legislativa.

## Instalatción

Se puede instalar la versión en desarrollo desde **Github**:

``` r
# install.packages("devtools")
devtools::install_github("politicaArgentina/polArViz")
```

![](https://raw.githubusercontent.com/PoliticaArgentina/data_warehouse/master/hex/collage.png)
