# CDS/SNC logo branding for ggplot graphs.
#
# add_cds_logo() overlays the CDS/SNC logo in a corner of a plot using
# cowplot::draw_image, which preserves the logo's aspect ratio automatically.
# The result is a cowplot drawing that knitr renders (and embed-resources
# base64-inlines) like any other figure - no external image file ends up
# referenced by the HTML.
#
# The logo is the bilingual CDS/SNC mark; cds_logo_path() randomly returns the
# English-first or French-first variant on each call, by design - so different
# graphs in a report may show different languages, and a re-render may flip
# them. This is cosmetic only and does not affect any data in the report.
#
# By default the plain CDS/SNC square is used; set canada_wordmark = TRUE for
# the square + Canada wordmark lockup.

# Randomly pick the English-first or French-first logo bundled with the
# package, so graphs within a report may differ in language by design.
# canada_wordmark picks the square + Canada wordmark lockup; otherwise the
# plain CDS/SNC square.
cds_logo_path <- function(canada_wordmark = FALSE) {
  variants <- if (canada_wordmark) {
    c("EN_Square+CANADA.jpg", "FR_Square+CANADA.jpg")
  } else {
    c("cds-snc.png", "snc-cds.png")
  }
  present <- system.file("img", variants, package = "cds")
  present <- present[nzchar(present)]
  if (length(present) > 0) return(sample(present, 1))
  stop(
    "CDS logo not found (", paste(variants, collapse = " / "), ")",
    call. = FALSE
  )
}

#' Add the CDS/SNC logo to a ggplot
#'
#' Overlays the bilingual CDS/SNC logo in a corner of a plot, flush against the
#' edge. Preserves the logo's aspect ratio.
#'
#' @param plot a ggplot object
#' @param position one of "top-right" (default), "bottom-left", "top-left",
#'   "bottom-right", or "all"
#' @param height logo height as a fraction of the figure; width is generous
#'   so the height is what constrains the logo, keeping it small and
#'   undistorted
#' @param canada_wordmark if TRUE, use the square + Canada wordmark lockup
#'   instead of the plain CDS/SNC square
#'
#' @return a cowplot drawing
#' @export
#'
#' @importFrom ggplot2 theme calc_element margin
#' @importFrom grid unit
add_cds_logo <- function(
    plot,
    position = c(
      "top-right", "bottom-left",
      "top-left", "bottom-right",
      "all"
    ),
    height = 0.13,
    canada_wordmark = FALSE) {
  position <- match.arg(position)

  corners <- list(
    "top-right" = list(
      x = 0.995, y = 0.995,
      hjust = 1, vjust = 1, halign = 1, valign = 1
    ),
    "bottom-left" = list(
      x = 0.005, y = 0.005,
      hjust = 0, vjust = 0, halign = 0, valign = 0
    ),
    "top-left" = list(
      x = 0.005, y = 0.995,
      hjust = 0, vjust = 1, halign = 0, valign = 1
    ),
    "bottom-right" = list(
      x = 0.995, y = 0.005,
      hjust = 1, vjust = 0, halign = 1, valign = 0
    )
  )

  if (position == "all") {
    placements <- corners
  } else {
    placements <- corners[position]
  }

  # Add margin on the sides where the logo will sit so it lands in whitespace
  # rather than overlapping the panel. The margin matches the logo height.
  margin_pt <- grid::unit(height * 55, "pt")
  sides <- unique(sub("-.*", "", names(placements)))
  current_margin <- ggplot2::calc_element("plot.margin", plot$theme)
  if (is.null(current_margin)) current_margin <- ggplot2::margin(5.5, 5.5, 5.5, 5.5)
  if ("top" %in% sides) current_margin[1] <- current_margin[1] + margin_pt
  if ("bottom" %in% sides) current_margin[3] <- current_margin[3] + margin_pt
  plot <- plot + ggplot2::theme(plot.margin = current_margin)

  result <- cowplot::ggdraw(plot)
  for (corner in placements) {
    result <- result +
      cowplot::draw_image(
        cds_logo_path(canada_wordmark),
        x = corner$x, y = corner$y,
        hjust = corner$hjust, vjust = corner$vjust,
        halign = corner$halign,
        valign = corner$valign,
        width = 0.4, height = height
      )
  }
  result
}

#' Add a watermark caption to a ggplot
#'
#' A light watermark in the bottom-right corner with an optional report name
#' and date. Uses the brand font when available, grey at a small size so it
#' stays readable but unobtrusive.
#'
#' @param plot a ggplot object
#' @param report_name optional report name to prefix the watermark; when
#'   blank (the default) the watermark shows just the date
#' @param date a string like "June 25, 2026" or a Date object (formatted
#'   automatically)
#'
#' @return a cowplot drawing
#' @export
#'
#' @importFrom ggplot2 theme calc_element margin
#' @importFrom grid unit
add_watermark <- function(plot, report_name = "", date = Sys.Date()) {
  if (inherits(date, "Date")) date <- format(date, "%B %e, %Y")
  date <- trimws(date)
  label <- if (nzchar(report_name)) paste0(report_name, " // ", date) else date
  font_family <- if (register_cds_fonts()) cds_font else ""
  current_margin <- ggplot2::calc_element("plot.margin", plot$theme)
  if (is.null(current_margin)) current_margin <- ggplot2::margin(5.5, 5.5, 5.5, 5.5)
  current_margin[3] <- current_margin[3] + grid::unit(5, "pt")
  plot <- plot + ggplot2::theme(plot.margin = current_margin)
  cowplot::ggdraw(plot) +
    cowplot::draw_text(
      label,
      x = 0.99, y = 0.01,
      hjust = 1, vjust = 0,
      size = 7,
      colour = "grey65",
      family = font_family
    )
}
