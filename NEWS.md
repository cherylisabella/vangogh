# vangogh 0.1.2

* **Major refactor** of the package structure and core functionality:
  - Rewrote all `R/` scripts for clarity, consistency, and CRAN compliance.
  - Deleted obsolete scripts and consolidated related functions.
  - Updated palette and theme handling to support new variants and features.

* **Palette Accessibility Enhancements**
  - `palette_accessibility.R` upgraded:
    - `vangogh_palette_info()` and `vangogh_colors()` now optionally return HCL hue/chroma/luminance metadata when `colorspace` is installed.
    - Added `vangogh_suggest()` to recommend palettes based on required number of colours.
    - Added `vangogh_export()` for exporting palettes as JSON or CSV.
    - Rewrote `compare_palettes()` for facet-style comparison with improved `.data` safety.

* **Theme Improvements**
  - `theme_vangogh()` now supports variants: `"classic"`, `"light"`, `"dark"`, `"sketch"`.

* **Functionality Updates**
  - `safe_vangogh_palette()`, `viz_palette()`, `check_palette()` refined for colourblind simulation and consistent API.
  - `vangogh_palette()` retains discrete and continuous interpolation support.
  - Added examples and updated documentation throughout `man/` files.

* **CRAN Compliance**
  - `DESCRIPTION` updated with all imports and methods.
  - Removed `tests/` references for this feature release.
  - All R CMD check notes/warnings/errors resolved except timestamp verification note.

* **Other**
  - README fully updated with new functions, examples, and badges.
  - License clarified: copyright 2022 Cheryl Isabella Lim.
  
# vangogh 0.1.1

* Initial CRAN submission