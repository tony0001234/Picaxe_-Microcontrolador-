symbol dirSalida = B.0
symbol step1 = B.1
'symbol sleep1 = B.2
'symbol reset1 = B.3
symbol enable = B.4
symbol vel1 = B.5
symbol vel2 = B.6
symbol vel3 = B.7

symbol topeSup = pinC.1
symbol topeInf = pinC.2
symbol DireEntrada = pinC.3
symbol velMas = pinC.4
symbol velmenos = pinC.5

symbol monitorVelocidad = b0
symbol monitorDireccion = b1
	monitorVelocidad = 1
	monitorDireccion = 1

main:

	'high sleep1
	'high reset1
	high enable
	
	if velMas = 1 then 
		monitorVelocidad = monitorVelocidad +1
		pause 10
	endif

	if velmenos = 1 then 
		monitorVelocidad = monitorVelocidad -1
		pause 10
	endif 
	
	if monitorVelocidad > 3 then
		monitorVelocidad = 1
		pause 10
	endif
	
	if monitorVelocidad < 1 then
		monitorVelocidad = 3
		pause 10
	endif
	
	select case monitorVelocidad 
		case 1: high vel1
		low vel2
		low vel3
		case 2: high vel1
		high vel2
		low vel3
		case 3: high vel1
		high vel2
		high vel3
	endselect
	
	if topeSup = 1 then
		gosub esperarcambiodire
		select case monitorDireccion
			case 1: high dirSalida
			monitorDireccion = 2
			case 2: low dirSalida
			monitorDireccion = 1
		endselect
		pause 10
	endif

	if topeInf = 1 then
		gosub esperarcambiodire
		select case monitorDireccion
			case 1: high dirSalida
			monitorDireccion = 2
			case 2: low dirSalida
			monitorDireccion = 1
		endselect
		pause 10
	endif
	
	if DireEntrada = 1 then
		select case monitorDireccion
			case 1: high dirSalida
			monitorDireccion = 2
			case 2: low dirSalida
			monitorDireccion = 1
		endselect
	endif
	
	select case monitorVelocidad
		case 1: gosub pasos
		case 2: gosub pasos2
		case 3: gosub pasos3
	endselect
goto main

esperarcambiodire:
    do
        pause 10
    loop until DireEntrada = 1
return

pasos:
	for b1 = 0 to 10
	
		high step1
		pause 66
		low step1
		pause 66
	
	next b1
return

pasos2:
	for b1 = 0 to 10
	
		high step1
		pause 120
		low step1
		pause 120
	
	next b1
return

pasos3:
	for b1 = 0 to 10
	
		high step1
		pause 180
		low step1
		pause 180
	
	next b1
return