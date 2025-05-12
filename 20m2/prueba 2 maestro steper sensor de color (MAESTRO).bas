#picaxe 20m2
#terminal 9600
' === Pines de control y configuraci?n ===
symbol btn_parada = pinB.7   ' Bot?n de parada de emergencia
symbol btn_finalizar = pinB.6 ' Bot?n para finalizar el proceso
symbol btn_inicio = pinB.5    ' Bot?n de inicio

symbol signal = c.7
symbol signal_recibida = pinC.6
' Pines para el sensor de color TCS3200
symbol S0 = C.4
symbol S1 = C.5             ' Cambiado para evitar conflicto con B.5
symbol S2 = C.2             ' Cambiado para evitar conflicto con B.6
symbol S3 = C.3
symbol sensorOUT = pinC.1   ' Entrada de frecuencia del sensor de color

symbol out1 = c.0
symbol out2 = b.0
symbol out3 = c.7

symbol in1 = pinc.6
symbol in2 = pinb.2
symbol in3 = pinb.3

symbol led_estado = b.4

' --- Variables para la detecci?n de color mejorada ---
symbol rojo = w0            ' Valor crudo rojo
symbol verde = w1           ' Valor crudo verde
symbol azul = w2            ' Valor crudo azul
symbol blanco = w3          ' Valor de referencia blanco
symbol rojo_cal = w4        ' Valores calibrados
symbol verde_cal = w5
symbol azul_cal = w6
symbol max_valor = w7       ' Para normalizaci?n

symbol temp = w8
symbol temp2 = w9
symbol temp3 = w10

symbol i = b0
' Variables para comunicaci?n bidireccional
symbol contador_objetos = b10    ' Contador de objetos detectados por IR
symbol estado_esclavo = b11      ' Estado del esclavo (0=normal, 1=parada)
symbol comando_actual = b13      ' Comando actual enviado al esclavo
symbol ultimo_comando = b14      ' ?ltimo comando enviado al esclavo
symbol tiempo_espera = b15       ' Tiempo de espera para respuesta
symbol comando_recibido = w11

symbol contador = b1

' === Configuraci?n inicial ===
inicio:
  setfreq m8                ' Configurar frecuencia a 8MHz para estabilidad
  WAIT 1
  SERTXD("ALIMENTACION MAESTRO: OK",13,10)
  contador_objetos = 0      ' Inicializar contador

  ' Configurar pines de salida para LEDs
  low out1
  low out2
  low out3
 ' high led_estado
goto espera_inicio

espera_inicio:
  if btn_inicio = 1 then 
    ' Esperar a que se suelte el bot?n para evitar rebotes
    do : pause 50 : loop until btn_inicio = 0
    SERTXD("BOTON INICIO: OK",13,10)

	sertxd ("Mensaje enviado: Iniciar", CR, LF)
	do
		high out1
		high out2
		high out3
	loop until in1 = 0 and in2 = 1 and in3 = 0
	pause 100
	low out1
	low out2
	low out3
	
	IF in3 = 1 then
		DO
			PAUSE 50
			high out1
			low out2
			low out3
		LOOP UNTIL in3 = 0
		SERTXD("ALIMENTACION ESCLAVO: OK",13,10)
		SERTXD("INICIO ESCLAVO: OK",13,10)
	endif
	
    goto ciclo_principal
    endif

goto espera_inicio

ciclo_principal:
pause 50
  ' Verificar bot?n de parada de emergencia
if btn_parada = 0 then
	  do 
		  pause 50
	loop until btn_parada = 1
	  SERTXD("BOTON PARADA: OK",13,10)
	 estado_esclavo = 1      ' Marcar estado de parada
	
	do
		 high out1
		 high out2
		 low out3
	 loop until in1 = 0 and in2 = 1 and in3 = 0
	 pause 100
	 low out1
	 low out2
	 low out3
    sertxd ("Boton parada precionado", 13,10)

endif

if in1 = 1 and in2 = 1 and in3 = 1 then '///////comando recibido parada///////////////
	high out1
	low out2
	low out2
	pause 250
	low out1
	low out2
	low out3
	SERTXD("BOTON PARADA ESCLAVO: OK",13,10)
	  sertxd ("Mensaje recibido: Parada", 13,10)
endif 

if in1 = 0 and in2 = 1 and in3 = 1 then '///////////comando recibido resetear ///////////////
	high out1
	low out2
	low out3
	pause 250
	low out1
	low out2
	low out3
	
		SERTXD("BOTON RESET DE ESCLAVO: OK",13,10)
		  sertxd ("Mensaje recibido: Resetear", 13,10)
		  goto inicio 
endif
	  
  ' Verificar bot?n de finalizaci?n
if btn_finalizar = 1 then
	  do
		  pause 50
loop until btn_finalizar = 0
	do
		high out1
		low out2
		high out3
	loop until in1 = 0 and in2 = 1 and in3 = 0
	pause 100
	low out1
	low out2
	low out3
	SERTXD("BOTON FINALIZAR: OK",13,10)

	sertxd ("Mensaje enviado: Finalizar",CR,LF)
	sertxd ("Conteo de objetos: ", #contador,CR,LF)

    goto inicio
endif


if in2 = 1 and in2 = 0 and in3 = 1 then '//////////SENSOR IR ENTRADA ////////
	high out1
	low out2
	low out3
	pause 250
	low out1
	low out2
	low out3
	
	inc contador
	SERTXD("SENSOR IR: OK",13,10)

		 ' ===== ALGORITMO MEJORADO DE DETECCI?N DE COLORES =====
  ' Configurar escala del sensor (20%)
  high S0
  low S1
  
  ' Primero, leer valor sin filtro como referenci
  high S2
  low S3
  pause 100
  count C.1, 200, blanco
  
  ' Leer el color rojo
  low S2
  low S3
  pause 100
  count C.1, 200, rojo
  
  ' Leer el color verde
  high S2
  high S3
  pause 100
  count C.1, 200, verde
  
  ' Leer el color azul
  low S2
  high S3
  pause 100
  count C.1, 200, azul
  
  ' 1. Asegurarse de que los valores sean inversamente proporcionales
  temp = 1+rojo
  rojo = 65535 / temp
  temp2 = 1+verde
  verde = 65535 / temp2
  temp3 = 1+azul
  azul = 65535 / temp3
  
  ' 2. Encontrar el valor m?ximo para normalizaci?n
  max_valor = rojo
  if verde > max_valor then
    max_valor = verde
  endif
  if azul > max_valor then
    max_valor = azul
  endif
  
  ' 3. Normalizar a escala 0-255
  temp = rojo*255
  rojo_cal = temp / max_valor
  temp2 = verde*255
  verde_cal = temp2 / max_valor
  temp3 = azul*255
  azul_cal = temp3 / max_valor
  
  ' 4. Compensar desbalances del sensor
  rojo_cal = rojo_cal * 90  ' Reducci?n del 10% en rojo si es necesario
  rojo_cal = rojo_cal/100
  verde_cal = verde_cal * 95 ' Reducci?n del 5% en verde si es necesario
  verde_cal = verde_cal/100
  
  ' 5. Asegurar rango 0-255
  if rojo_cal > 255 then
    rojo_cal = 255
  endif
  if verde_cal > 255 then
    verde_cal = 255
  endif
  if azul_cal > 255 then
    verde_cal = 255
  endif
  
  ' 6. Invertir valores para que coincidan con la intensidad de color
  rojo_cal = 255 - rojo_cal
  verde_cal = 255 - verde_cal
  azul_cal = 255 - azul_cal

  ' === Visualizar valores en LEDs ===
  ' Apagar todos los LEDs de color
  'low led_rojo
  'low led_verde
  'low led_azul
	SERTXD("SENSOR DE COLOR: OK",13,10)
  ' === Determinar color predominante y enviar comando ===
  if rojo_cal > verde_cal and rojo_cal > azul_cal then
	  'high led_rojo                ' Encender LED rojo
	      do
			low out1
			low out2
			high out3
		loop until in1 = 0 and in2 = 1 and in3 = 0
		pause 250
		low out1
		low out2
		low out3
		
  elseif verde_cal > rojo_cal and verde_cal > azul_cal then
'	high led_verde               ' Encender LED verde
	      do
			low out1
			high out2
			low out3
		loop until in1 = 0 and in2 = 1 and in3 = 0
		pause 100
		low out1
		low out2
		low out3
		 
  elseif azul_cal > rojo_cal and azul_cal > verde_cal then
'	  high led_azul                ' Encender LED azul
	      do
			low out1
			high out2
			high out3
		loop until in1 = 0 and in2 = 1 and in3 = 0
		pause 100
		low out1
		low out2
		low out3
  else
	sertxd("NO SE DETECTO UN COLOR",13,10)
 pause 100
  endif
	
endif
  ' Continuar con ciclo principal
  goto ciclo_principal