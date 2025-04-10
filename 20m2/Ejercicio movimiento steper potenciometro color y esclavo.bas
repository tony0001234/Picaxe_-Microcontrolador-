symbol btn_inicio = pinC.0
symbol btn_parada = pinC.1

symbol potenciometro = pinC.2

symbol dir = B.7
symbol pinA = B.6
symbol pinB = B.5

symbol valorPOT = b0
symbol maximo1 = 85
symbol maximo2 = 170
symbol maximo3 = 205

inicio:

if btn_inicio = 1 then 
	do
		pause 50
	loop until btn_inicio = 0
	
	do
		HIGH dir
		pause 50
		
		readadc c.2, valorPOT
		
		if valorPOT < maximo1 then
			LOW pinA
			HIGH pinB
			pause 50
		elseif valorPOT > maximo1 and valorPOT < maximo2 then
			HIGH pinA
			lOW pinB
			pause 50
		elseif valorPOT > maximo2 then
			HIGH pinA
			HIGH pinB
			pause 50
		endif
		
	loop until btn_parada = 1
else
	LOW pinA
	LOW pinB
	pause 50
	goto inicio
endif

goto inicio