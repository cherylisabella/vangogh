# scales_vangogh.R
# -----------------------
# ggplot2 discrete & continuous scales for Van Gogh palettes

#' Scale color with Van Gogh palettes
#'
#' @param name Palette name
#' @param discrete Logical: use discrete scale
#' @param colorblind Logical: use colorblind-safe colors
#' @param ... Additional arguments to ggplot2 scale function
#' @export
scale_color_vangogh <- function(name, discrete = TRUE, colorblind = FALSE, ...) {
  pal <- vangogh::safe_vangogh_palette(name,
                                       type = ifelse(discrete, "discrete", "continuous"),
                                       colorblind = colorblind)
  if (discrete) {
    ggplot2::scale_color_manual(values = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colors = pal, ...)
  }
}

#' @rdname scale_color_vangogh
#' @export
scale_colour_vangogh <- scale_color_vangogh

#' Scale fill with Van Gogh palettes
#'
#' @param name Palette name
#' @param discrete Logical: use discrete scale
#' @param colorblind Logical: use colorblind-safe colors
#' @param ... Additional arguments to ggplot2 scale function
#' @export
scale_fill_vangogh <- function(name, discrete = TRUE, colorblind = FALSE, ...) {
  pal <- vangogh::safe_vangogh_palette(name,
                                       type = ifelse(discrete, "discrete", "continuous"),
                                       colorblind = colorblind)
  if (discrete) {
    ggplot2::scale_fill_manual(values = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colors = pal, ...)
  }
}
