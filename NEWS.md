# docorator development version
* Use sessionInfo to check gt and ggplot versions between as_docorator run and render

Improvements
* Change logic in prep_obj_rtf to include any headers in the gt object as subtitles in the rtf
* Apply fontsize to gt title and subtitle 
* Set `footnote` argument in `as_docorator()` function to `NULL` as the default.

# docorator 0.5.0

Improvements
* Add `qmd` PDF engine
* Add RTF functionality for PNG and ggplot2 ready for when functionality becomes available in gt with `prep_obj_rtf`
* Rename `prep_obj` to `prep_obj_tex` and change input to docorator object
* The `display_name` argument in `as_docorator` is now required to ensure created files are explicitly defined

Bug fixes
* Fix issue where `fancyrow()` did not reject string vectors of length > 1 as arguments

# docorator 0.4.0

First open source release
