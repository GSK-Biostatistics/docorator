# render html warns and removes page numbering

    Code
      render_html(as_docorator("This is a string", display_name = "page_number",
        header = fancyhead(fancyrow(right = doc_pagenum())), footer = fancyfoot(
          fancyrow(left = doc_pagenum())), save_object = FALSE))
    Message
      Page numbering with `doc_pagenum()` is not currently available for HTML rendering; removing it from the header.
      Page numbering with `doc_pagenum()` is not currently available for HTML rendering; removing it from the footer.
      v Document created at: '/private/var/folders/6t/0ndbz8j52bdbvv_r_xgjzcmh0000gp/T/RtmpAkM1je/file9bad742b8884/page_number.html'

