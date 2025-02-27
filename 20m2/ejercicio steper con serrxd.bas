symbol dir = B.0
symbol step1 = B.1
symbol sleep1 = B.2
symbol reset1 = B.3
symbol enable = B.4

symbol op1 = b0

symbol rst = pinC.7

main:

	high sleep1
	high reset1
	high enable
	
	serrxd op1
	
	high dir
	for b1 = 0 to op1
		
		high step1
		pause 66
		low step1
		pause 66
	
	next b1
	
	pause 66
	low dir
	pause 66
	next b0

' Comprobar si se presion? el bot?n de reset
if rst = 1 then
  let pinsB = %00000000  ' Apagar todos los LEDs
  do
      pause 10           ' Esperar hasta que se suelte el bot?n
  loop until pinC.7 = 0
endif

goto main