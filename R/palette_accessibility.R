#' @importFrom methods as
if (getRversion() >= "2.15.1") utils::globalVariables(
  c("x", "y", "hex", "palette", "color_index", "fill_col", "cvd_type")
)

# palette_accessibility.R
# -----------------------
# Functions to inspect palettes, provide safe alternatives,
# visualise palettes, suggest, export, and compare.

# ------------------------------------------------------------------------------
# 1. Palette Inspection / Colorblind Safe Versions
# ------------------------------------------------------------------------------

#' Check palette accessibility with colorblind simulations
#'
#' Uses `colorspace` to simulate common forms of colorblindness.
#'
#' @param name Palette name (character)
#' @param type Either "discrete" or "continuous" (default "discrete")
#' @param n Number of colors for continuous palettes
#' @export
#' @examples
#' \dontrun{
#' vangogh::check_palette("StarryNight")
#' }
check_palette <- function(name, type = "discrete", n = NULL) {
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    stop("Please install the 'colorspace' package to use this function.")
  }
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Please install the 'ggplot2' package to use this function.")
  }
  
  pal <- vangogh::safe_vangogh_palette(name, type = type, n = n)
  
  # Create CVD simulations
  cvd_types <- c("Original", "Deuteranopia", "Protanopia", "Tritanopia")
  df_list <- lapply(cvd_types, function(cvd) {
    if (cvd == "Original") {
      cols <- pal
    } else if (cvd == "Deuteranopia") {
      cols <- colorspace::deutan(pal)
    } else if (cvd == "Protanopia") {
      cols <- colorspace::protan(pal)
    } else if (cvd == "Tritanopia") {
      cols <- colorspace::tritan(pal)
    }
    
    data.frame(
      x = seq_along(cols),
      y = 1,
      col = cols,
      hex = pal,
      cvd_type = cvd,
      stringsAsFactors = FALSE
    )
  })
  
  df <- do.call(rbind, df_list)
  df$cvd_type <- factor(df$cvd_type, levels = cvd_types)
  
  gg <- ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, fill = .data$col)) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::scale_fill_identity() +
    ggplot2::facet_wrap(~.data$cvd_type, ncol = 2) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    ) +
    ggplot2::coord_equal() +
    ggplot2::geom_text(ggplot2::aes(label = .data$hex, y = .data$y - 0.3),
                       color = "black", size = 3) +
    ggplot2::ggtitle(paste("Palette:", name))
  
  gg
}

#' Generate a colorblind-safe Van Gogh palette
#'
#' Returns the original palette (colorblind adjustment removed).
#'
#' @param name Palette name
#' @param type Either "discrete" or "continuous"
#' @param n Number of colors for continuous palettes
#' @param colorblind Logical, kept for compatibility
#' @export
safe_vangogh_palette <- function(name, type = "discrete", n = NULL, colorblind = FALSE) {
  type <- match.arg(type, choices = c("discrete", "continuous"))
  pal <- vangogh::vangogh_palettes[[name]]
  if (is.null(pal)) stop("Unknown palette: ", name)
  
  if (is.null(n)) n <- length(pal)
  
  out <- switch(type,
                continuous = vangogh::vangogh_interpolate(pal, n),
                discrete = pal[seq_len(n)]
  )
  
  out
}

# ------------------------------------------------------------------------------
# 2. Palette Visualisation
# ------------------------------------------------------------------------------

#' Visualise a Van Gogh palette with optional colorblind simulation
#'
#' @param name Palette name
#' @param show_hex Display hex codes (TRUE/FALSE)
#' @param colorblind Show colorblind simulation (TRUE/FALSE)
#' @param type Either "discrete" or "continuous"
#' @param n Number of colors for continuous palettes
#' @export
#' @importFrom rlang .data
viz_palette <- function(name, show_hex = TRUE, colorblind = FALSE,
                        type = "discrete", n = NULL) {
  pal <- safe_vangogh_palette(name, type = type, n = n, colorblind = FALSE)
  
  if (colorblind && requireNamespace("colorspace", quietly = TRUE)) {
    # Create CVD simulations
    cvd_types <- c("Original", "Deuteranopia", "Protanopia", "Tritanopia")
    df_list <- lapply(cvd_types, function(cvd) {
      if (cvd == "Original") {
        cols <- pal
      } else if (cvd == "Deuteranopia") {
        cols <- colorspace::deutan(pal)
      } else if (cvd == "Protanopia") {
        cols <- colorspace::protan(pal)
      } else if (cvd == "Tritanopia") {
        cols <- colorspace::tritan(pal)
      }
      
      data.frame(
        x = seq_along(cols),
        y = 1,
        fill_col = cols,
        hex = pal,
        cvd_type = cvd,
        stringsAsFactors = FALSE
      )
    })
    
    df <- do.call(rbind, df_list)
    df$cvd_type <- factor(df$cvd_type, levels = cvd_types)
    
    gg <- ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, fill = .data$fill_col)) +
      ggplot2::geom_tile(color = "white") +
      ggplot2::scale_fill_identity() +
      ggplot2::facet_wrap(~.data$cvd_type, ncol = 2) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.title = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid = ggplot2::element_blank()
      ) +
      ggplot2::coord_equal()
    
    if (show_hex) {
      gg <- gg + ggplot2::geom_text(
        ggplot2::aes(label = .data$hex, y = .data$y - 0.3),
        color = "black", size = 3
      )
    }
    
    return(gg)
  }
  
  # Standard visualization without CVD simulation
  df <- data.frame(
    x = seq_along(pal),
    y = 1,
    fill_col = pal,
    hex = pal,
    stringsAsFactors = FALSE
  )
  
  gg <- ggplot2::ggplot(df, ggplot2::aes(.data$x, .data$y, fill = .data$fill_col)) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void() +
    ggplot2::coord_equal()
  
  if (show_hex) {
    gg <- gg + ggplot2::geom_text(
      ggplot2::aes(label = .data$hex, y = .data$y - 0.3),
      color = "black", size = 3
    )
  }
  
  gg
}

# ------------------------------------------------------------------------------
# 3. Return palette info with optional HCL metadata
# ------------------------------------------------------------------------------

#' Return palette info as a data frame with optional HCL
#'
#' @param colorblind Logical (compatibility)
#' @param add_metadata Logical: compute HCL hue/chroma/luminance if colorspace is installed
#' @export
vangogh_palette_info <- function(colorblind = FALSE, add_metadata = FALSE) {
  info <- lapply(names(vangogh::vangogh_palettes), function(pal_name) {
    cols <- safe_vangogh_palette(pal_name, type = "discrete")
    df <- data.frame(
      palette = pal_name,
      color_index = seq_along(cols),
      hex = cols,
      stringsAsFactors = FALSE
    )
    if (add_metadata && requireNamespace("colorspace", quietly = TRUE)) {
      rgb_obj <- colorspace::hex2RGB(cols)
      hcl_obj <- as(rgb_obj, "polarLUV")
      hcl_coords <- colorspace::coords(hcl_obj)
      df$hue <- hcl_coords[, "H"]
      df$chroma <- hcl_coords[, "C"]
      df$luminance <- hcl_coords[, "L"]
    }
    df
  })
  do.call(rbind, info)
}

#' Return all Van Gogh palettes as a tidy data frame
#'
#' @param n Number of colors per palette
#' @param type "discrete" or "continuous"
#' @param colorblind Logical (compatibility)
#' @param add_metadata Logical: compute HCL metadata if colorspace available
#' @export
vangogh_colors <- function(n = NULL, type = "discrete", colorblind = FALSE, add_metadata = FALSE) {
  df_list <- lapply(names(vangogh::vangogh_palettes), function(pal_name) {
    cols <- safe_vangogh_palette(pal_name, type = type, n = n)
    df <- data.frame(
      palette = pal_name,
      color_index = seq_along(cols),
      hex = cols,
      stringsAsFactors = FALSE
    )
    if (add_metadata && requireNamespace("colorspace", quietly = TRUE)) {
      rgb_obj <- colorspace::hex2RGB(cols)
      hcl_obj <- as(rgb_obj, "polarLUV")
      hcl_coords <- colorspace::coords(hcl_obj)
      df$hue <- hcl_coords[, "H"]
      df$chroma <- hcl_coords[, "C"]
      df$luminance <- hcl_coords[, "L"]
    }
    df
  })
  do.call(rbind, df_list)
}

# ------------------------------------------------------------------------------
# 4. Compare palettes (Facet-style)
# ------------------------------------------------------------------------------

#' Compare multiple Van Gogh palettes in a facet-style visualization
#'
#' @param palettes Character vector of palette names
#' @param show_hex Logical: display hex codes
#' @param colorblind Logical: simulate colorblind view
#' @param type "discrete" or "continuous"
#' @param n Number of colors for continuous palettes
#' @export
#' @importFrom rlang .data
compare_palettes <- function(palettes, show_hex = TRUE, colorblind = FALSE, type = "discrete", n = NULL) {
  if (colorblind && requireNamespace("colorspace", quietly = TRUE)) {
    # Create CVD simulations for comparison
    cvd_types <- c("Original", "Deuteranopia", "Protanopia", "Tritanopia")
    df_list <- lapply(palettes, function(pal_name) {
      cols_orig <- safe_vangogh_palette(pal_name, type = type, n = n)
      
      cvd_list <- lapply(cvd_types, function(cvd) {
        if (cvd == "Original") {
          cols <- cols_orig
        } else if (cvd == "Deuteranopia") {
          cols <- colorspace::deutan(cols_orig)
        } else if (cvd == "Protanopia") {
          cols <- colorspace::protan(cols_orig)
        } else if (cvd == "Tritanopia") {
          cols <- colorspace::tritan(cols_orig)
        }
        
        data.frame(
          palette = pal_name,
          color_index = seq_along(cols),
          hex = cols_orig,
          fill_col = cols,
          cvd_type = cvd,
          stringsAsFactors = FALSE
        )
      })
      
      do.call(rbind, cvd_list)
    })
    
    df <- do.call(rbind, df_list)
    df$cvd_type <- factor(df$cvd_type, levels = cvd_types)
    
    gg <- ggplot2::ggplot(df, ggplot2::aes(x = .data$color_index, y = .data$cvd_type, fill = .data$fill_col)) +
      ggplot2::geom_tile(color = "white") +
      ggplot2::scale_fill_identity() +
      ggplot2::facet_wrap(~.data$palette, scales = "free_x") +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.title = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid = ggplot2::element_blank()
      )
    
    if (show_hex) {
      gg <- gg + ggplot2::geom_text(
        ggplot2::aes(label = .data$hex, y = .data$cvd_type),
        color = "black", size = 2.5
      )
    }
    
    return(gg)
  }
  
  # Standard comparison without CVD simulation
  df_list <- lapply(palettes, function(pal_name) {
    cols <- safe_vangogh_palette(pal_name, type = type, n = n)
    data.frame(
      palette = pal_name,
      color_index = seq_along(cols),
      hex = cols,
      fill_col = cols,
      stringsAsFactors = FALSE
    )
  })
  df <- do.call(rbind, df_list)
  
  gg <- ggplot2::ggplot(df, ggplot2::aes(x = .data$color_index, y = 1, fill = .data$fill_col)) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::scale_fill_identity() +
    ggplot2::facet_wrap(~.data$palette, scales = "free_x") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank()
    )
  
  if (show_hex) {
    gg <- gg + ggplot2::geom_text(
      ggplot2::aes(label = .data$hex, y = 0.5),
      color = "black", size = 3
    )
  }
  
  gg
}

# ------------------------------------------------------------------------------
# 5. Suggest palette
# ------------------------------------------------------------------------------

#' Suggest a palette based on number of colors
#'
#' @param n Number of colors needed
#' @param type "discrete" or "continuous"
#' @export
vangogh_suggest <- function(n = 5, type = "discrete") {
  available <- names(vangogh::vangogh_palettes)
  candidates <- sapply(available, function(pal_name) {
    pal_len <- length(vangogh::vangogh_palettes[[pal_name]])
    pal_len >= n
  })
  suggestions <- available[candidates]
  if (length(suggestions) == 0) {
    warning("No discrete palettes with sufficient colors; returning all available")
    suggestions <- available
  }
  suggestions
}

# ------------------------------------------------------------------------------
# 6. Export palettes
# ------------------------------------------------------------------------------

#' Export palettes to JSON or CSV
#'
#' @param file File path including filename
#' @param format "json" or "csv"
#' @param n Number of colors (for continuous palettes)
#' @param type "discrete" or "continuous"
#' @param add_metadata Logical: include HCL metadata if available
#' @export
vangogh_export <- function(file, format = c("json", "csv"), n = NULL, type = "discrete", add_metadata = FALSE) {
  format <- match.arg(format)
  df <- vangogh::vangogh_colors(n = n, type = type, add_metadata = add_metadata)
  
  if (format == "json") {
    if (!requireNamespace("jsonlite", quietly = TRUE)) stop("Install 'jsonlite' to export JSON")
    jsonlite::write_json(df, file, pretty = TRUE)
  } else if (format == "csv") {
    utils::write.csv(df, file, row.names = FALSE)
  }
}