# theme_vangogh.R - variants
#' Theme inspired by Van Gogh (variants)
#' @param base_size numeric base font size
#' @param base_family font family
#' @param variant one of "classic", "light", "dark", "sketch"
#' @export
theme_vangogh <- function(base_size = 12, base_family = "", variant = c("classic", "light", "dark", "sketch")) {
  variant <- match.arg(variant)

  if (variant == "dark") {
    th <- ggplot2::theme_void(base_size = base_size, base_family = base_family) +
      ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = "#1F1F1F", color = NA),
        panel.background = ggplot2::element_rect(fill = "#1F1F1F", color = NA),
        axis.text = ggplot2::element_text(color = "#E0E0E0"),
        axis.title = ggplot2::element_text(color = "#E0E0E0", face = "bold"),
        plot.title = ggplot2::element_text(color = "#FFFFFF", face = "bold", size = base_size * 1.2),
        panel.grid = ggplot2::element_line(color = "#3A3A3A", linewidth = 0.3)
      )
  } else if (variant == "light") {
    th <- ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
      ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = "#FCFBF7", color = NA),
        panel.grid.major = ggplot2::element_line(color = "#E7E2CC", linewidth = 0.3),
        panel.grid.minor = ggplot2::element_blank(),
        axis.title = ggplot2::element_text(face = "plain", color = "#3A4A5A")
      )
  } else if (variant == "sketch") {
    th <- ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
      ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = "#FFFDF6", color = "#E8DDB8", linewidth = 1.2, linetype = "dashed"),
        panel.grid.major = ggplot2::element_line(color = "#EBDDBA", linewidth = 0.25),
        axis.title = ggplot2::element_text(face = "italic", color = "#3F3F3F"),
        plot.title = ggplot2::element_text(face = "bold.italic", size = base_size * 1.2)
      )
  } else {
    # classic
    th <- ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
      ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = "#FFF8E7", color = NA),
        panel.grid.major = ggplot2::element_line(color = "#DDC07A", linewidth = 0.3),
        panel.grid.minor = ggplot2::element_blank(),
        axis.title = ggplot2::element_text(face = "bold", color = "#2E4057"),
        plot.title = ggplot2::element_text(face = "bold", size = base_size * 1.2),
        plot.subtitle = ggplot2::element_text(size = base_size),
        legend.background = ggplot2::element_rect(fill = "#FFF8E7", color = NA),
        legend.key = ggplot2::element_rect(fill = "#FFF8E7", color = NA)
      )
  }

  th
}
