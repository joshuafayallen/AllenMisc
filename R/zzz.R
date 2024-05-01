.onAttach <- function(libname, pkgname){
  cli::cli_alert_info("Loading fonts for ggplot theme")
  showtext::showtext_auto()
  sysfonts::font_add_google("Assistant", "Assistant")
  sysfonts::font_add_google("Roboto Condensed", "Roboto Condensed")
  sysfonts::font_add_google("Average", "Average")
}

