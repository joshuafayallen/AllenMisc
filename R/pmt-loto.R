#' PMT loto machine
#'
#' @description \code{pmt_loto} draws random numbers to guess the lottery ball
#' @details \code{grading} requires a vector of numbers
#'
#'
#'
#'
#' @param pmt_picks is vector of numbers from the show
#' @return is your pick
#'
#' @export

pmt_loto = function(pmt_picks) {
  draw = sample(1:100, 1)

  while (draw %in% pmt_picks) {
    draw = sample(1:100, 1)
  }

  return(draw)
}

#' @export
