.onAttach <- function(libname, pkgname){
  showtext::showtext_auto()
  sysfonts::font_add('Assistant', regular = './fonts/Assistant-Regular.ttf')
  sysfonts::font_add("Roboto", regular = './fonts/Roboto-Regular.ttf')
  sysfonts::font_add("Average", regular = './fonts/Average-Regular.ttf')
  sysfonts::font_add('Cochineal', regular = './fonts/Cochineal-Roman.otf' )
}


