# Header and footer processes into latex

    Code
      hf_process("My first line")
    Message
      i Coercing `header` from <character> to <fancyhead> with 1 row
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}My first line\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}\\phantom{}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}\\phantom{}\\end{tabular}}"

---

    Code
      hf_process(c("Two", "Lines"))
    Message
      i Coercing `header` from <character> to <fancyhead> with 2 rows
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}Two\\\\Lines\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}\\phantom{}\\\\\\phantom{}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}\\phantom{}\\\\\\phantom{}\\end{tabular}}"

---

    Code
      hf_process(fancyhead(fancyrow(right = doc_pagenum()), fancyrow(left = "a",
        center = "b", right = "c"), fancyrow(left = "something very longgggggggggggggggggggg")))
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}\\phantom{}\\\\a\\\\something very longgggggggggggggggggggg\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}\\phantom{}\\\\b\\\\\\phantom{}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}Page \\thepage\\ of \\pageref*{LastPage}\\\\c\\\\\\phantom{}\\end{tabular}}"

---

    Code
      hf_process(fancyfoot(fancyrow(left = "something very longgggggggggggggggggggg"),
      fancyrow(right = "something else"), fancyrow(center = "middle")))
    Output
      [1] "\\fancyfoot[L]{\\begin{tabular}[b]{@{}l@{}}something very longgggggggggggggggggggg\\\\\\phantom{}\\\\\\phantom{}\\end{tabular}}\\fancyfoot[C]{\\begin{tabular}[b]{@{}c@{}}\\phantom{}\\\\\\phantom{}\\\\middle\\end{tabular}}\\fancyfoot[R]{\\begin{tabular}[b]{@{}r@{}}\\phantom{}\\\\something else\\\\\\phantom{}\\end{tabular}}"

# Footnote characters are escaped correctly

    Code
      pagenum
    Output
      [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}Page \\thepage\\ of \\pageref*{LastPage}\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}\\phantom{}\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}\\phantom{}\\end{tabular}}"

