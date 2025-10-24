#' Check Color Vision Deficiency (CVD) Accessibility of Van Gogh Palettes
#'
#' @description
#' Simulates how a Van Gogh palette appears under different types of color vision
#' deficiency and provides accessibility scores. This function complements the existing
#' check_palette() function by adding visual simulation and quantitative metrics.
#'
#' @param palette_name Character string specifying the palette name (e.g., "StarryNight")
#' @param n Integer. Number of colors to extract from palette. Default is NULL (uses all colors).
#' @param simulate Logical. If TRUE, displays simulations for each CVD type. Default TRUE.
#' @param return_scores Logical. If TRUE, returns detailed scoring data. Default FALSE.
#'
#' @return If return_scores = TRUE, returns a data frame with CVD scores. Otherwise,
#'   displays visual simulations and prints a summary.
#'
#' @details
#' This function evaluates palette accessibility across three main types of color
#' vision deficiency:
#' \itemize{
#'   \item Deuteranopia (red-green, affects ~5% of males)
#'   \item Protanopia (red-green, affects ~2% of males)
#'   \item Tritanopia (blue-yellow, affects ~0.01% of population)
#' }
#'
#' The function uses the colorspace package for CVD simulation and calculates
#' minimum pairwise perceptual distance in CIELAB color space to assess
#' distinguishability.
#'
#' @examples
#' \dontrun{
#' # Visual simulation of StarryNight palette
#' check_vangogh_cvd("StarryNight")
#'
#' # Get detailed scores without plotting
#' scores <- check_vangogh_cvd("Irises", simulate = FALSE, return_scores = TRUE)
#'
#' # Check subset of colors
#' check_vangogh_cvd("CafeTerrace", n = 3)
#' }
#'
#' @export
check_vangogh_cvd <- function(palette_name, n = NULL, simulate = TRUE, return_scores = FALSE) {
  
  # Check if required packages are available
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    stop("Package 'colorspace' is required. Install it with: install.packages('colorspace')")
  }
  
  # Get the palette colors - handle n = NULL case
  if (!palette_name %in% names(vangogh_palettes)) {
    stop(paste0("Palette '", palette_name, "' not found. Available palettes: ",
                paste(names(vangogh_palettes), collapse = ", ")))
  }
  
  # Get palette - your function signature is vangogh_palette(name, n, type)
  if (is.null(n)) {
    # Get all colors from palette
    colors <- vangogh_palette(palette_name)
  } else {
    colors <- vangogh_palette(palette_name, n = n)
  }
  
  if (length(colors) < 2) {
    stop("Palette must contain at least 2 colors for CVD assessment")
  }
  
  # Define CVD types to test
  cvd_types <- c("deutan", "protan", "tritan")
  cvd_names <- c("Deuteranopia (red-green)", "Protanopia (red-green)", "Tritanopia (blue-yellow)")
  
  # Calculate scores for each CVD type
  results <- list()
  
  for (i in seq_along(cvd_types)) {
    cvd_type <- cvd_types[i]
    
    # Simulate CVD
    if (cvd_type == "deutan") {
      colors_cvd <- colorspace::deutan(colors, severity = 1)
    } else if (cvd_type == "protan") {
      colors_cvd <- colorspace::protan(colors, severity = 1)
    } else if (cvd_type == "tritan") {
      colors_cvd <- colorspace::tritan(colors, severity = 1)
    }
    
    # Calculate minimum pairwise distance in LAB space
    lab_coords <- colorspace::coords(as(colorspace::hex2RGB(colors_cvd), "LAB"))
    
    min_dist <- Inf
    if (nrow(lab_coords) >= 2) {
      for (j in 1:(nrow(lab_coords) - 1)) {
        for (k in (j + 1):nrow(lab_coords)) {
          dist <- sqrt(sum((lab_coords[j, ] - lab_coords[k, ])^2))
          if (dist < min_dist) min_dist <- dist
        }
      }
    }
    
    # Assess accessibility
    # CIELAB distance benchmarks: <10 = poor, 10-20 = fair, 20-40 = good, >40 = excellent
    if (min_dist < 10) {
      accessibility <- "Poor"
    } else if (min_dist < 20) {
      accessibility <- "Fair"
    } else if (min_dist < 40) {
      accessibility <- "Good"
    } else {
      accessibility <- "Excellent"
    }
    
    results[[cvd_type]] <- list(
      type = cvd_names[i],
      min_distance = round(min_dist, 2),
      accessibility = accessibility,
      colors_original = colors,
      colors_simulated = colors_cvd
    )
  }
  
  # Display simulations if requested
  if (simulate) {
    plot_cvd_simulation(palette_name, results)
  }
  
  # Print summary
  cat("\n")
  cat("=================================================\n")
  cat(paste0("CVD Accessibility Report: ", palette_name, "\n"))
  cat("=================================================\n\n")
  
  for (cvd_type in cvd_types) {
    res <- results[[cvd_type]]
    cat(sprintf("%-30s: %s (min distance: %.1f)\n",
                res$type, res$accessibility, res$min_distance))
  }
  
  cat("\n")
  cat("Distance Interpretation:\n")
  cat("  < 10  : Poor (colors may be indistinguishable)\n")
  cat("  10-20 : Fair (some difficulty distinguishing)\n")
  cat("  20-40 : Good (generally distinguishable)\n")
  cat("  > 40  : Excellent (highly distinguishable)\n")
  cat("\n")
  
  # Return scores if requested
  if (return_scores) {
    scores_df <- data.frame(
      palette = palette_name,
      cvd_type = cvd_names,
      min_distance = sapply(results, function(x) x$min_distance),
      accessibility = sapply(results, function(x) x$accessibility),
      stringsAsFactors = FALSE
    )
    return(scores_df)
  }
  
  invisible(results)
}


#' Plot CVD Simulation for a Palette
#'
#' @param palette_name Character string with palette name
#' @param results List of CVD simulation results from check_vangogh_cvd
#'
#' @keywords internal
#' @importFrom graphics mtext
plot_cvd_simulation <- function(palette_name, results) {
  
  # Set up plotting area
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))
  
  n_colors <- length(results[[1]]$colors_original)
  
  par(mfrow = c(4, 1), mar = c(1, 10, 2, 2))
  
  # Plot original palette
  plot(1:n_colors, rep(1, n_colors), 
       col = results[[1]]$colors_original,
       pch = 15, cex = 8, 
       ylim = c(0.5, 1.5), xlim = c(0.5, n_colors + 0.5),
       axes = FALSE, xlab = "", ylab = "", 
       main = paste0(palette_name, " - CVD Simulation"))
  mtext("Normal Vision", side = 2, line = 2, las = 1, cex = 0.9, font = 2)
  
  # Plot each CVD type
  cvd_types <- names(results)
  for (i in seq_along(cvd_types)) {
    res <- results[[cvd_types[i]]]
    
    plot(1:n_colors, rep(1, n_colors), 
         col = res$colors_simulated,
         pch = 15, cex = 8,
         ylim = c(0.5, 1.5), xlim = c(0.5, n_colors + 0.5),
         axes = FALSE, xlab = "", ylab = "")
    
    # Add label with accessibility rating
    label <- paste0(sub(" \\(.*", "", res$type), "\n", res$accessibility)
    mtext(label, side = 2, line = 2, las = 1, cex = 0.8)
  }
}


#' Batch Check CVD Accessibility for All Palettes
#'
#' @description
#' Runs CVD accessibility checks across all Van Gogh palettes and returns
#' a summary data frame. Useful for generating documentation and identifying
#' the most accessible palettes.
#'
#' @param simulate Logical. If TRUE, displays simulations for each palette. Default FALSE.
#'
#' @return A data frame with CVD scores for all palettes
#'
#' @examples
#' \dontrun{
#' # Get scores for all palettes
#' all_scores <- check_all_vangogh_cvd()
#'
#' # Find the most accessible palettes
#' library(dplyr)
#' all_scores %>%
#'   group_by(palette) %>%
#'   summarise(avg_distance = mean(min_distance)) %>%
#'   arrange(desc(avg_distance))
#' }
#'
#' @export
check_all_vangogh_cvd <- function(simulate = FALSE) {
  
  all_palettes <- names(vangogh_palettes)
  results_list <- list()
  
  cat("Checking CVD accessibility for all palettes...\n\n")
  
  for (palette in all_palettes) {
    if (simulate) {
      cat(paste0("\n--- ", palette, " ---\n"))
    }
    
    scores <- tryCatch({
      check_vangogh_cvd(
        palette, 
        n = NULL,  # Use all colors
        simulate = simulate, 
        return_scores = TRUE
      )
    }, error = function(e) {
      message(paste0("Error checking ", palette, ": ", e$message))
      NULL
    })
    
    if (!is.null(scores)) {
      results_list[[palette]] <- scores
    }
  }
  
  # Combine all results
  all_results <- do.call(rbind, results_list)
  rownames(all_results) <- NULL
  
  return(all_results)
}


#' Get CVD-Safe Van Gogh Palettes
#'
#' @description
#' Returns a list of Van Gogh palettes that meet minimum accessibility
#' standards for color vision deficiency.
#'
#' @param min_distance Numeric. Minimum CIELAB distance threshold. Default 15.
#' @param cvd_types Character vector. Which CVD types to check. Options:
#'   "deutan", "protan", "tritan". Default checks all.
#'
#' @return Character vector of palette names that meet the criteria
#'
#' @examples
#' \dontrun{
#' # Get highly accessible palettes
#' safe_palettes <- get_cvd_safe_palettes(min_distance = 20)
#'
#' # Use a safe palette
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_vangogh(safe_palettes[1])
#' }
#'
#' @export
get_cvd_safe_palettes <- function(min_distance = 15, 
                                  cvd_types = c("deutan", "protan", "tritan")) {
  
  all_scores <- check_all_vangogh_cvd(simulate = FALSE)
  
  # Map CVD type names to readable names
  type_mapping <- c(
    "deutan" = "Deuteranopia",
    "protan" = "Protanopia",
    "tritan" = "Tritanopia"
  )
  
  selected_types <- type_mapping[cvd_types]
  
  # Filter palettes that meet criteria for all requested CVD types
  safe_palettes <- all_scores[grepl(paste(selected_types, collapse = "|"), all_scores$cvd_type), ]
  safe_palettes <- safe_palettes[safe_palettes$min_distance >= min_distance, ]
  
  # Count how many CVD types each palette passes
  palette_counts <- table(safe_palettes$palette)
  safe_palette_names <- names(palette_counts[palette_counts == length(selected_types)])
  
  if (length(safe_palette_names) == 0) {
    message(paste0("No palettes found meeting distance threshold of ", min_distance))
    message("Try lowering the min_distance parameter")
    return(character(0))
  }
  
  return(safe_palette_names)
}