library(jsonlite)
library(lubridate)

#' extrae versiones de redmine
#' @param p_project proyecto
#' @param p_status estado
#' @return versiones de redmine del proyecto
epr_versiones <- function(p_project = "Desarrollo", p_status = "open") {

  w_URL_base <- "https://proyectos.eprinsa.es/"
  w_dir <- "projects/"
  w_versions <- "/versions.json"
  w_key <- Sys.getenv("REDMINE_KEY")

  sURL <- paste0( w_URL_base, w_dir, p_project, w_versions, "?key=", w_key )
  response <- fromJSON(sURL)

  response$versions[response$versions$status==p_status,]
}

#' localiza versión "proxima relaese"
#' @return proxima release
epr_ver_Proxima_Release <- function() {
  v <- epr_versiones()

  v[v$name=="0 - Próxima Release",]
}

#' localiza versión "obligatorio"
#' @return versión obligatorio
epr_ver_Obligatorio <- function() {
  v <- epr_versiones()

  v[v$name=="1 - Obligatorio",]
}

#' localiza versión "importante"
#' @return versión importante
epr_ver_Importante <- function() {
  v <- epr_versiones()

  v[v$name=="2 - Importante",]
}

#' localiza versión "Deseable"
#' @return versión deseable
epr_ver_Deaseable <- function() {
  v <- epr_versiones()

  v[v$name=="3 - Deseable",]
}

#' localiza versión "algún día"
#' @return versión algún día
epr_ver_Algun_dia <- function() {
  v <- epr_versiones()

  v[v$name=="4 - Algún día",]
}

#' localiza la versión actual (sprint actual)
#'
#' Para determinar la versión actual se presume que el sprint es de 3 semanas,
#' que se libera el miércoles y que la fecha de liberación coincide con "due_date".
#'
#' Se añaden a la versión el primer día (lunes de la primera semana) y el último día
#' (viernes de la tercera semana)
#'
#' @return versión actual
#'
#' @export
#'
epr_ver_Actual <- function() {
  v <- epr_versiones()

  # filtramos versiones sin fechas
  v <- v[ !is.na(v$due_date), ]

  # filtramos versiones pasadas (ajustamos miércoles a lunes)
  v <- v[ floor_date(as.Date(v$due_date), unit = "week") > Sys.Date(), ]

  # ordenamos la versiones por due_date
  v <- v[ order(v$due_date), ]

  # nos quedamos con la segunda versión (si existe) que sirve para marcar el fin de la primera
  # siendo el viernes anterior o consideramos (si no existe) un sprint de 3 semanas
  if( nrow(v) > 1)
    ultimo_dia <- floor_date( as.Date(v[2,]$due_date), unit = "week" ) - days(3)
  else
    ultimo_dia <- floor_date(as.Date(v$due_date), unit = "week") + weeks(2) + days(5)

  # buscamos la primera versión
  v <- v[1,]

  # primer día de la version
  v$primer_dia = floor_date(as.Date(v$due_date), unit = "week")

  # último día de la version
  v$ultimo_dia = ultimo_dia

  v
}
