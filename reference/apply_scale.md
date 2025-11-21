# Apply scaling to gt objects

Apply scaling to gt objects

## Usage

``` r
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# Default S3 method
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# S3 method for class 'gt_tbl'
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# S3 method for class 'gt_group'
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)
```

## Arguments

- x:

  gt object

- fontsize:

  document font size

- tbl_scale:

  Boolean for whether or not to automatically scale table columns to fit
  display area. Defaults to TRUE. Note that this will overwrite scaling
  set in the table directly unless set to FALSE.

- tbl_stub_pct:

  percent of total width that should be dedicated to stub column(s). If
  more than 1 stub column then this is the total for both.

## Value

scaled gt object

## Examples

``` r
gt <- gt::exibble |>
gt::gt()

apply_scale(gt, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = "20%")


  

num
```

char

fctr

date

time

datetime

currency

row

group

1.111e-01

apricot

one

2015-01-15

13:35

2018-01-01 02:22

49.950

row_1

grp_a

2.222e+00

banana

two

2015-02-15

14:40

2018-02-02 14:33

17.950

row_2

grp_a

3.333e+01

coconut

three

2015-03-15

15:45

2018-03-03 03:44

1.390

row_3

grp_a

4.444e+02

durian

four

2015-04-15

16:50

2018-04-04 15:55

65100.000

row_4

grp_a

5.550e+03

NA

five

2015-05-15

17:55

2018-05-05 04:00

1325.810

row_5

grp_b

NA

fig

six

2015-06-15

NA

2018-06-06 16:11

13.255

row_6

grp_b

7.770e+05

grapefruit

seven

NA

19:10

2018-07-07 05:22

NA

row_7

grp_b

8.880e+06

honeydew

eight

2015-08-15

20:20

NA

0.440

row_8

grp_b
