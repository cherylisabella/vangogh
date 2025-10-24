test_that("check_vangogh_cvd requires colorspace package", {
  # Mock missing package
  skip_if(requireNamespace("colorspace", quietly = TRUE), 
          "colorspace is installed, cannot test missing package error")
  
  expect_error(
    check_vangogh_cvd("StarryNight"),
    "colorspace.*required"
  )
})

test_that("check_vangogh_cvd validates palette name", {
  skip_if_not_installed("colorspace")
  
  expect_error(
    check_vangogh_cvd("NonExistentPalette"),
    "not found"
  )
  
  expect_error(
    check_vangogh_cvd("NonExistentPalette"),
    "Available palettes"
  )
})

test_that("check_vangogh_cvd works with NULL n parameter", {
  skip_if_not_installed("colorspace")
  
  # Should not error with n = NULL (but will print report)
  expect_no_error({
    result <- check_vangogh_cvd(
      "StarryNight", 
      n = NULL, 
      simulate = FALSE, 
      return_scores = TRUE
    )
  })
})

test_that("check_vangogh_cvd works with explicit n parameter", {
  skip_if_not_installed("colorspace")
  
  result <- check_vangogh_cvd(
    "StarryNight", 
    n = 3, 
    simulate = FALSE, 
    return_scores = TRUE
  )
  
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)  # 3 CVD types
})

test_that("check_vangogh_cvd returns correct data structure", {
  skip_if_not_installed("colorspace")
  
  result <- check_vangogh_cvd(
    "StarryNight", 
    simulate = FALSE, 
    return_scores = TRUE
  )
  
  # Check data frame structure
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)  # 3 CVD types
  expect_named(result, c("palette", "cvd_type", "min_distance", "accessibility"))
  
  # Check column types
  expect_type(result$palette, "character")
  expect_type(result$cvd_type, "character")
  expect_type(result$min_distance, "double")
  expect_type(result$accessibility, "character")
  
  # Check CVD types are correct (fix regex to match actual output)
  expect_true(all(grepl("Deuteranopia|Protanopia|Tritanopia", result$cvd_type)))
  
  # Check accessibility ratings are valid
  valid_ratings <- c("Poor", "Fair", "Good", "Excellent")
  expect_true(all(result$accessibility %in% valid_ratings))
  
  # Check distances are positive
  expect_true(all(result$min_distance >= 0))
})

test_that("check_vangogh_cvd accessibility ratings are consistent", {
  skip_if_not_installed("colorspace")
  
  result <- check_vangogh_cvd(
    "StarryNight", 
    simulate = FALSE, 
    return_scores = TRUE
  )
  
  # Check rating thresholds
  for (i in 1:nrow(result)) {
    dist <- result$min_distance[i]
    rating <- result$accessibility[i]
    
    if (dist < 10) {
      expect_equal(rating, "Poor")
    } else if (dist < 20) {
      expect_equal(rating, "Fair")
    } else if (dist < 40) {
      expect_equal(rating, "Good")
    } else {
      expect_equal(rating, "Excellent")
    }
  }
})

test_that("check_vangogh_cvd requires at least 2 colors", {
  skip_if_not_installed("colorspace")
  
  expect_error(
    check_vangogh_cvd("StarryNight", n = 1),
    "at least 2 colors"
  )
})

test_that("check_vangogh_cvd simulate parameter controls plotting", {
  skip_if_not_installed("colorspace")
  
  # With simulate = FALSE, should not produce plots (but prints report)
  expect_no_error({
    result <- check_vangogh_cvd(
      "StarryNight", 
      simulate = FALSE, 
      return_scores = TRUE
    )
  })
  
  # With simulate = TRUE, should produce output (but we can't easily test plots)
  # Just check it doesn't error
  expect_no_error({
    pdf(NULL)  # Send plots to null device
    check_vangogh_cvd(
      "StarryNight", 
      n = 3,
      simulate = TRUE, 
      return_scores = FALSE
    )
    dev.off()
  })
})

test_that("check_all_vangogh_cvd works for all palettes", {
  skip_if_not_installed("colorspace")
  
  result <- check_all_vangogh_cvd(simulate = FALSE)
  
  # Check structure
  expect_s3_class(result, "data.frame")
  expect_named(result, c("palette", "cvd_type", "min_distance", "accessibility"))
  
  # Should have 3 rows per palette (3 CVD types)
  n_palettes <- length(names(vangogh_palettes))
  expect_equal(nrow(result), n_palettes * 3)
  
  # Check all palettes are represented
  palettes_in_result <- unique(result$palette)
  expect_equal(length(palettes_in_result), n_palettes)
})

test_that("check_all_vangogh_cvd handles errors gracefully", {
  skip_if_not_installed("colorspace")
  
  # Should complete without stopping even if one palette fails
  expect_message(
    result <- check_all_vangogh_cvd(simulate = FALSE),
    NA  # No error messages expected
  )
  
  expect_s3_class(result, "data.frame")
})

test_that("get_cvd_safe_palettes returns valid palette names", {
  skip_if_not_installed("colorspace")
  
  safe_palettes <- get_cvd_safe_palettes(min_distance = 10)
  
  # Should return character vector
  expect_type(safe_palettes, "character")
  
  # All returned palettes should exist
  expect_true(all(safe_palettes %in% names(vangogh_palettes)))
  
  # Should have at least some palettes
  expect_true(length(safe_palettes) > 0)
})

test_that("get_cvd_safe_palettes filters by distance threshold", {
  skip_if_not_installed("colorspace")
  
  # Lower threshold should return more palettes
  safe_low <- get_cvd_safe_palettes(min_distance = 10)
  safe_high <- get_cvd_safe_palettes(min_distance = 25)
  
  expect_true(length(safe_low) >= length(safe_high))
})

test_that("get_cvd_safe_palettes handles high thresholds gracefully", {
  skip_if_not_installed("colorspace")
  
  # Very high threshold should return message
  expect_message(
    safe_palettes <- get_cvd_safe_palettes(min_distance = 1000),
    "No palettes found"
  )
  
  expect_equal(length(safe_palettes), 0)
  expect_type(safe_palettes, "character")
})

test_that("get_cvd_safe_palettes respects cvd_types parameter", {
  skip_if_not_installed("colorspace")
  
  # Test with only deuteranopia
  safe_deutan <- get_cvd_safe_palettes(
    min_distance = 15, 
    cvd_types = "deutan"
  )
  
  # Test with all types
  safe_all <- get_cvd_safe_palettes(
    min_distance = 15, 
    cvd_types = c("deutan", "protan", "tritan")
  )
  
  # More restrictive (all types) should return fewer or equal palettes
  expect_true(length(safe_all) <= length(safe_deutan))
})

test_that("CVD simulation produces different colors", {
  skip_if_not_installed("colorspace")
  
  result <- check_vangogh_cvd(
    "StarryNight", 
    simulate = FALSE, 
    return_scores = FALSE
  )
  
  # Check that CVD simulations produce actual results
  expect_type(result, "list")
  expect_named(result, c("deutan", "protan", "tritan"))
  
  # Each CVD type should have simulated colors
  for (cvd_type in names(result)) {
    expect_true("colors_simulated" %in% names(result[[cvd_type]]))
    expect_type(result[[cvd_type]]$colors_simulated, "character")
    expect_true(length(result[[cvd_type]]$colors_simulated) >= 2)
  }
})

test_that("Distance calculations are mathematically valid", {
  skip_if_not_installed("colorspace")
  
  result <- check_vangogh_cvd(
    "StarryNight", 
    simulate = FALSE, 
    return_scores = TRUE
  )
  
  # Distances should be non-negative
  expect_true(all(result$min_distance >= 0))
  
  # Distances should be finite
  expect_true(all(is.finite(result$min_distance)))
  
  # For a typical palette, distances should be reasonable (not 0, not huge)
  expect_true(all(result$min_distance < 200))  # CIELAB max ~100 per dimension
})

test_that("Function handles edge cases", {
  skip_if_not_installed("colorspace")
  
  # Test with minimum colors (n=2)
  expect_no_error({
    result <- check_vangogh_cvd(
      "StarryNight", 
      n = 2, 
      simulate = FALSE, 
      return_scores = TRUE
    )
  })
  
  expect_equal(nrow(result), 3)
  
  # Test with maximum colors (n=5, assuming 5 colors per palette)
  expect_no_error({
    result <- check_vangogh_cvd(
      "StarryNight", 
      n = 5, 
      simulate = FALSE, 
      return_scores = TRUE
    )
  })
  
  expect_equal(nrow(result), 3)
})

test_that("Integration test: full workflow", {
  skip_if_not_installed("colorspace")
  
  # 1. Check a single palette
  single_result <- check_vangogh_cvd(
    "StarryNight", 
    simulate = FALSE, 
    return_scores = TRUE
  )
  expect_s3_class(single_result, "data.frame")
  
  # 2. Check all palettes
  all_results <- check_all_vangogh_cvd(simulate = FALSE)
  expect_s3_class(all_results, "data.frame")
  
  # 3. Find safe palettes
  safe_palettes <- get_cvd_safe_palettes(min_distance = 15)
  expect_type(safe_palettes, "character")
  
  # 4. Verify safe palettes are actually accessible
  if (length(safe_palettes) > 0) {
    test_palette <- safe_palettes[1]
    test_result <- check_vangogh_cvd(
      test_palette, 
      simulate = FALSE, 
      return_scores = TRUE
    )
    
    # All distances should meet threshold
    expect_true(all(test_result$min_distance >= 15))
  }
})