symbol ledB0 = B.0
symbol ledB1 = B.1
symbol ledB2 = B.2
symbol ledB3 = B.3
symbol ledB4 = B.4
symbol ledB5 = B.5
symbol ledB6 = B.6
symbol ledB7 = B.7

symbol rst = pinC.7
symbol test = pinC.6

symbol op1 = b0

main:

serrxd op1

select case op1
    case 0  
    	  high ledB0
	  pause 30
    case 1
        high ledB1
	  pause 30
    case 2 
        high ledB2
	  pause 30
    case 3
	  high ledB3
	  pause 30
    case 4
        high ledB4
	  pause 30
    case 5
        high ledB5
	  pause 30
    case 6
        high ledB6
	  pause 30
    case 7
        high ledB7
	  pause 30
    else
        let pinsB = %00000000  ' Apagar todos los LEDs
endselect

' Comprobar si se presion? el bot?n de reset
if rst = 1 then
  let pinsB = %00000000  ' Apagar todos los LEDs
  do
      pause 10           ' Esperar hasta que se suelte el bot?n
  loop until pinC.7 = 0
endif

' Comprobar si se presion? el bot?n de test
if test = 1 then
  do
	gosub secuencia
	wait 1
	gosub secuencia2
	' Esperar hasta que se suelte el bot?n
  loop until pinC.6 = 0
	let pinsB = %00000000  ' Apagar todos los LEDs
endif

goto main

secuencia:
	high ledB0
	low ledB7
      wait 1  
	high ledB1
	low ledB0
      wait 1  
	high ledB2
	low ledB1
      wait 1  
	high ledB3
	low ledB2
      wait 1  
	high ledB4
	low ledB3
      wait 1  
	high ledB5
	low ledB4
      wait 1  
	high ledB6
	low ledB5
      wait 1  
	high ledB7
	low ledB6
return
secuencia2:
	low ledB0
	high ledB7
      wait 1  
	low ledB7
	high ledB6
      wait 1  
	low ledB6
	high ledB5
      wait 1  
	low ledB5
	high ledB4
      wait 1  
	low ledB4
	high ledB3
      wait 1  
	low ledB3
	high ledB2
      wait 1  
	low ledB2
	high ledB1
      wait 1  
	low ledB1
	high ledB0
return