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

symbol unidad = w0
symbol decena = w1
symbol centena = w2
symbol millar = w3

symbol x = w4

symbol i = b0
' Subrutina para esperar a que el bot?n sea liberado
WaitForRelease:
    do
        pause 10
    loop until start_button = 0 and stop_button = 0 and reset_button = 0
return

main:
    
    
    goto main

descomponerNumero:
    unidad = 0
    decena = 0
    centena = 0
    millar
    
    do while x >= 1000
	    x = x -1000
	    inc millar
loop
	do while x >= 100
	    x = x -100
	    inc centena
loop
	do while x >= 10
	    x = x -10
	    inc decena
loop
	do while x >= 1
	    x = x -1
	    inc unidad
loop
return

desplegarDatos:
	for b0 = 0 to 9
			
	next b0
	
return

' Subrutina para mostrar un n?mero en el display de 7 segmentos
MostrarDigito:
    select case b1
        case 0: low segment_a
            low segment_b
            low segment_c
            low segment_d
            low segment_e
            low segment_f
            high segment_g
        case 1: high segment_a
            low segment_b
            low segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 2: low segment_a
            low segment_b
            high segment_c
            low segment_d
            low segment_e
            high segment_f
            low segment_g
        case 3: low segment_a
            low segment_b
            low segment_c
            low segment_d
            high segment_e
            high segment_f
            low segment_g
        case 4: high segment_a
            low segment_b
            low segment_c
            high segment_d
            high segment_e
            low segment_f
            low segment_g
        case 5: low segment_a
            high segment_b
            low segment_c
            low segment_d
            high segment_e
            low segment_f
            low segment_g
        case 6: low segment_a
            high segment_b
            low segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 7: low segment_a
            low segment_b
            low segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 8: low segment_a
            low segment_b
            low segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 9: low segment_a
            low segment_b
            low segment_c
            low segment_d
            high segment_e
            low segment_f
            low segment_g
    endselect
return
