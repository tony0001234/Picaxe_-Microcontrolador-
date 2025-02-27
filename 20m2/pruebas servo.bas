	 'M?todo 1: PULSOUT b?sico con ADC
 	'Lee potenci?metro en C.1 y controla servo en B.1
'main1:
'    symbol POT_PIN = C.7        ' Pin C.1 para el potenci?metro
'    symbol SERVO_PIN = B.1       ' Pin B.1 para el servo
'    symbol pot_value = w0      ' Variable para lectura ADC
'    symbol servo_pos = w1      ' Variable para posici?n servo
    
'bucle1:
'    readadc C.7, pot_value       ' Lee el potenci?metro (0-255)
    ' Convierte valor ADC (0-255) a pulso servo (100-200)
'    servo_pos = 100 + pot_value * 100/ 1023
    
'    high SERVO_PIN                    ' Inicia pulso
'    pulsout SERVO_PIN, servo_pos      ' Genera pulso
'    pause 20                            ' Espera para siguiente ciclo
'    goto bucle1
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''    
    
	' M?todo 2: PULSOUT con filtrado de lectura ADC
'main2:
'    symbol POT_PIN = C.7
'    symbol SERVO_PIN = B.1
'    symbol pot_raw = w0        ' Lectura cruda ADC
'    symbol pot_filtered = w1   ' Lectura filtrada
'    symbol last_pos = w2       ' ?ltima posici?n v?lida
    
'bucle2:
'    readadc C.7, pot_raw
    ' Filtro simple para suavizar movimientos
'    pot_filtered = pot_raw + last_pos / 2
'    last_pos = pot_filtered
    
    ' Convierte y aplica l?mites
'    if pot_filtered < 100 then
'        pot_filtered = 100
'    elseif pot_filtered > 200 then
'        pot_filtered = 200
'   endif
    
'    high SERVO_PIN
'    pulsout SERVO_PIN, pot_filtered
'    pause 20
'    goto bucle2

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' M?todo 3: PWM por software con ADC y promediado
'main3:
'    symbol POT_PIN = C.7
'    symbol SERVO_PIN = B.1
'    symbol pot_sum = w0        ' Suma para promedio
'    symbol pot_avg = w1        ' Promedio de lecturas
'    symbol i = b0              ' Contador para promedio
   
'bucle3:
    ' Toma m?ltiples lecturas para mayor estabilidad
'    let pot_sum = 0
'    for i = 1 to 4
'        readadc C.7, b1
'        pot_sum = pot_sum + b1
'        pause 1
'    next i
'    pot_avg = pot_sum / 4
    
    ' Convierte a tiempo de pulso (100-200)
'    pot_avg = 100 + pot_avg *  100/1023  '100 + pot_value * 100/ 1023
    
    ' Genera pulso PWM
'    high SERVO_PIN
'    for i = 1 to pot_avg
'        pause 1              ' Delay de 10?s
'    next i
'    low SERVO_PIN
    
'    pause 18                ' Completa ciclo de 20ms
'    goto bucle3

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' M?todo 4: PWM con temporizador y ADC interpolado
'main4:
'    symbol POT_PIN = C.7
'    symbol SERVO_PIN = B.1
'    symbol pot_value = w0
'    symbol target_pos = w1
'    symbol current_pos = w2
'    symbol TMR0 = w3
    
'bucle4:
'    readadc C.7, pot_value
    ' Interpola posici?n para movimiento suave
'    target_pos = 100 + pot_value * 100/1023  '100 + pot_value * 100/ 1023
    
    ' Mueve gradualmente hacia la posici?n objetivo
'    if current_pos < target_pos then
'        inc current_pos
'    elseif current_pos > target_pos then
'        dec current_pos
'    endif
    
    ' Genera pulso usando temporizador
'    let TMR0 = 0
'    high SERVO_PIN
'    do
'        if TMR0 >= current_pos then
'            low SERVO_PIN
'            exit
'        endif
'    loop
    
'    pause 18
'    goto bucle4

'''''''''''''''''''''''''''''''''''''''''''''''''''''

' M?todo 5: Control de m?ltiples servos con m?ltiples potenci?metros
'main5:
'    symbol POT1_PIN = C.7        ' Primer potenci?metro en C.1
    'symbol POT2_PIN = 2        ' Segundo potenci?metro en C.2
'    symbol SERVO1_PIN = B.1      ' Primer servo en B.1
    'symbol SERVO2_PIN = 2      ' Segundo servo en B.2
'    symbol pos1 = w0
    'symbol pos2 = w1
    
'bucle5:
    ' Lee y controla primer servo
'    readadc C.7, b0
'    pos1 = 100 + b0 * 100/1023		'100 + pot_value * 100/ 1023
'    high SERVO1_PIN
'    pulsout SERVO1_PIN, pos1
'    low SERVO1_PIN
    
    ' Lee y controla segundo servo
    'readadc C.POT2_PIN, b0
    'pos2 = 100 + (b0 / 2.55)
    'high B.SERVO2_PIN
    'pulsout B.SERVO2_PIN, pos2
    'low B.SERVO2_PIN
    
'    pause 18
'    goto bucle5

''''''''''''''''''''''''''''''''''''''''

'symbol servoPin = B.1  ' Pin de control del servo

'main:
    ' Gira el servo a una posici?n cercana a 0 grados
'    for b0 = 1 to 50
'        pulsout servoPin, 75    ' Enviar un pulso de 0.75 ms (ajusta seg?n el servo)
'        pause 20                ' Espera 20 ms antes del siguiente pulso
'    next b0
'    pause 1000                  ' Espera 1 segundo en esta posici?n

    ' Gira el servo a la posici?n central (aproximadamente 90 grados)
'    for b0 = 1 to 50
'        pulsout servoPin, 150   ' Enviar un pulso de 1.5 ms (ajusta seg?n el servo)
'        pause 20                ' Espera 20 ms antes del siguiente pulso
'    next b0
'    pause 1000                  ' Espera 1 segundo en esta posici?n

    ' Gira el servo a una posici?n cercana a 180 grados
'    for b0 = 1 to 50
'        pulsout servoPin, 225   ' Enviar un pulso de 2.25 ms (ajusta seg?n el servo)
'        pause 20                ' Espera 20 ms antes del siguiente pulso
'    next b0
'    pause 1000                  ' Espera 1 segundo en esta posici?n

'    goto main  ' Repite el ciclo

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	' Programa que posiciona el servo en 3 posiciones seg?n el rango del potenci?metro
	' Usando ADC en C.1 y Servo en B.1

symbol SERVO_PIN = B.1         ' Pin del servo
symbol POT_PIN = C.7         ' Pin del potenci?metro
symbol pot_value = w0         ' Variable para almacenar valor del ADC

	' S?mbolos para las posiciones del servo
symbol POS_0 = 100            ' Posici?n 0 grados (0.75ms)
symbol POS_90 = 150          ' Posici?n 90 grados (1.5ms)
symbol POS_180 = 200         ' Posici?n 180 grados (2.25ms)

	' S?mbolos para los rangos del potenci?metro
symbol RANGO_1 = 80          ' 255/3 = 85 (primer tercio)
symbol RANGO_2 = 165         ' 255*(2/3) = 170 (segundo tercio)

main:
    ' Lee el valor del potenci?metro
    readadc POT_PIN, pot_value

    ' Eval?a el rango y mueve el servo a la posici?n correspondiente
    if pot_value < RANGO_1 then
        ' Si est? en el primer tercio, mueve a 0 grados
        for b0 = 1 to 50
            pulsout SERVO_PIN, POS_0
            pause 20
        next b0
    elseif pot_value < RANGO_2 then
        ' Si est? en el segundo tercio, mueve a 90 grados
        for b0 = 1 to 50
            pulsout SERVO_PIN, POS_90
            pause 20
        next b0
    else
        ' Si est? en el ?ltimo tercio, mueve a 180 grados
        for b0 = 1 to 50
            pulsout SERVO_PIN, POS_180
            pause 20
        next b0
    endif
	

	
    goto main

'''''''''''''''''''''''''''''''''''''''''''''''''''

' Versi?n alternativa con hist?resis para evitar oscilaciones
'symbol HISTERESIS = 5        ' Valor de hist?resis para evitar oscilaciones

'main_alt:
'    readadc POT_PIN, pot_value
    
    ' Variables para mantener la ?ltima posici?n
'    symbol ultima_pos = b1
    
    ' Eval?a rangos con hist?resis
'    if pot_value < RANGO_1 - HISTERESIS then
'        if ultima_pos != 1 then
'            for b0 = 1 to 50
'                pulsout SERVO_PIN, POS_0
'                pause 20
'            next b0
'            let ultima_pos = 1
'        endif
'    elseif pot_value > RANGO_1 + HISTERESIS and pot_value < RANGO_2 - HISTERESIS then
'        if ultima_pos != 2 then
 '           for b0 = 1 to 50
 '               pulsout SERVO_PIN, POS_90
'                pause 20
'            next b0
'            let ultima_pos = 2
'        endif
'    elseif pot_value > RANGO_2 + HISTERESIS then
'        if ultima_pos != 3 then
'            for b0 = 1 to 50
'                pulsout SERVO_PIN, POS_180
'                pause 20
'            next b0
'            let ultima_pos = 3
'        endif
'    endif
    
'    goto main_alt