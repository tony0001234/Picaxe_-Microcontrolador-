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
symbol stop_button = pinC.1
symbol reset_button = pinC.2

symbol unidad = b0
symbol decena = b1
symbol centena = b2

main:
    if start_button = 1 then
        gosub WaitForRelease  ' Esperar a que se suelte el bot?n
	  Sertxd("Inicio de conteo", 13,10)
        for b2 = 0 to 9
		  for b1 = 0 to 9
			  for b0 = 0 to 9
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
				Sertxd("Variales b0, b1, b2 mostrando accsi: ", 13,10)
				Sertxd(b0, 13,10)
				Sertxd(b1, 13,10)
				Sertxd(b2, 13,10)
				
				Sertxd("Variales b0, b1, b2 mostrando el valor numerico: ", 13,10)
				Sertxd(#b2,#b1,#b0, 13,10)
				if stop_button = 1 then
				        gosub WaitForRelease  ' Esperar a que se suelte el bot?n
				elseif reset_button = 1 then
				        gosub WaitForRelease  ' Esperar a que se suelte el bot?n
				        b1 = 0
				        b2 = 0
					  b3 = 0
					  high digit1
					  high digit2
					  high digit3
					  goto main
				endif
			next b0
		next b1
	next b2
	Sertxd("Fin del conteo.")
	pause 500
	b1 = 0
      b2 = 0
	b3 = 0
	high digit1
	high digit2
	high digit3 
    endif
goto main

' Subrutina para esperar a que el bot?n sea liberado
WaitForRelease:
    do
        pause 10
    loop until start_button = 0 and stop_button = 0 and reset_button = 0
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
