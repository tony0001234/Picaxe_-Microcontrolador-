#picaxe 20m2
#terminal 9600
' === Pines de control y configuraci?n ===
symbol btn_parada = pinB.7   ' Bot?n de parada de emergencia
symbol btn_finalizar = pinB.6 ' Bot?n para finalizar el proceso
symbol btn_inicio = pinB.5    ' Bot?n de inicio

' PINES DE COMUNICACI?N (NUEVOS) - REEMPLAZO DE LA COMUNICACI?N SERIAL
symbol com_out_1 = C.0     ' Se?ales de salida para comunicaci?n (antes TX)
symbol com_out_2 = B.3     ' Segunda l?nea de comunicaci?n de salida
symbol com_out_3 = B.4     ' Tercera l?nea de comunicaci?n de salida
symbol com_out_4 = B.5     ' Cuarta l?nea de comunicaci?n de salida

symbol com_in_1 = pinC.0   ' Se?ales de entrada para comunicaci?n (antes RX)
symbol com_in_2 = pinC.1   ' Segunda l?nea de comunicaci?n de entrada
symbol com_in_3 = pinC.6   ' Tercera l?nea de comunicaci?n de entrada
symbol com_in_4 = pinC.7   ' Cuarta l?nea de comunicaci?n de entrada (antes signal)

' Pines para el sensor de color TCS3200
symbol S0 = C.4
symbol S1 = C.5             
symbol S2 = C.2             
symbol S3 = C.3
symbol sensorOUT = pinB.0   ' Entrada de frecuencia del sensor de color (movido desde C.1)

' Pines para LEDs indicadores
symbol led_rojo = B.2       ' LED indicador de color rojo detectado
symbol led_verde = C.1       ' LED indicador de color verde detectado (movido desde B.3)
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
symbol comando_recibido = b12    ' Comando recibido del esclavo

' C?digos de comandos (definidos por los patrones de pines)
symbol CMD_NADA = 0         ' 0000 - No hacer nada
symbol CMD_INICIAR = 1      ' 0001 - Iniciar operaci?n
symbol CMD_PARADA = 2       ' 0010 - Parada de emergencia
symbol CMD_RESETEAR = 3     ' 0011 - Resetear sistema
symbol CMD_FINALIZAR = 4    ' 0100 - Finalizar operaci?n
symbol CMD_ROJO = 5         ' 0101 - Mover a posici?n roja
symbol CMD_VERDE = 6        ' 0110 - Mover a posici?n verde
symbol CMD_AZUL = 7         ' 0111 - Mover a posici?n azul
symbol CMD_CONTINUAR = 8    ' 1000 - Confirmaci?n/Continuar
symbol CMD_OBJETO = 9       ' 1001 - Objeto detectado
symbol CMD_CONTADOR = 10    ' 1010 - Env?o de contador de objetos

' === Configuraci?n inicial ===
inicio:
  setfreq m8                ' Configurar frecuencia a 8MHz para estabilidad
  contador_objetos = 0      ' Inicializar contador
  estado_esclavo = 0        ' Estado normal
  ultimo_comando = CMD_NADA ' Inicializar ?ltimo comando

  ' Inicializar pines de comunicaci?n de salida a bajo
  low com_out_1
  low com_out_2
  low com_out_3
  low com_out_4

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

' Subrutina para enviar comandos por los pines de comunicaci?n
enviar_comando:
  ' b13 contiene el comando a enviar
  if b13.0 = 1 then high com_out_1 else low com_out_1
  if b13.1 = 1 then high com_out_2 else low com_out_2
  if b13.2 = 1 then high com_out_3 else low com_out_3
  if b13.3 = 1 then high com_out_4 else low com_out_4
  
  ' Pulso para indicar que los datos est?n listos
  pause 100
  return

' Subrutina para leer comandos desde los pines de comunicaci?n
leer_comando:
  ' Leer el estado de los pines de entrada
  b12 = 0 ' Resetear comando recibido
  if com_in_1 = 1 then b12.0 = 1
  if com_in_2 = 1 then b12.1 = 1
  if com_in_3 = 1 then b12.2 = 1
  if com_in_4 = 1 then b12.3 = 1
  
  ' Esperar a que la se?al se estabilice
  pause 100
  return

espera_inicio:
  if btn_inicio = 1 then 
    ' Esperar a que se suelte el bot?n para evitar rebotes
    do : pause 50 : loop until btn_inicio = 0
    
    ' Enviar se?al de inicializaci?n al esclavo
    b13 = CMD_INICIAR
    gosub enviar_comando
    
    ' Esperar confirmaci?n del esclavo
    gosub leer_comando
    
    ' Verificar si recibimos confirmaci?n
    if b12 = CMD_CONTINUAR then
      ' Secuencia de parpadeo para confirmar inicio
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
  
  ' Leer comando entrante del esclavo
  gosub leer_comando
  comando_recibido = b12

  ' Verificar bot?n de parada de emergencia
  if btn_parada = 0 then
    do 
      pause 50
    loop until btn_parada = 1
    
    estado_esclavo = 1      ' Marcar estado de parada
    
    ' Enviar comando de parada
    b13 = CMD_PARADA
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
      high led_estado
      pause 250
      low led_estado
      pause 250
    next i
    
    ' Esperar contador de objetos
    gosub leer_comando
    if b12 = CMD_CONTADOR then
      ' Leer valor del contador
      gosub leer_comando
      contador_objetos = b12
      
      ' Confirmar recepci?n
      b13 = CMD_CONTINUAR
      gosub enviar_comando
      
      sertxd ("Objetos contados: ", #contador_objetos, CR, LF)
      sertxd ("Presione el bot?n resetear.", CR, LF)
    endif
  endif

  ' Procesar comando de parada recibido
  if comando_recibido = CMD_PARADA then
    ' Indicaci?n visual
    for i = 0 to 10
      high led_estado
      pause 250
      low led_estado
      pause 250
    next i
    
    ' Confirmar recepci?n
    b13 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Esperar contador de objetos
    gosub leer_comando
    if b12 = CMD_CONTADOR then
      ' Leer valor del contador
      gosub leer_comando
      contador_objetos = b12
      
      ' Confirmar recepci?n
      b13 = CMD_CONTINUAR
      gosub enviar_comando
      
      sertxd ("Objetos contados: ", #contador_objetos, CR, LF)
    endif
  endif 

  ' Procesar comando de reset recibido
  if comando_recibido = CMD_RESETEAR then
    ' Confirmar recepci?n
    b13 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
      high led_estado
      pause 250
      low led_estado
      pause 250
    next i
    
    ' Esperar contador de objetos (que deber?a ser 0)
    gosub leer_comando
    if b12 = CMD_CONTADOR then
      ' Leer valor del contador
      gosub leer_comando
      contador_objetos = b12
      
      ' Confirmar recepci?n
      b13 = CMD_CONTINUAR
      gosub enviar_comando
      
      sertxd ("Objetos contados: ", #contador_objetos, CR, LF)
      
      ' Indicaci?n visual
      for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
      next i
    endif
  endif
  
  ' Verificar bot?n de finalizaci?n
  if btn_finalizar = 1 then
    do
      pause 50
    loop until btn_finalizar = 0
    
    ' Enviar comando de finalizaci?n
    b13 = CMD_FINALIZAR
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
      high led_estado
      pause 250
      low led_estado
      pause 250
    next i
    
    ' Esperar contador de objetos
    gosub leer_comando
    if b12 = CMD_CONTADOR then
      ' Leer valor del contador
      gosub leer_comando
      contador_objetos = b12
      
      ' Confirmar recepci?n
      b13 = CMD_CONTINUAR
      gosub enviar_comando
      
      sertxd ("Objetos contados: ", #contador_objetos, CR, LF)
      
      ' Indicaci?n visual
      for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
      next i
    endif
    
    goto inicio
  endif

  ' Procesar comando de objeto detectado
  if comando_recibido = CMD_OBJETO then
    sertxd ("-Objeto detectado-", CR, LF)
    
    ' Confirmar recepci?n
    b13 = CMD_CONTINUAR
    gosub enviar_comando

    ' ===== ALGORITMO MEJORADO DE DETECCI?N DE COLORES =====
    ' Configurar escala del sensor (20%)
    high S0
    low S1
    
    ' Primero, leer valor sin filtro como referencia
    high S2
    low S3
    pause 100
    count B.0, 200, blanco
    
    ' Leer el color rojo
    low S2
    low S3
    pause 100
    count B.0, 200, rojo
    
    ' Leer el color verde
    high S2
    high S3
    pause 100
    count B.0, 200, verde
    
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