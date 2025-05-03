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

' Pines para comunicaci?n serial
symbol TX = C.0             ' Salida serial al PICAXE esclavo
symbol RX = B.0             ' Entrada serial desde PICAXE esclavo

' Pines para LEDs indicadores (opcional)
symbol led_rojo = B.2       ' LED indicador de color rojo detectado
symbol led_verde = B.3      ' LED indicador de color verde detectado
symbol led_azul = B.4       ' LED indicador de color azul detectado
symbol led_estado = B.1     ' LED indicador de estado/error

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

symbol iniciar = "I"
symbol parada = "P"
symbol resetear = "T"
symbol nada = "X"
symbol finalizar = "F"
symbol cmd_rojo = "R"
symbol cmd_verde = "G"
symbol cmd_azul = "B"
symbol continuar = "O"
symbol objeto_detectado = "Z"

' === Configuraci?n inicial ===
inicio:
  setfreq m8                ' Configurar frecuencia a 8MHz para estabilidad
  contador_objetos = 0      ' Inicializar contador
  estado_esclavo = 0        ' Estado normal
  ultimo_comando = "X"      ' Inicializar ?ltimo comando

  ' Configurar pines de salida para LEDs
  low led_rojo
  low led_verde
  low led_azul
  low led_estado
  
    ' Se?alizaci?n de arranque (parpadeo del LED de estado)
  for i = 1 to 5
    high led_estado
    pause 200
    low led_estado
    pause 200
  next i
goto espera_inicio

espera_inicio:
  if btn_inicio = 1 then 
    ' Esperar a que se suelte el bot?n para evitar rebotes
    do : pause 50 : loop until btn_inicio = 0
    
    high signal
    if signal_recibida = 1 then
    ' Enviar se?al de inicializaci?n al esclavo
    	comando_recibido = 0
	serout c.0, T4800_8, (iniciar, 13, 10)
	sertxd ("Mensaje enviado: ", iniciar, CR, LF)
	pause 50
	serin b.0, T4800_8, comando_recibido
	sertxd ("Mensaje recibido: ", comando_recibido, CR, LF)
	for i = 1 to 5
	      high led_estado
	      pause 200
	      low led_estado
      	pause 200
    next i
    goto ciclo_principal
    endif
  endif
goto espera_inicio

ciclo_principal:
pause 50
  serin b.0, T4800_8, comando_recibido

  ' Verificar bot?n de parada de emergencia
if btn_parada = 0 then
	  do 
		  pause 50
	loop until btn_parada = 1
	  
	 estado_esclavo = 1      ' Marcar estado de parada
	 
    serout C.0, T4800_8, (parada, 13, 10)
    serin B.0, T4800_8, comando_recibido
    sertxd ("Mensaje recibido: ", comando_recibido, 13,10)
    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	serin B.0, T4800_8, comando_recibido
	serout C.0, T4800_8, (continuar, 13,10)
	sertxd ("Objetos contados: ",comando_recibido,CR,LF)
	sertxd ("Precione el boton resetear.",CR,LF)
endif

if comando_recibido = parada then
	  sertxd ("Mensaje recibido: ", comando_recibido, 13,10)
	  for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	  serout C.0, T4800_8, (continuar, 13,10)
	  serin B.0, T4800_8, (comando_recibido, 13,10)
	serout C.0, T4800_8, (continuar, 13,10)
	sertxd ("Objetos contados: ", comando_recibido, 13,10)
endif 

if comando_recibido = resetear then
		  sertxd ("Mensaje recibido: ", comando_recibido, 13,10)
		  serout C.0, T4800_8, (continuar, 13,10)
		  for i = 0 to 10
		        high led_estado
		        pause 250
		        low led_estado
	  	next i
		serin b.0, T4800_8, (comando_recibido, 13,10)
		serout c.0, T4800_8, (continuar, 13,10)
		sertxd ("Objetos contados: ", comando_recibido, 13,10)
		for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
endif
	  
  ' Verificar bot?n de finalizaci?n
if btn_finalizar = 1 then
	  do
		  pause 50
	loop until btn_finalizar = 0
	  comando_recibido = 0
	  	serout c.0, T4800_8, (finalizar, 13,10)
		serin b.0, T4800_8, (comando_recibido, 13,10)
	    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	serin b.0, T4800_8, (comando_recibido,13,10)
	serout c.0, T4800_8, (continuar, 13,10)
	sertxd ("Objetos contados: ",comando_recibido,CR,LF)
	    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
    goto inicio
endif

if comando_recibido = objeto_detectado then	

sertxd ("-Objeto detectado-")
serout c.0, T4800_8, (continuar, 13,10)

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
  low led_rojo
  low led_verde
  low led_azul

  ' === Determinar color predominante y enviar comando ===
  if rojo_cal > verde_cal and rojo_cal > azul_cal then
	  high led_rojo                ' Encender LED rojo
	      
	    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	  comando_recibido = 0
	  serout c.0, T4800_8, (cmd_rojo, 13,10) 
	  serin b.0, T4800_8, (comando_recibido, 13,10)
    comando_actual = "R"
    
  elseif verde_cal > rojo_cal and verde_cal > azul_cal then
	high led_verde               ' Encender LED verde
	      
	    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	  comando_recibido = 0
	  serout c.0, T4800_8, (cmd_verde, 13,10)
	  serin b.0, T4800_8, (comando_recibido, 13,10)
    comando_actual = "G"
    
  elseif azul_cal > rojo_cal and azul_cal > verde_cal then
	  high led_azul                ' Encender LED azul
	      
	    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	  comando_recibido = 0
	  serout c.0, T4800_8, (cmd_azul, 13,10)
	  serin b.0, T4800_8, (comando_recibido, 13,10)
    comando_actual = "B"
    
  else
	    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	    comando_recibido = 0

	    serout c.0, T4800_8, (nada, 13,10)      ' Color indeterminado - C?digo "X"
    		serin B.0, T4800_8, (comando_recibido, 13,10)
    comando_actual = "X"
  endif
	
endif
  ' Continuar con ciclo principal
  goto ciclo_principal