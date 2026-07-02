# Brand typography ------------------------------------------------------------

# _brand.yml names the typeface "Source Sans Pro"; Adobe's current release of
# the same typeface is "Source Sans 3", which is the name sysfonts uses to
# register it. Same typeface, current name.
cds_font <- "Source Sans 3"

# Load the bundled brand font once per session and enable showtext glyph
# rendering, so the font works with knitr's default graphics device without any
# per-report chunk options. Idempotent; safe if the font files are missing
# (warns, returns FALSE). The brand's Semibold (600) is mapped to the "bold"
# face, so the bold elements that theme titles use render as Semibold rather
# than a heavier weight.
register_cds_fonts <- function() {
  if (cds_font %in% sysfonts::font_families()) {
    showtext::showtext_auto()
    return(invisible(TRUE))
  }
  ok <- tryCatch(
    {
      sysfonts::font_add(
        cds_font,
        regular = system.file(
          "font", "SourceSans3", "SourceSans3-Regular.otf",
          package = "cds"
        ),
        bold = system.file(
          "font", "SourceSans3", "SourceSans3-Semibold.otf",
          package = "cds"
        ),
        italic = system.file(
          "font", "SourceSans3", "SourceSans3-It.otf",
          package = "cds"
        ),
        bolditalic = system.file(
          "font", "SourceSans3", "SourceSans3-SemiboldIt.otf",
          package = "cds"
        )
      )
      TRUE
    },
    error = function(e) {
      warning(
        "Could not load brand font '", cds_font, "' (", conditionMessage(e),
        "); graphs will use the default sans font.",
        call. = FALSE
      )
      FALSE
    }
  )
  if (ok) {
    showtext::showtext_auto()
    # Match showtext's text sizing to the resolution knitr renders figures at.
    dpi <- if (requireNamespace("knitr", quietly = TRUE)) {
      knitr::opts_chunk$get("dpi")
    } else {
      NULL
    }
    showtext::showtext_opts(dpi = if (is.null(dpi)) 96 else dpi)
  }
  invisible(ok)
}

#' CDS ggplot2 Theme
#'
#' theme_bw() in the CDS brand typeface (Source Sans 3), with Semibold titles.
#' Falls back to the default sans font if the brand font could not be loaded.
#'
#' @param base_size base font size, in points
#' @param base_family base font family
#'
#' @return theme() object that can be applied to ggplot objects
#' @export
#'
#' @examples
#' library(ggplot2)
#' my_plot <- ggplot(mpg, aes(x = hwy, y = cty))
#' my_plot <- my_plot + theme_cds()
#'
#' @importFrom ggplot2 theme_bw theme element_text
theme_cds <- function(base_size = 11, base_family = cds_font) {
  if (!register_cds_fonts()) base_family <- ""
  theme_bw(base_size = base_size, base_family = base_family) +
    theme(
      plot.title = element_text(face = "bold"),
      plot.subtitle = element_text(colour = "grey30"),
      plot.caption = element_text(colour = "grey40")
    )
}
