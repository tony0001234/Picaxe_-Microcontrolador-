symbol secs     = b0
symbol mins     = b1
symbol hour     = b2
symbol dow      = b3 : symbol chkdow   = b9
symbol day      = b4 : symbol chkday   = b10
symbol month    = b5 : symbol chkmonth = b11
symbol year     = b6 : symbol chkyear  = b12
symbol century  = b7
symbol control  = b8 : symbol chkctrl  = b13

  hi2csetup i2cmaster, %11010000, i2cslow, i2cbyte

  century = $20
  year    = $24
  month   = $10
  day     = $24
  dow     = $05
  hour    = $20
  mins    = $05
  secs    = $22
  control = $04

  hi2cout 0, (secs, mins, hour, dow, day, month, year)
  hi2cout $0E, (control,0)
  pause 50

  hi2cin 3, (chkdow, chkday, chkmonth, chkyear)
  if chkdow   <> dow     then fail
  if chkday   <> day     then fail
  if chkmonth <> month   then fail
  if chkyear  <> year    then fail

ok:
  sertxd("Time set okay",cr,lf)
  pause 1000
  goto ok

fail:
  sertxd("Time setting failed",cr,lf)
  pause 1000
  goto fail

