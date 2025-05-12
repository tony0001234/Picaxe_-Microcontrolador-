#picaxe 40x2

symbol led1 = a.0
symbol led2 = a.5
symbol led3 = d.1
symbol led4 = d.2
symbol led5 = c.4
symbol led6 = b.7

main:

pause 500

high led1
high led2
high led3
high led4
high led5
high led6

pause 500

low led1
low led2
low led3
low led4
low led5
low led6

goto main