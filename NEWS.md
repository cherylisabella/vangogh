# vangogh 0.1.3

## New Features
* **Color Vision Deficiency (CVD) Assessment Tools**
  - Added `check_vangogh_cvd()` to simulate how palettes appear under different types of colour blindness (*deuteranopia, protanopia, tritanopia*) with visual plots and quantitative accessibility scores.
  - Added `check_all_vangogh_cvd()` for batch checking all palettes and generating comprehensive CVD reports.
  - Added `get_cvd_safe_palettes()` to filter palettes that meet accessibility thresholds for colourblind users.
  - Added pre-computed `vangogh_cvd_scores` dataset for quick accessibility lookups without requiring the **colorspace** package.
  - Added `vangogh_palette_info_with_cvd()` to enhance palette information with CVD accessibility data.
  - Added `print_cvd_badge()` for generating markdown badges showing palette accessibility ratings.
  - Added `summarize_cvd_accessibility()` to create summary tables of CVD metrics across all palettes.

## Implementation Details
* CVD assessment uses **CIELAB color space** for perceptually uniform distance calculations.
* All CVD functions use optional dependencies (**colorspace**) in `Suggests`, not `Imports`.
* Functions include graceful error handling for missing packages.
* Pre-computed data allows users to access CVD scores without installing **colorspace**.
* **Migration from colorblindr to colorspace**
  - Replaced deprecated **colorblindr** package with **colorspace** for CVD simulations.
  - Updated `check_palette()`, `viz_palette()`, and `compare_palettes()` to use `colorspace::deutan()`, `colorspace::protan()`, and `colorspace::tritan()`.
  - Implemented manual faceted visualizations to replace `colorblindr::cvd_grid()` functionality.
  - All CVD simulations now use the actively maintained **colorspace** package available on CRAN.
## Documentation
* Added comprehensive documentation for all CVD functions with examples.
* Added 20+ unit tests for CVD functionality with proper error handling.
* All functions include `@importFrom` declarations for CRAN compliance.
## Bug Fixes
* Fixed namespace imports for base R functions (`graphics`, `stats`, `utils`).
* Improved handling of `NULL` parameters in palette functions.
* Enhanced error messages for missing dependencies.

---

# vangogh 0.1.2
## Major Refactor
* **Major refactor** of the package structure and core functionality:
  - Rewrote all `R/` scripts for clarity, consistency, and CRAN compliance.
  - Deleted obsolete scripts and consolidated related functions.
  - Updated palette and theme handling to support new variants and features.

## Palette Accessibility Enhancements
* `palette_accessibility.R` upgraded:
  - `vangogh_palette_info()` and `vangogh_colors()` now optionally return HCL hue/chroma/luminance metadata when **colorspace** is installed.
  - Added `vangogh_suggest()` to recommend palettes based on required number of colours.
  - Added `vangogh_export()` for exporting palettes as JSON or CSV.
  - Rewrote `compare_palettes()` for facet-style comparison with improved `.data` safety.

## Theme Improvements
* `theme_vangogh()` now supports variants: `"classic"`, `"light"`, `"dark"`, `"sketch"`.

## Functionality Updates
* `safe_vangogh_palette()`, `viz_palette()`, `check_palette()` refined for colourblind simulation and consistent API.
* `vangogh_palette()` retains discrete and continuous interpolation support.
* Added examples and updated documentation throughout `man/` files.

## Other
* README fully updated with new functions, examples, and badges.
* License clarified: copyright 2022 Cheryl Isabella Lim.

---

# vangogh 0.1.1
* Initial CRAN submission.
