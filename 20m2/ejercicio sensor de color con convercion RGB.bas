' Configuraci?n inicial
symbol OE = B.0
symbol S0 = B.4
symbol S1 = B.5
symbol S2 = B.6
symbol S3 = c.5
symbol sensorOUT = pinC.2
symbol frecuencia = w1

symbol bucle = b0

symbol promedio = w0
symbol temp = w2
symbol temp2 = w6

' Variables para RGB
symbol rojo_valor = w3
symbol verde_valor = w4
symbol azul_valor = w5

' Valores para calibraci?n (ajustar seg?n tus lecturas)
symbol rojo_min = 25  ' Ajustar seg?n tus lecturas m?nimas para rojo
symbol rojo_max = 70  ' Ajustar seg?n tus lecturas m?ximas para rojo
symbol verde_min = 30 ' Ajustar seg?n tus lecturas m?nimas para verde
symbol verde_max = 90 ' Ajustar seg?n tus lecturas m?ximas para verde
symbol azul_min = 20  ' Ajustar seg?n tus lecturas m?nimas para azul
symbol azul_max = 80  ' Ajustar seg?n tus lecturas m?ximas para azul

symbol btn_inicio = pinc.0

main:

if btn_inicio = 1 then
	do 
		pause 50
	loop until btn_inicio = 0
	
	' Configurar escala al 100%
	high S0
	high S1
	
	promedio = 0
	pause 50

	' ===== LECTURA COLOR ROJO =====
	for b0 = 0 to 5
		' Leer filtro rojo
		low S2
		low S3
		pause 100
		count C.2, 10, frecuencia
		
		promedio = promedio + frecuencia
	next b0

	promedio = promedio / 5
	sertxd("Rojo frecuencia: ", #promedio, CR, LF)
	
	' Convertir a escala RGB (0-255)
	if promedio <= rojo_min then
		rojo_valor = 255
	elseif promedio >= rojo_max then
		rojo_valor = 0
	else
		' F?rmula de conversi?n: 255 - (valor - min) * 255 / (max - min)
		' Como estamos hablando de frecuencia, valores m?s bajos = color m?s intenso
		temp = promedio - rojo_min
		temp = temp * 255
		temp2 = rojo_max - rojo_min
		temp = temp / temp2
		rojo_valor = 255 - temp
	endif
	
	sertxd("Rojo RGB: ", #rojo_valor, CR, LF)
	PAUSE 50
	promedio = 0

	' ===== LECTURA COLOR VERDE =====
	for b0 = 0 to 5
		' Leer filtro verde
		high S2
		high S3
		pause 100
		count C.2, 10, frecuencia
		promedio = promedio + frecuencia
	next b0

	promedio = promedio / 5
	sertxd("Verde frecuencia: ", #promedio, CR, LF)
	
	' Convertir a escala RGB (0-255)
	if promedio <= verde_min then
		verde_valor = 255
	elseif promedio >= verde_max then
		verde_valor = 0
	else
		temp = promedio - verde_min
		temp = temp * 255
		temp2 = verde_max - verde_min
		temp = temp / temp2
		verde_valor = 255 - temp
	endif
	
	sertxd("Verde RGB: ", #verde_valor, CR, LF)
	PAUSE 50
	promedio = 0

	' ===== LECTURA COLOR AZUL =====
	for b0 = 0 to 5
		' Leer filtro azul
		low S2
		high S3
		pause 100
		count C.2, 10, frecuencia
		promedio = promedio + frecuencia
	next b0

	promedio = promedio / 5
	sertxd("Azul frecuencia: ", #promedio, CR, LF)
	
	' Convertir a escala RGB (0-255)
	if promedio <= azul_min then
		azul_valor = 255
	elseif promedio >= azul_max then
		azul_valor = 0
	else
		temp = promedio - azul_min
		temp = temp * 255
		temp2 = azul_max - azul_min
		temp = temp / temp2
		azul_valor = 255 - temp
	endif
	
	sertxd("Azul RGB: ", #azul_valor, CR, LF)
	
	' Mostrar color RGB completo
	sertxd("RGB: (", #rojo_valor, ",", #verde_valor, ",", #azul_valor, ")", CR, LF)
	PAUSE 50
endif

goto main