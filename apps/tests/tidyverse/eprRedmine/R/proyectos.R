
#' obtiene los proyectos en redmine
#'
#' @return proyectos en redmine
#'
#' @export
epr_projects <- function() {
  w_URL_base <- "https://proyectos.eprinsa.es/"
  w_dir <- "projects.json"
  w_key <- Sys.getenv("REDMINE_KEY")

  w_flag <- TRUE
  w_offset <- 0
  w_limit <- 100
  w_res <- data_frame()


  while(w_flag) {
    sURL <- c( paste0( w_URL_base, w_dir, "?key=", w_key ),
               paste0("limit=", w_limit),
               paste0("offset=", w_offset)
              )
    response <- fromJSON(paste(sURL, collapse="&"))
    w_total_count <- response$total_count

    w_sel <- bind_cols( id = response$projects$id,
                        name = response$projects$name,
                        identifier = response$projects$identifier,
                        description = response$projects$description,
                        status = response$projects$status,
                        parent.id = response$projects$parent$id,
                        parent.name = response$projects$parent$name,
                        is_public = response$projects$is_public
                        )

    w_res <- rbind( w_res, w_sel )
    w_flag <- (w_total_count > nrow(w_res))
    w_offset <- w_offset + w_limit

  }

  w_res
}

#' obtiene el proyecto base para el Equipo Recaudación
#'
#' Identificamos el proyecto a través de su identificador -> "des-gest-rec". Todos
#' los proyectos del Equipo Recaudación son hijos de este proyecto.
#'
#' @return proyecto base para el Equipo Recaudación
#'
#' @export
epr_prj_Equipo_Recaudacion <- function() {
  p <- epr_projects()

  p[ p$identifier == "des-gest-rec", ]
}
