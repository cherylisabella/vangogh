# vangogh_interpolate.R
# -----------------------
# Interpolate colors for continuous palettes

#' Interpolate a Van Gogh palette
#'
#' @param palette Vector of hex colors
#' @param n Number of colors desired
#' @export
vangogh_interpolate <- function(palette, n) {
  grDevices::colorRampPalette(palette)(n)
}
