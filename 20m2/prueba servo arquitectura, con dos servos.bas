
symbol SERVO_PIN = b.0       ' Pin del servo
symbol SERVO_PIN2 = b.1
'symbol POT_PIN = C.7         ' Pin del potenci?metro
'symbol pot_value = w0         ' Variable para almacenar valor del ADC

	' S?mbolos para las posiciones del servo
symbol POS_0 = 100            ' Posici?n 0 grados (0.75ms)
symbol POS_90 = 150          ' Posici?n 90 grados (1.5ms)
symbol POS_180 = 200         ' Posici?n 180 grados (2.25ms)

	' S?mbolos para los rangos del potenci?metro
'symbol RANGO_1 = 80          ' 255/3 = 85 (primer tercio)
'symbol RANGO_2 = 165         ' 255*(2/3) = 170 (segundo tercio)

main:
    ' Lee el valor del potenci?metro
'    readadc POT_PIN, pot_value

    ' Eval?a el rango y mueve el servo a la posici?n correspondiente
'    if pot_value < RANGO_1 then
        ' Si est? en el primer tercio, mueve a 0 grados
        for b0 = 1 to 50
            pulsout SERVO_PIN, POS_180
		pulsout SERVO_PIN2, POS_180
            pause 20
        next b0
'    elseif pot_value < RANGO_2 then
        ' Si est? en el segundo tercio, mueve a 90 grados
        for b0 = 1 to 50
            pulsout SERVO_PIN, POS_90
		PULSOUT SERVO_PIN2, POS_90
            pause 20
        next b0
'    else
        ' Si est? en el ?ltimo tercio, mueve a 180 grados
'        for b0 = 1 to 50
'            pulsout SERVO_PIN, POS_180
'            pause 20
'        next b0
 '   endif
	

	
    goto main

'''''''''''''''''''''

'''''#picaxe 40x2

''''symbol servoPin = B.0
''''SYMBOL servoPin2 = B.1

''''init:
'    servo servoPin, 75      ; Inicializar servo en 90? (posici?n media)
'    servo servoPin2, 75      ; Inicializar servo en 90? (posici?n media)
'    pause 1000

'main:
'    ' Mover a 0 grados (aprox. valor 50)
'    servopos servoPin, 50
'    servopos servoPin2, 50
'    pause 1000

'    ' Mover a 90 grados (valor medio, 75)
'    servopos servoPin, 75
'    servopos servoPin2, 75
'    pause 1000

'    ' Mover a 180 grados (aprox. valor 100)
'    servopos servoPin, 100
 '   servopos servoPin, 100
  '  pause 1000

'goto main