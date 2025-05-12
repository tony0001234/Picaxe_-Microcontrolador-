
' Definici?n de pines de control
symbol dir = d.2    ' Direcci?n del motor
symbol step1 =d.3  ' Pulso para el paso
symbol enable = c.4 ' Habilita el driver


symbol i = b2  ' Variable de iteraci?n
low enable  ' Habilita el driver
	
main:

	
	high dir  ' Configura la direcci?n hacia adelante
    for i = 1 to 160  ' 10 pasos reales * 16 microsteps (porque est?s en 1/16)
	    	HIGH step1  ' Pulso corto pero claro para el driver
       	pause 5  ' Tiempo suficiente para estabilidad
		low step1
		pause 5
    next i

    ' Peque?a pausa antes de cambiar direcci?n
    pause 100  

    ' Mover 10 pasos hacia atr?s
    low dir  ' Configura la direcci?n hacia atr?s
    for i = 1 to 160  ' 10 pasos reales * 16 microsteps
        HIGH step1  ' Pulso corto pero claro para el driver
       	pause 5  ' Tiempo suficiente para estabilidad
		low step1
		pause 5
    next i

    pause 100  ' Peque?a espera antes de repetir

    goto main  ' Repite indefinidamente