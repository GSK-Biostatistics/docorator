# apply a gt function to a gt_group

apply a gt function to a gt_group

## Usage

``` r
apply_to_gt_group(x, func, args, call = rlang::caller_env())
```

## Arguments

- x:

  gt group object

- func:

  string with function name

- args:

  named list of function arguments with gt_tbl or gt_group as first arg

- call:

  caller env

## Examples

``` r
gt_tbl <- gt::exibble|> gt::gt()
gt_group <- gt::gt_group(gt_tbl, gt_tbl)

func <- gt::tab_options
arg_list_group <- list(page.header.use_tbl_headings = c(TRUE))

apply_to_gt_group(gt_group, func,arg_list_group)
#> <div id="eexombwkke" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>#eexombwkke table {
#>   font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #eexombwkke thead, #eexombwkke tbody, #eexombwkke tfoot, #eexombwkke tr, #eexombwkke td, #eexombwkke th {
#>   border-style: none;
#> }
#> 
#> #eexombwkke p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #eexombwkke .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 16px;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #eexombwkke .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #eexombwkke .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #eexombwkke .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #eexombwkke .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #eexombwkke .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #eexombwkke .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #eexombwkke .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #eexombwkke .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #eexombwkke .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #eexombwkke .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #eexombwkke .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #eexombwkke .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #eexombwkke .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #eexombwkke .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #eexombwkke .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #eexombwkke .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #eexombwkke .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #eexombwkke .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #eexombwkke .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #eexombwkke .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #eexombwkke .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #eexombwkke .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #eexombwkke .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #eexombwkke .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #eexombwkke .gt_left {
#>   text-align: left;
#> }
#> 
#> #eexombwkke .gt_center {
#>   text-align: center;
#> }
#> 
#> #eexombwkke .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #eexombwkke .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #eexombwkke .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #eexombwkke .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #eexombwkke .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #eexombwkke .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #eexombwkke .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #eexombwkke .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #eexombwkke .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #eexombwkke .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #eexombwkke .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #eexombwkke .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #eexombwkke .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #eexombwkke div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> </style>
#>   <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <thead>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="num">num</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="char">char</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="fctr">fctr</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="date">date</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="time">time</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="datetime">datetime</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="currency">currency</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="row">row</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="group">group</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="num" class="gt_row gt_right">1.111e-01</td>
#> <td headers="char" class="gt_row gt_left">apricot</td>
#> <td headers="fctr" class="gt_row gt_center">one</td>
#> <td headers="date" class="gt_row gt_right">2015-01-15</td>
#> <td headers="time" class="gt_row gt_right">13:35</td>
#> <td headers="datetime" class="gt_row gt_right">2018-01-01 02:22</td>
#> <td headers="currency" class="gt_row gt_right">49.950</td>
#> <td headers="row" class="gt_row gt_left">row_1</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">2.222e+00</td>
#> <td headers="char" class="gt_row gt_left">banana</td>
#> <td headers="fctr" class="gt_row gt_center">two</td>
#> <td headers="date" class="gt_row gt_right">2015-02-15</td>
#> <td headers="time" class="gt_row gt_right">14:40</td>
#> <td headers="datetime" class="gt_row gt_right">2018-02-02 14:33</td>
#> <td headers="currency" class="gt_row gt_right">17.950</td>
#> <td headers="row" class="gt_row gt_left">row_2</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">3.333e+01</td>
#> <td headers="char" class="gt_row gt_left">coconut</td>
#> <td headers="fctr" class="gt_row gt_center">three</td>
#> <td headers="date" class="gt_row gt_right">2015-03-15</td>
#> <td headers="time" class="gt_row gt_right">15:45</td>
#> <td headers="datetime" class="gt_row gt_right">2018-03-03 03:44</td>
#> <td headers="currency" class="gt_row gt_right">1.390</td>
#> <td headers="row" class="gt_row gt_left">row_3</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">4.444e+02</td>
#> <td headers="char" class="gt_row gt_left">durian</td>
#> <td headers="fctr" class="gt_row gt_center">four</td>
#> <td headers="date" class="gt_row gt_right">2015-04-15</td>
#> <td headers="time" class="gt_row gt_right">16:50</td>
#> <td headers="datetime" class="gt_row gt_right">2018-04-04 15:55</td>
#> <td headers="currency" class="gt_row gt_right">65100.000</td>
#> <td headers="row" class="gt_row gt_left">row_4</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">5.550e+03</td>
#> <td headers="char" class="gt_row gt_left">NA</td>
#> <td headers="fctr" class="gt_row gt_center">five</td>
#> <td headers="date" class="gt_row gt_right">2015-05-15</td>
#> <td headers="time" class="gt_row gt_right">17:55</td>
#> <td headers="datetime" class="gt_row gt_right">2018-05-05 04:00</td>
#> <td headers="currency" class="gt_row gt_right">1325.810</td>
#> <td headers="row" class="gt_row gt_left">row_5</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">NA</td>
#> <td headers="char" class="gt_row gt_left">fig</td>
#> <td headers="fctr" class="gt_row gt_center">six</td>
#> <td headers="date" class="gt_row gt_right">2015-06-15</td>
#> <td headers="time" class="gt_row gt_right">NA</td>
#> <td headers="datetime" class="gt_row gt_right">2018-06-06 16:11</td>
#> <td headers="currency" class="gt_row gt_right">13.255</td>
#> <td headers="row" class="gt_row gt_left">row_6</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">7.770e+05</td>
#> <td headers="char" class="gt_row gt_left">grapefruit</td>
#> <td headers="fctr" class="gt_row gt_center">seven</td>
#> <td headers="date" class="gt_row gt_right">NA</td>
#> <td headers="time" class="gt_row gt_right">19:10</td>
#> <td headers="datetime" class="gt_row gt_right">2018-07-07 05:22</td>
#> <td headers="currency" class="gt_row gt_right">NA</td>
#> <td headers="row" class="gt_row gt_left">row_7</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">8.880e+06</td>
#> <td headers="char" class="gt_row gt_left">honeydew</td>
#> <td headers="fctr" class="gt_row gt_center">eight</td>
#> <td headers="date" class="gt_row gt_right">2015-08-15</td>
#> <td headers="time" class="gt_row gt_right">20:20</td>
#> <td headers="datetime" class="gt_row gt_right">NA</td>
#> <td headers="currency" class="gt_row gt_right">0.440</td>
#> <td headers="row" class="gt_row gt_left">row_8</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>   </tbody>
#>   
#> </table>
#> </div>
#> <div id="ulbfdpbcyv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>#ulbfdpbcyv table {
#>   font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #ulbfdpbcyv thead, #ulbfdpbcyv tbody, #ulbfdpbcyv tfoot, #ulbfdpbcyv tr, #ulbfdpbcyv td, #ulbfdpbcyv th {
#>   border-style: none;
#> }
#> 
#> #ulbfdpbcyv p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 16px;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #ulbfdpbcyv .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #ulbfdpbcyv .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #ulbfdpbcyv .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #ulbfdpbcyv .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #ulbfdpbcyv .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #ulbfdpbcyv .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #ulbfdpbcyv .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #ulbfdpbcyv .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ulbfdpbcyv .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #ulbfdpbcyv .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #ulbfdpbcyv .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #ulbfdpbcyv .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ulbfdpbcyv .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #ulbfdpbcyv .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ulbfdpbcyv .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #ulbfdpbcyv .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ulbfdpbcyv .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ulbfdpbcyv .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ulbfdpbcyv .gt_left {
#>   text-align: left;
#> }
#> 
#> #ulbfdpbcyv .gt_center {
#>   text-align: center;
#> }
#> 
#> #ulbfdpbcyv .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #ulbfdpbcyv .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #ulbfdpbcyv .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #ulbfdpbcyv .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #ulbfdpbcyv .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #ulbfdpbcyv .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #ulbfdpbcyv .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #ulbfdpbcyv .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #ulbfdpbcyv .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #ulbfdpbcyv .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #ulbfdpbcyv .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #ulbfdpbcyv .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #ulbfdpbcyv .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #ulbfdpbcyv div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> </style>
#>   <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <thead>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="num">num</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="char">char</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="fctr">fctr</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="date">date</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="time">time</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="datetime">datetime</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="currency">currency</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="row">row</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="group">group</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="num" class="gt_row gt_right">1.111e-01</td>
#> <td headers="char" class="gt_row gt_left">apricot</td>
#> <td headers="fctr" class="gt_row gt_center">one</td>
#> <td headers="date" class="gt_row gt_right">2015-01-15</td>
#> <td headers="time" class="gt_row gt_right">13:35</td>
#> <td headers="datetime" class="gt_row gt_right">2018-01-01 02:22</td>
#> <td headers="currency" class="gt_row gt_right">49.950</td>
#> <td headers="row" class="gt_row gt_left">row_1</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">2.222e+00</td>
#> <td headers="char" class="gt_row gt_left">banana</td>
#> <td headers="fctr" class="gt_row gt_center">two</td>
#> <td headers="date" class="gt_row gt_right">2015-02-15</td>
#> <td headers="time" class="gt_row gt_right">14:40</td>
#> <td headers="datetime" class="gt_row gt_right">2018-02-02 14:33</td>
#> <td headers="currency" class="gt_row gt_right">17.950</td>
#> <td headers="row" class="gt_row gt_left">row_2</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">3.333e+01</td>
#> <td headers="char" class="gt_row gt_left">coconut</td>
#> <td headers="fctr" class="gt_row gt_center">three</td>
#> <td headers="date" class="gt_row gt_right">2015-03-15</td>
#> <td headers="time" class="gt_row gt_right">15:45</td>
#> <td headers="datetime" class="gt_row gt_right">2018-03-03 03:44</td>
#> <td headers="currency" class="gt_row gt_right">1.390</td>
#> <td headers="row" class="gt_row gt_left">row_3</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">4.444e+02</td>
#> <td headers="char" class="gt_row gt_left">durian</td>
#> <td headers="fctr" class="gt_row gt_center">four</td>
#> <td headers="date" class="gt_row gt_right">2015-04-15</td>
#> <td headers="time" class="gt_row gt_right">16:50</td>
#> <td headers="datetime" class="gt_row gt_right">2018-04-04 15:55</td>
#> <td headers="currency" class="gt_row gt_right">65100.000</td>
#> <td headers="row" class="gt_row gt_left">row_4</td>
#> <td headers="group" class="gt_row gt_left">grp_a</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">5.550e+03</td>
#> <td headers="char" class="gt_row gt_left">NA</td>
#> <td headers="fctr" class="gt_row gt_center">five</td>
#> <td headers="date" class="gt_row gt_right">2015-05-15</td>
#> <td headers="time" class="gt_row gt_right">17:55</td>
#> <td headers="datetime" class="gt_row gt_right">2018-05-05 04:00</td>
#> <td headers="currency" class="gt_row gt_right">1325.810</td>
#> <td headers="row" class="gt_row gt_left">row_5</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">NA</td>
#> <td headers="char" class="gt_row gt_left">fig</td>
#> <td headers="fctr" class="gt_row gt_center">six</td>
#> <td headers="date" class="gt_row gt_right">2015-06-15</td>
#> <td headers="time" class="gt_row gt_right">NA</td>
#> <td headers="datetime" class="gt_row gt_right">2018-06-06 16:11</td>
#> <td headers="currency" class="gt_row gt_right">13.255</td>
#> <td headers="row" class="gt_row gt_left">row_6</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">7.770e+05</td>
#> <td headers="char" class="gt_row gt_left">grapefruit</td>
#> <td headers="fctr" class="gt_row gt_center">seven</td>
#> <td headers="date" class="gt_row gt_right">NA</td>
#> <td headers="time" class="gt_row gt_right">19:10</td>
#> <td headers="datetime" class="gt_row gt_right">2018-07-07 05:22</td>
#> <td headers="currency" class="gt_row gt_right">NA</td>
#> <td headers="row" class="gt_row gt_left">row_7</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>     <tr><td headers="num" class="gt_row gt_right">8.880e+06</td>
#> <td headers="char" class="gt_row gt_left">honeydew</td>
#> <td headers="fctr" class="gt_row gt_center">eight</td>
#> <td headers="date" class="gt_row gt_right">2015-08-15</td>
#> <td headers="time" class="gt_row gt_right">20:20</td>
#> <td headers="datetime" class="gt_row gt_right">NA</td>
#> <td headers="currency" class="gt_row gt_right">0.440</td>
#> <td headers="row" class="gt_row gt_left">row_8</td>
#> <td headers="group" class="gt_row gt_left">grp_b</td></tr>
#>   </tbody>
#>   
#> </table>
#> </div>
```
