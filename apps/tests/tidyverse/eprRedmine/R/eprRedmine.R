#' R client for Redmine API
#'
#' @description R API para redmine en EPRINSA
#'
#' Full list of available functions can be accessed by running
#' \code{help(package = "eprRedmine")}.
#'
#' @section Authentication:
#' Authentication is performed using API key, which can be obtained by accessing
#' '[you_redmine_server]/my/account'. Note that REST API should be enabled by
#' the server administrator.
#'
#' The easiest way to provide the key to \code{redmineR} is to define
#' environment variables REDMINE_URL and REDMINE_TOKEN inside your .Renviron
#' file. If this is not done, you will be prompted to enter url/token with the
#' first \code{redmineR} request (this would be saved for the current session
#' only).
#'
#' @section API Description:
#' The Redmine API is described at
#' \url{http://www.redmine.org/projects/redmine/wiki/Rest_api}
#'
#' @docType package
#' @name eprRedmine

NULL
