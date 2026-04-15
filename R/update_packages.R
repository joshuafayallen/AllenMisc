#' A [simple function to update R packages]
#'
#'
#' @md
#' @section this just keeps everything up to date and make
#'
#'
#'
#' @md
#' @param lib.loc  location of lib paths
#' @param repos not sure
#' @param type whether to compile from binary or source
#' @param with_pak whether to use pak to update the package defaults to TRUE
#' @param ... additional arguments to be passed to old.packages
#' @examples \dontrun{
#' update_my_pkgs(with_pak = TRUE)
#'
#' }
#' @export

update_my_pkgs <- function(
  lib.loc = .libPaths()[1],
  repos = getOption("repos"),
  type = c("binary", "source"),
  with_pak = TRUE,
  ...
) {
  # make sure all required packages are installed
  # it's ok to remove this line for slightly faster performance
  rlang::check_installed(c(
    "cli",
    "curl",
    "glue",
    "job",
    "pak",
    "purrr",
    "rlang"
  ))

  type <- rlang::arg_match(type)
  old <- utils::old.packages(lib.loc = lib.loc, repos = repos, type = type, ...)
  behind <- base::as.data.frame(old)

  # Exit early if no packages are behind
  if (base::nrow(behind) == 0) {
    cli::cli_alert_success("All {.val {type}} packages are up-to-date!")
    return(invisible(NULL))
  }

  # The following runs only if there are packages behind

  cli::cli_alert_info(
    "There {cli::qty(nrow(behind))}{?is a/are} {type} \\
    {cli::qty(nrow(behind))}update{?s} for the following {cli::no(nrow(behind))} \\
    package{?s} available:"
  )

  # This prints an overview of packages that are behind. The form is
  # {pkg}: {installed version} -> {repo version} at {source url} see {NEWS url}
  # or {repo url}
  cli::cat_bullet(
    format(behind$Package),
    ": ",
    format(behind$Installed),
    " -> ",
    format(behind$ReposVer),
    " at ",
    cli::style_hyperlink(
      format(
        host <- purrr::map_chr(
          behind$Repository,
          ~ curl::curl_parse_url(.x)$host
        )
      ),
      behind$Repository
    ),
    " see ",
    # create hyperlink to news file of the CRAN mirror in r-universe
    # or directly in the r-universe repo
    cli::style_hyperlink(
      "NEWS",
      base::ifelse(
        runiverse <- base::grepl("r-universe\\.dev", behind$Repository),
        glue::glue("https://{host}/{behind$Package}/NEWS"),
        glue::glue("https://cran.r-universe.dev/{behind$Package}/NEWS")
      )
    ),
    " or ",
    # create hyperlink to CRAN or to r-universe
    cli::style_hyperlink(
      base::ifelse(runiverse, "RUNIV", "CRAN"),
      base::ifelse(
        runiverse,
        glue::glue("https://{host}/{behind$Package}"),
        glue::glue("https://cran.r-project.org/package={behind$Package}")
      )
    )
  )
  cli::cat_rule()

  # Ask user if they would like to update now and wait for answer
  cli::cli_alert_info("Install {cli::qty(nrow(behind))}{?it/them} now? (Y/n)")
  ans <- base::readline()

  # If the user would like to update the "behind" packages, we will run
  # the update in a background job
  # The arg `with_pak` decides whether the update will run with the help
  # of the pak package or with base R
  if (base::tolower(ans) %in% c("", "y", "yes", "yeah", "yep")) {
    job::empty(
      {
        if (isFALSE(with_pak)) {
          utils::update.packages(
            lib.loc = lib.loc,
            repos = repos,
            ask = FALSE,
            oldPkgs = old,
            type = type
          )
        } else if (isTRUE(with_pak)) {
          # pak has no repos argument so we have to set it
          # through options
          options(repos = repos)
          pak::pak(old[, 1])
        }
      },
      import = c("lib.loc", "repos", "old", "type", "with_pak"),
      title = "Updating Your Package(s)..."
    )
  }
  # return behind invisibly
  invisible(behind)
}
