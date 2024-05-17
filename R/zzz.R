.onAttach <- function(libname, pkgname){
  cli::cli_alert_info("Loading fonts for ggplot theme")
  showtext::showtext_auto()
  sysfonts::font_add('Assistant', regular = 'Assistant-Regular.ttf')
  sysfonts::font_add("Roboto", regular = 'Roboto-Regular.ttf')
  sysfonts::font_add("Average", regular = 'Average-Regular.ttf')
}


