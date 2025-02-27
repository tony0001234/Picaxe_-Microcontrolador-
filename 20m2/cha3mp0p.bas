symbol pot1 = b0
symbol pot2 = b1

symbol ledIgual = B.0
symbol ledMayor = B.1
symbol ledmenor = B.2

main:

Readadc b.3, b0
Readadc b.4, b1
sertxd("ADC1 = ", #b0, "ADC2 = ", #b1, 13,10)
pause 1000

if b0 = b1 then
	high ledmenor
	low ledIgual
	low ledMayor
	pause 500
elseif b0 > b1 then
	high ledMayor
	low ledIgual
	low ledmenor
	pause 500
else 
	high ledIgual
	low ledmenor
	low ledMayor
	pause 500
endif

goto main

