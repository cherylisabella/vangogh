#' vangogh palette with ramped colours
#'
#' @param palette Choose from 'vangogh_palettes' list
#'
#' @param alpha transparency
#'
#' @param reverse If TRUE, the direction of the colours is reversed.
#'
#' @examples
#' library(scales)
#' show_col(vangogh_pal()(10))
#'
#' filled.contour(volcano, color.palette = vangogh_pal(), asp = 1)
#' @return Palettes with ramped colors from predefined palettes
#' @export
vangogh_pal <- function(palette = "StarryRhone", alpha = 1, reverse = FALSE) {
  pal <- vangogh_palettes[[palette]]
  if (reverse) {
    pal <- rev(pal)
  }
  return(colorRampPalette(pal, alpha))
}

#' Setup colour palette for ggplot2
#'
#' @rdname scale_color_vangogh
#'
#' @param palette Choose from 'vangogh_palettes' list
#'
#' @param reverse logical, Reverse the order of the colours?
#'
#' @param alpha transparency
#'
#' @param discrete whether to use a discrete colour palette
#'
#' @param ... additional arguments to pass to scale_color_gradientn
#'
#' @inheritParams viridis::scale_color_viridis
#'
#' @importFrom ggplot2 scale_colour_manual
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, wt)) +
#'   geom_point(aes(colour = factor(cyl))) +
#'   scale_colour_vangogh(palette = "StarryNight")
#' ggplot(mtcars, aes(mpg, wt)) +
#'   geom_point(aes(colour = hp)) +
#'   scale_colour_vangogh(palette = "StarryNight", discrete = FALSE)
#' ggplot(data = mpg) +
#'   geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
#'   scale_colour_vangogh(palette = "StarryRhone")
#' ggplot(diamonds) +
#'   geom_bar(aes(x = cut, fill = clarity)) +
#'   scale_fill_vangogh()
#' @return A scale_color_vangogh function
#' @export
#'
#' @importFrom ggplot2 discrete_scale scale_color_gradientn
scale_color_vangogh <- function(..., palette = "StarryNight",
                                discrete = TRUE, alpha = 1, reverse = FALSE) {
  if (discrete) {
    discrete_scale("colour", "vangogh", palette = vangogh_pal(palette, alpha = alpha, reverse = reverse))
  } else {
    scale_color_gradientn(colours = vangogh_pal(palette, alpha = alpha, reverse = reverse, ...)(256))
  }
  # scale_colour_manual(values=ochre_palettes[[palette]])
}

#' @rdname scale_color_vangogh
#' @export
scale_colour_vangogh <- scale_color_vangogh

#' #' Setup fill palette for ggplot2
#'
#' @param palette Choose from 'vangogh_palettes' list
#'
#' @inheritParams viridis::scale_fill_viridis
#' @inheritParams vangogh_pal
#'
#' @param discrete whether to use a discrete colour palette
#'
#' @param ... additional arguments to pass to scale_color_gradientn
#'
#' @importFrom ggplot2 scale_fill_manual discrete_scale scale_fill_gradientn
#' @return A scale_fill_vangogh function
#' @export
scale_fill_vangogh <- function(..., palette = "StarryNight",
                               discrete = TRUE, alpha = 1, reverse = TRUE) {
  if (discrete) {
    discrete_scale("fill", "vangogh", palette = vangogh_pal(palette, alpha = alpha, reverse = reverse))
  } else {
    scale_fill_gradientn(colours = vangogh_pal(palette, alpha = alpha, reverse = reverse, ...)(256))
  }
}
