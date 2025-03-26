#' CDS ggplot2 Theme
#'
#' @return theme() object that can be applied to ggplot objects
#' @export
#'
#' @examples
#' library(ggplot2)
#' my_plot <- ggplot(mpg, aes(x = hwy, y = cty))
#' my_plot <- my_plot + theme_bw()  # Can layer multiple themes
#' my_plot <- my_plot + theme_cds()
#'
#' @importFrom ggplot2 theme element_text

theme_cds <- function() {
    theme(
      text = element_text(family = "Lato")
    )
}

