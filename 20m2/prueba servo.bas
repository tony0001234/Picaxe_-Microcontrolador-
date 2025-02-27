
symbol servoGrand = B.1
'symbol ADC = pinC.7
'symbol pote = b0

'symbol servoPin = B.1       ' Pin de control para el servo
'symbol adcPin = C.7         ' Pin de entrada ADC para el potenci?metro
'symbol adcValue = w0        ' Variable para almacenar la lectura ADC
'symbol pulseWidth = w1      ' Variable para el ancho de pulso

'main:
'    readadc10 adcPin, adcValue         ' Leer el valor ADC (0 a 1023)

    ' Escalar el valor ADC a un ancho de pulso (100 a 200)
'    pulseWidth = 100 + adcValue * 100 / 1023

    ' Mantener el pulso durante 1 segundo (50 ciclos de 20 ms)
'    for b0 = 1 to 50
'        pulsout servoPin, pulseWidth   ' Enviar el pulso al servo
'        pause 20                       ' Espera de 20 ms
'    next b0

'    goto main               ' Repetir el ciclo


main:

'    servo servoGrand, 150   ' Inicializa el servo en el punto medio (aproximadamente 90?)
'    pause 1000            ' Espera 1 segundo en el centro'

    ' Mover a la posici?n de 0? aproximadamente
'    servopos servoGrand, 75'
'    pause 1000            ' Espera 1 segundo en la posici?n de 0?

    ' Mover a la posici?n de 180? aproximadamente
'    servopos servoGrand, 225
'    pause 1000            ' Espera 1 segundo en la posici?n de 180?

    ' Mover de vuelta al centro (90?)
'    servopos servoGrand, 150
'    pause 1000            ' Espera 1 segundo en el centro
	
'    do
'        readadc C.7, b0         ' Lee valor anal?gico (0-255)
'        'b1 = b0           ' Convierte a rango del servo (0-150)
'        servo B.4, b0
'	  Sertxd("ADC = ", #b0, 13,10)
'        pause 20
'    loop

    ' Posici?n 0? (pulso de 1 ms)
    pulsout servoGrand, 100  ' Enviar pulso de 1 ms (100 x 10 us)
    pause 20               ' Espera para completar el ciclo de 20 ms

    ' Posici?n 90? (pulso de 1.5 ms)
    pulsout servoGrand, 150  ' Enviar pulso de 1.5 ms (150 x 10 us)
    pause 20               ' Espera para completar el ciclo de 20 ms

    ' Posici?n 180? (pulso de 2 ms)
    pulsout servoGrand, 200  ' Enviar pulso de 2 ms (200 x 10 us)
    pause 20               ' Espera para completar el ciclo de 20 ms


	
goto main

'symbol servoPin = B.4       ' Pin de control para el servo
'symbol adcPin = C.7         ' Pin de entrada ADC para el potenci?metro
'symbol adcValue = w0        ' Variable para almacenar la lectura ADC
'symbol pulseWidth = w1      ' Variable para el ancho de pulso

'main:
    'readadc10 adcPin, adcValue         ' Leer el valor ADC (0 a 1023)

    ' Escalar el valor ADC a un ancho de pulso (100 a 200)
   ' pulseWidth = 100 + adcValue * 100 / 1023

    ' Enviar el pulso para controlar el servo
  '  sertxd("adc = ", #w1,13,10)
 '   pulsout servoPin, pulseWidth
'    pause 20                ' Espera de 20 ms para el ciclo del servo

'    goto main               ' Repetir el ciclo
