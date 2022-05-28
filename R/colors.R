#' Complete list of palettes:
#'
#' Use \code{\link{vangogh_palette}} to construct palettes of desired length.
#'
#' @export
vangogh_palettes <- list(
  StarryNight = c("#0b1e38", "#4988BF", "#82C9D9", "#F2E96B", "#D9851E"),
  StarryRhone = c("#0D4373", "#27668C", "#5A98BF", "#637340", "#D9C873"),
  SelfPortrait = c("#27708C", "#B4D9CE", "#85A693", "#BFA575", "#A6511F"),
  CafeTerrace = c("#024873", "#A2A637", "#D9AA1E", "#D98825", "#BF4F26"),
  Eglise = c("#1D2759", "#27418C", "#9E6635", "#BFB95E", "#D9CA9C"),
  Irises = c("#819BB4", "#30588C", "#72A684", "#CDA124", "#A68863"),
  SunflowersMunich = c("#77A690", "#304020", "#BF7E06", "#401506", "#A63D17"),
  SunflowersLondon = c("#d49f2d", "#9D743B", "#cda35b", "#88925D", "#5E3E34"),
  Rest = c("#54778C", "#BF7315", "#F29B30", "#8C4303", "#F2AA6B"),
  Bedroom = c("#A2A63F", "#A67F0A", "#A6710F", "#8C6D46", "#731D0A"),
  CafeDeNuit = c("#467326", "#8AA676", "#D9B23D", "#BF793B", "#A63333"),
  Chaise = c("#3F858C", "#707322", "#F2D43D", "#D9814E", "#731A12"),
  Shoes = c("#8C7345", "#594A36", "#D9BD9C", "#8C4A32", "#AA9B89"),
  Landscape = c("#606B81", "#1E4359", "#58838C", "#A8BFBB", "#D7CBB3"),
  Cypresses = c("#A7CFF2", "#428C5C", "#D9A648", "#BF8136", "#0D0D0D")
)

#' A Van Gogh color palette generator.
#'
#' These are some color palettes from a selection of Vincent van Gogh's paintings.
#'
#' @param name Name of desired palette. Choices are:
#'   \code{StarryNight}, \code{StarryRhone},  \code{SelfPortrait},
#'   \code{CafeTerrace}, \code{Eglise},  \code{Irises},
#'   \code{SunflowersMunich},  \code{SunflowersLondon},  \code{Rest} ,\code{Bedroom} ,
#'   \code{CafeDeNuit}, \code{Chaise}, \code{Shoes}, \code{Landscape},
#'   \code{Cypresses}

#' @param n Number of colors desired. All palettes have a standard of 5 colors.
#'   If omitted, uses all colors.

#' @param type Either "continuous" or "discrete".
#' Use "continuous" to automatically interpolate between colours.
#'   @importFrom graphics rgb rect par image text
#' @return A vector of colors.
#' @export
#' @keywords colors
#' @examples
#' vangogh_palette("StarryNight")
#' vangogh_palette("SelfPortrait")
#' vangogh_palette("Cypresses")
#' vangogh_palette("Cypresses", 3)
#'
#' # If you want a continous paletted based on the colors already found in the preset
#' # palettes, you can interpolate between existing colours accordingly.
#' pal <- vangogh_palette(21, name = "StarryRhone", type = "continuous")
vangogh_palette <- function(name, n, type = c("discrete", "continuous")) {
  type <- match.arg(type)

  pal <- vangogh_palettes[[name]]
  if (is.null(pal)) {
    stop("Palette not found.")
  }

  if (missing(n)) {
    n <- length(pal)
  }

  if (type == "discrete" && n > length(pal)) {
    stop("Number of requested colors is greater than what palette can offer")
  }

  out <- switch(type,
    continuous = grDevices::colorRampPalette(pal)(n),
    discrete = pal[1:n]
  )
  structure(out, class = "palette", name = name)
}


#' @export
#' @importFrom graphics rect par image text
#' @importFrom grDevices rgb
print.palette <- function(x, ...) {
  n <- length(x)
  old <- par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(par(old))

  image(1:n, 1, as.matrix(1:n),
    col = x,
    ylab = "", xaxt = "n", yaxt = "n", bty = "n"
  )

  rect(0, 0.9, n + 1, 1.1, col = rgb(1, 1, 1, 0.8), border = NA)
  text((n + 1) / 2, 1, labels = attr(x, "name"), cex = 1, family = "serif")
}
