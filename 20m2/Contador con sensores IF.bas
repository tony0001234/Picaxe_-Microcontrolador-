symbol segment_a = B.0
symbol segment_b = B.1
symbol segment_c = B.2
symbol segment_d = B.3
symbol segment_e = B.4
symbol segment_f = B.5
symbol segment_g = B.6

symbol digit1 = B.7      ' Control del primer d?gito
symbol digit2 = C.7      ' Control del segundo d?gito
symbol digit3 = C.5      ' Control del tercer d?gito
symbol digit4 = C.4      ' Control del cuarto d?gito

symbol start_button = pinC.0
symbol sensorIni = pinC.1
symbol sensorFin = pinC.6
'symbol sensorFin = pinC.3

symbol voltSensor1 = C.3
symbol voltSensor2 = C.2

symbol unidad = b0
symbol decena = b1
symbol centena = b2

symbol bucle = b3

symbol contador3 = w1
symbol contador2 = w2
symbol contador1 = w4

symbol ayuda1 = w5
symbol ayuda2 = w6
symbol ayuda3 = w7
symbol ayuda4 = w8
symbol ayuda5 = w9
symbol ayuda6 = w10

symbol ayuda7 = w11
symbol ayuda8 = w12

symbol distancia = 50
symbol distancia_m = 100

main:
if start_button = 1 then
	high voltSensor1
	high voltSensor2
	w0 = 0
	w1 = 0
	w2 = 0
	w3 = 0
	w4 = 0
	b1 = 0
      b2 = 0
	b3 = 0
	gosub WaitForReleaseCero
	
	do
	  if sensorIni = 0 then
	  Sertxd("Inicio de conteo", 13,10)
        for b2 = 0 to 9
		  for b1 = 0 to 9
			  for b0 = 0 to 9
				
				
				'Sertxd("Variales b0, b1, b2 mostrando accsi: ", 13,10)
				'Sertxd(b0, 13,10)
				'Sertxd(b1, 13,10)
				'Sertxd(b2, 13,10)
				
				pause 15
				'inc w3
				if sensorFin = 0 then
					'for b3 = 0 to 3
					'pause 500
					
					for b3 = 0 to 50
						if b2 > 0 then
							low digit3
							gosub MostrarDigito3
							pause 30
							high digit3
						endif
					
						if b1 >= 0 then
							low digit2
							gosub MostrarDigito2
							pause 30
							high digit2
						endif
				  	
					low digit1
					gosub MostrarDigito1
					pause 30
					high digit1
					
					next b3
					
					pause 100
					
					w11 = b1*10
					w12 = b2*100
					w3 = w12 + w11 + b0
					Sertxd("Tiempo en ms: ", #w3," ms", 13,10)
					w1 = distancia * 10 / w3
					Sertxd("Distancia cm: 50 cm", 13,10)
					w9 = w1/10
					w10 = w1 % 10
					Sertxd("Velocidad cm/ms: ", #w9, ".", #w10, "cm/ms" , 13,10)
					
					
					Sertxd(13,10)
					
					w2 = w3*10 /1000
					w5 = w2/10
					w6 = w2 % 10
					Sertxd("Tiempo en s: ", #w5, ".", #w6, " s", 13,10)
					Sertxd("Distancia m: 1 m", 13,10)
					w4 = 100 * 10 /w3
					w7 = w4/10
					w8 = w4 % 10
					Sertxd("velocidad m/s: ", #w7, ".", #w8, " m/s", 13,10)
					
					
					
					
					
					goto final
				endif
			next b0
		next b1
	next b2
    endif
loop until start_button = 1
	
	final:
	Sertxd("Fin del conteo.")
	pause 500
	b1 = 0
      b2 = 0
	b3 = 0
	high digit1
	high digit2
	high digit3 
	
	low voltSensor1
	low voltSensor2
endif

	
goto main

' Subrutina para esperar a que el bot?n sea liberado
WaitForReleaseCero:
    do
        pause 10
    loop until start_button = 0
return
WaitForReleaseOne:
    do
        pause 10
    loop until sensorFin = 1
return

MostrarDigito1:
    select case b0
        case 0: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            low segment_g
        case 1: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 2: high segment_a
            high segment_b
            low segment_c
            high segment_d
            high segment_e
            low segment_f
            high segment_g
        case 3: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            low segment_f
            high segment_g
        case 4: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            high segment_f
            high segment_g
        case 5: high segment_a
            low segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
        case 6: high segment_a
            low segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 7: high segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 8: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 9: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
    endselect
return


MostrarDigito2:
    select case b1
        case 0: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            low segment_g
        case 1: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 2: high segment_a
            high segment_b
            low segment_c
            high segment_d
            high segment_e
            low segment_f
            high segment_g
        case 3: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            low segment_f
            high segment_g
        case 4: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            high segment_f
            high segment_g
        case 5: high segment_a
            low segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
        case 6: high segment_a
            low segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 7: high segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 8: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 9: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
    endselect
return

MostrarDigito3:
    select case b2
        case 0: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            low segment_g
        case 1: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 2: high segment_a
            high segment_b
            low segment_c
            high segment_d
            high segment_e
            low segment_f
            high segment_g
        case 3: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            low segment_f
            high segment_g
        case 4: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            high segment_f
            high segment_g
        case 5: high segment_a
            low segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
        case 6: high segment_a
            low segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 7: high segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 8: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 9: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
    endselect
return
