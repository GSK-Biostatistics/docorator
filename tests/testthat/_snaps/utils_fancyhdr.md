# Header and footer processes into latex

    Code
      hf_process("My first line")
    Message
      i Coercing `header` from <character> to <fancyhead> with 1 row
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}{My first line}\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}{\\phantom{}}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}{\\phantom{}}\\end{tabular}}"

---

    Code
      hf_process(c("Two", "Lines"))
    Message
      i Coercing `header` from <character> to <fancyhead> with 2 rows
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}{Two}\\\\{Lines}\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}{\\phantom{}}\\\\{\\phantom{}}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}{\\phantom{}}\\\\{\\phantom{}}\\end{tabular}}"

---

    Code
      hf_process(fancyhead(fancyrow(right = doc_pagenum()), fancyrow(left = "a",
        center = "b", right = "c"), fancyrow(left = "something very longgggggggggggggggggggg")))
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}{\\phantom{}}\\\\{a}\\\\{something very longgggggggggggggggggggg}\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}{\\phantom{}}\\\\{b}\\\\{\\phantom{}}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}{Page \\thepage\\ of \\pageref*{LastPage}}\\\\{c}\\\\{\\phantom{}}\\end{tabular}}"

---

    Code
      hf_process(fancyfoot(fancyrow(left = "something very longgggggggggggggggggggg"),
      fancyrow(right = "something else"), fancyrow(center = "middle")))
    Output
      [1] "\\fancyfoot[L]{\\begin{tabular}[b]{@{}l@{}}{something very longgggggggggggggggggggg}\\\\{\\phantom{}}\\\\{\\phantom{}}\\end{tabular}}\\fancyfoot[C]{\\begin{tabular}[b]{@{}c@{}}{\\phantom{}}\\\\{\\phantom{}}\\\\{middle}\\end{tabular}}\\fancyfoot[R]{\\begin{tabular}[b]{@{}r@{}}{\\phantom{}}\\\\{something else}\\\\{\\phantom{}}\\end{tabular}}"

# Footnote characters are escaped correctly

    Code
      pagenum
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}{Page \\thepage\\ of \\pageref*{LastPage}}\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}{\\phantom{}}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}{\\phantom{}}\\end{tabular}}"

# right of first fancyrow in fancyhead warns and is cleared for html

    Code
      result <- hf_process(header_with_right, engine = "html")
    Condition
      Warning in `process_rows()`:
      The `right` position of the first `fancyrow()` in a `fancyhead()` is reserved for page number printing in HTML-style PDF output and will be set to NA.

# Header and footer processes into html

    Code
      hf_process("My first line", engine = "html")
    Message
      i Coercing `header` from <character> to <fancyhead> with 1 row
    Output
      [1] "<div class=\"hf-row\"><span class=\"hf-left\">My first line</span><span class=\"hf-center\"></span><span class=\"hf-right\"></span></div>"

---

    Code
      hf_process(c("Two", "Lines"), engine = "html")
    Message
      i Coercing `header` from <character> to <fancyhead> with 2 rows
    Output
      [1] "<div class=\"hf-row\"><span class=\"hf-left\">Two</span><span class=\"hf-center\"></span><span class=\"hf-right\"></span></div>\n<div class=\"hf-row\"><span class=\"hf-left\">Lines</span><span class=\"hf-center\"></span><span class=\"hf-right\"></span></div>"

---

    Code
      hf_process(fancyhead(fancyrow(right = doc_pagenum()), fancyrow(left = "a",
        center = "b", right = "c"), fancyrow(left = "something very longgggggggggggggggggggg")),
      engine = "html")
    Condition
      Warning in `process_rows()`:
      The `right` position of the first `fancyrow()` in a `fancyhead()` is reserved for page number printing in HTML-style PDF output and will be set to NA.
    Output
      [1] "<div class=\"hf-row\"><span class=\"hf-left\"></span><span class=\"hf-center\"></span><span class=\"hf-right\"></span></div>\n<div class=\"hf-row\"><span class=\"hf-left\">a</span><span class=\"hf-center\">b</span><span class=\"hf-right\">c</span></div>\n<div class=\"hf-row\"><span class=\"hf-left\">something very longgggggggggggggggggggg</span><span class=\"hf-center\"></span><span class=\"hf-right\"></span></div>"

---

    Code
      hf_process(fancyfoot(fancyrow(left = "something very longgggggggggggggggggggg"),
      fancyrow(right = "something else"), fancyrow(center = "middle")), engine = "html")
    Output
      [1] "<div class=\"hf-row\"><span class=\"hf-left\">something very longgggggggggggggggggggg</span><span class=\"hf-center\"></span><span class=\"hf-right\"></span></div>\n<div class=\"hf-row\"><span class=\"hf-left\"></span><span class=\"hf-center\"></span><span class=\"hf-right\">something else</span></div>\n<div class=\"hf-row\"><span class=\"hf-left\"></span><span class=\"hf-center\">middle</span><span class=\"hf-right\"></span></div>"

