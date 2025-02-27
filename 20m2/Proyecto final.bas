symbol segment_a = C.1
symbol segment_b = C.4
symbol segment_c = B.3

symbol digito1 = B.4
symbol digito2 = C.5
symbol digito2 = C.4 

symbol sensores = pinC.6

symbol ADC = C.7

symbol SDA = B.5
symbol SCL = B.7

symbol start_btn = pinC.0
symbol reset_btn = pinC.1

symbol servoPeque = B.0
symbol servoGrand = B.1


symbol varDigito1 = b0
symbol varDigito2 = b1
symbol varDigito3 = b2
symbol varDigito4 = b3
varDigito1 = 0
varDigito2 = 0
varDigito3 = 0
varDigito4 = 0

symbol varADC = b4

symbol varSensor = b5

symbol seg = b6
symbol minu = b7
   symbol hora = b13
   symbol dia = w3
   symbol date = w4
   symbol mes = w5
   symbol ao = w6
   
symbol bucles for = b8

symbol pot_value = b9

symbol capturaSeg = b10
symbol CapturaMin = b11

symbol cuenta = b12
cuenta = 0

symbol ayuda1 = w0
symbol ayuda2 = w1
symbol ayuda3 = w2

	' S?mbolos para las posiciones del servo
symbol POS_0 = 100            ' Posici?n 0 grados (0.75ms)
symbol POS_90 = 150          ' Posici?n 90 grados (1.5ms)
symbol POS_180 = 200         ' Posici?n 180 grados (2.25ms)

	' S?mbolos para los rangos del potenci?metro
symbol RANGO_1 = 85          ' 255/3 = 85 (primer tercio)
symbol RANGO_2 = 170         ' 255*(2/3) = 170 (segundo tercio)

main:

    readadc ADC, pot_value

    ' Eval?a el rango y mueve el servo a la posici?n correspondiente
    if pot_value < RANGO_1 then
        ' Si est? en el primer tercio, mueve a 0 grados
        for b8 = 1 to 50
            pulsout servoGrand, POS_0
            pause 20
        next b8
    	varDigito4 = pot_value /1000
	varDigito3 = pot_value /100
	varDigito2 = pot_value / 10
	varDigito1 = pot_value % 10
	for b8 = 0 to 50
		if b3 > 0 then
			low digito4
			gosub MostrarDigito4
			pause 30
			high digito4
		endif
		if b2 > 0 then
			low digito3
			gosub MostrarDigito3
			pause 30
			high digito3
		endif
		if b1 >= 0 then
			low digito2
			gosub MostrarDigito2
			pause 30
			high digito2
		endif

	low digito1
	gosub MostrarDigito1
	pause 30
	high digito1
	next b8
    
    elseif pot_value < RANGO_2 then
        ' Si est? en el segundo tercio, mueve a 90 grados
        for b8 = 1 to 50
            pulsout servoGrand, POS_90
            pause 20
	  next b8
    	varDigito4 = pot_value /1000
	varDigito3 = pot_value /100
	varDigito2 = pot_value / 10
	varDigito1 = pot_value % 10
 	for b8 = 0 to 50
		if b3 > 0 then
			low digito4
			gosub MostrarDigito4
			pause 30
			high digito4
		endif
		if b2 > 0 then
			low digito3
			gosub MostrarDigito3
			pause 30
			high digito3
		endif

	low digito1
	gosub MostrarDigito1
	pause 30
	high digito1
	next b8
    
    else
        ' Si est? en el ?ltimo tercio, mueve a 180 grados
        for b8 = 1 to 50
            pulsout servoGrand, POS_180
            pause 20
	  next b8
    	varDigito4 = pot_value /1000
	varDigito3 = pot_value /100
	varDigito2 = pot_value / 10
	varDigito1 = pot_value % 10
 	for b8 = 0 to 50
		if b3 > 0 then
			low digito4
			gosub MostrarDigito4
			pause 30
			high digito4
		endif
		if b2 > 0 then
			low digito3
			gosub MostrarDigito3
			pause 30
			high digito3
		endif
		if b1 >= 0 then
			low digito2
			gosub MostrarDigito2
			pause 30
			high digito2
		endif

	low digito1
	gosub MostrarDigito1
	pause 30
	high digito1
	next b8
	
    endif
	
if start_btn = 1 then
	Sertxd("Start presionado",13,10)
	gosub WaitForReleaseCero
	Sertxd("Start liberado",13,10)
	
      for b8 = 1 to 50
		pulsout servoPeque, POS_0
		pause 20
        next b8
	Sertxd("Servo Movido",13,10)
	
	do
	if sensores = 0 then 
		inc cuenta 
			'parte funcionale ds3231
	      i2cslave %11010000,i2cfast,i2cbyte
	      hi2cin 0, (seg,minu,hora,dia,date,mes,ao)
	      pause 100
		capturaSeg = seg - capturaSeg
		capturaMin = minu - capturaMin
		pause 20
		Sertxd("cont = ", #cuenta,13,10)
		Sertxd("seg = ", #seg,13,10)
	endif
	'Precionando reset
	if reset_btn = 1 then
		Sertxd("Reset presionado",13,10)
		for b8 = 1 to 50
	            pulsout servoPeque, POS_90
	            pause 20
        	next b8
		cuenta = 0
		goto main 
	endif
	loop while cuenta < 4
	'calculos y despliegue de datos
	Sertxd("Tiempo en segundos: ", #capturaSeg," s", " minutos: ",#minu, 13,10)
	w0 = 50 * 10 / capturaSeg 
	Sertxd("Distancia cm: 50 cm", 13,10)
	w1 = w0/10
	w2 = w0 % 10
	Sertxd("Velocidad cm/ms: ", #w1, ".", #w2, "cm/s" , 13,10)
	
endif

	for b8 = 1 to 50
            pulsout servoPeque, POS_0
            pause 20
        next b8
cuenta = 0
goto main

WaitForReleaseCero:
    do
        pause 10
    loop until start_btn = 0
return

MostrarDigito1:
    select case b0
        case 0: low segment_a
            low segment_b
            low segment_c
            low segment_d
        case 1: low segment_a
            low segment_b
            low segment_c
            high segment_d
        case 2: low segment_a
            low segment_b
            high segment_c
            low segment_d
        case 3: low segment_a
            low segment_b
            high segment_c
            high segment_d
        case 4: low segment_a
            high segment_b
            low segment_c
            low segment_d
        case 5: low segment_a
            high segment_b
            low segment_c
            high segment_d
        case 6: low segment_a
            high segment_b
            high segment_c
            low segment_d
        case 7: low segment_a
            high segment_b
            high segment_c
            high segment_d
        case 8: high segment_a
            low segment_b
            low segment_c
            low segment_d
        case 9: high segment_a
            low segment_b
            low segment_c
            high segment_d
    endselect
return

MostrarDigito2:
    select case b1
        case 0: low segment_a
            low segment_b
            low segment_c
            low segment_d
        case 1: low segment_a
            low segment_b
            low segment_c
            high segment_d
        case 2: low segment_a
            low segment_b
            high segment_c
            low segment_d
        case 3: low segment_a
            low segment_b
            high segment_c
            high segment_d
        case 4: low segment_a
            high segment_b
            low segment_c
            low segment_d
        case 5: low segment_a
            high segment_b
            low segment_c
            high segment_d
        case 6: low segment_a
            high segment_b
            high segment_c
            low segment_d
        case 7: low segment_a
            high segment_b
            high segment_c
            high segment_d
        case 8: high segment_a
            low segment_b
            low segment_c
            low segment_d
        case 9: high segment_a
            low segment_b
            low segment_c
            high segment_d
    endselect
return

MostrarDigito3:
    select case b2
        case 0: low segment_a
            low segment_b
            low segment_c
            low segment_d
        case 1: low segment_a
            low segment_b
            low segment_c
            high segment_d
        case 2: low segment_a
            low segment_b
            high segment_c
            low segment_d
        case 3: low segment_a
            low segment_b
            high segment_c
            high segment_d
        case 4: low segment_a
            high segment_b
            low segment_c
            low segment_d
        case 5: low segment_a
            high segment_b
            low segment_c
            high segment_d
        case 6: low segment_a
            high segment_b
            high segment_c
            low segment_d
        case 7: low segment_a
            high segment_b
            high segment_c
            high segment_d
        case 8: high segment_a
            low segment_b
            low segment_c
            low segment_d
        case 9: high segment_a
            low segment_b
            low segment_c
            high segment_d
    endselect
return

MostrarDigito4:
    select case b3
        case 0: low segment_a
            low segment_b
            low segment_c
            low segment_d
        case 1: low segment_a
            low segment_b
            low segment_c
            high segment_d
        case 2: low segment_a
            low segment_b
            high segment_c
            low segment_d
        case 3: low segment_a
            low segment_b
            high segment_c
            high segment_d
        case 4: low segment_a
            high segment_b
            low segment_c
            low segment_d
        case 5: low segment_a
            high segment_b
            low segment_c
            high segment_d
        case 6: low segment_a
            high segment_b
            high segment_c
            low segment_d
        case 7: low segment_a
            high segment_b
            high segment_c
            high segment_d
        case 8: high segment_a
            low segment_b
            low segment_c
            low segment_d
        case 9: high segment_a
            low segment_b
            low segment_c
            high segment_d
    endselect
return