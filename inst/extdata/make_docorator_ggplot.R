
# create plot
ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
  ggplot2::geom_point() +
  ggplot2::labs(title = "title1", subtitle = "subtitle1", tag = "tag1", caption = "footnote1")

# save docorator object
as_docorator(
  x = ggplot1,
  display_loc = "inst/extdata",
  header = fancyhead(fancyrow(center = "this is the title"),
                     fancyrow(center = "this is the subtitle1"),
                     fancyrow(center = "this is the subtitle2")),
  footer = fancyfoot(fancyrow(left = "this is the docorator footnote")),
  display_name = "docorator_ggplot",
  save_object = TRUE)
