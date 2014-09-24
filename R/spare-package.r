
#' Client size load balancing
#'
#' @docType package
#' @name spareserver-package
NULL

#' Create a spare server object
#'
#' @param base_url Base URL of the server.
#' @param priority Non-negative initial odds of using this server, it has
#'   no units. Note that a server with zero odds can be used if all other
#'   servers are down.
#' @param timeout Initial timeout for this server, in seconds.
#' @param timeout_multiplier The timeout will be multiplied by this value
#'   after an unsuccessful query.
#' @return A spare server object
#' 
#' @export

server <- function(base_url, priority = 1, timeout = 5.0,
                   timeout_multiplier = 2.0) {
  structure(
    list(
      url = url,
      priority = priority,
      timeout = timeout,
      timeout_multiplier = timeout_multiplier
    ),
    class = "spare_server"
  )
}

#' Create a redundant service
#'
#' @param name Name of the service.
#' @param ... Server objects, zero or more. Servers can also be added
#'   later, using \code{add_server}. See \code{server}.
#' @return The name of the service, invisibly.
#'
#' @export

service <- function(name, ...) {

}

#' Add a spare server to a service
#'
#' @param service Name of the service.
#' @param ... Server objects to add.
#' @return Name of the service, invisibly.

add_server <- function(service, ...) {

}

#' Make a web query that makes use of redundant servers
#'
#' @param service Name of the service.
#' @param url URL, within the base URL of the server(s). This will be
#'   appended to the base URLs.
#' @param fun The function to call. It should have an argument called
#'   \code{url}.
#' @param ... Additional arguments to pass to \code{fun}.
#' @return The return value of \code{fun}.
#'
#' @export

spare_q <- function(service, url, fun, ...) {
  
}
