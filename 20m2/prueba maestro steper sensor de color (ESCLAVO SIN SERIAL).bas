#picaxe 20m2
#terminal 9600
' Definici?n de pines de entrada/salida
symbol TX = C.0         ' Transmisi?n serial a otro PICAXE
symbol RX = pinB.0         ' Recepci?n serial desde otro PICAXE

' Definici?n de pines de salida para control del driver
symbol dir_salida = c.1    ' Direcci?n para el driver (cambiado a C.2)
symbol enable = c.2        ' Enable para el driver
symbol estep = c.3       

symbol signal = c.7
symbol signal_recibida = pinC.6
symbol btn_reset = pinB.1  ' Bot?n de reset
symbol btn_parada = pinB.2 ' Bot?n de parada de emergencia

' NUEVO: Definici?n del pin para sensor IR
symbol sensor_ir = pinB.7 ' Pin para el sensor IR
symbol led_estado = B.6
' Constantes para posiciones en grados (convertidas a pasos)
symbol POS_CERO = 0        ' Posici?n 0?
symbol POS_ROJO = 45       ' Posici?n 45? (25 pasos reales, pero usando valor directo)
symbol POS_VERDE = 111     ' Posici?n 200? (111 pasos reales)
symbol POS_AZUL = 167      ' Posici?n 300? (167 pasos reales)  

' Variables de operaci?n
symbol pausa_paso = 2      ' Tiempo de pausa entre pasos
symbol pos_actual = w1     ' Posici?n actual del motor
symbol pos_destino = w2    ' Posici?n destino a alcanzar
symbol pasos_mover = w3    ' Cantidad de pasos a mover
symbol temp = w4           ' Variable temporal para c?lculos
symbol estado_anterior_ir = b0 ' Estado anterior del sensor IR
symbol comando_recibido = b1 ' Comando recibido por comunicaci?n serial

symbol i = b3

' NUEVO: Contador de objetos detectados por el sensor IR
symbol contador_objetos = w5 ' Contador para objetos detectados por IR

symbol continuar = "O"
symbol iniciar = "I"
symbol parada = "P"
symbol resetear = "T"
symbol nada = "X"
symbol finalizar = "F"
symbol rojo = "R"
symbol verde = "G"
symbol azul = "B"
symbol objeto_detectado = "Z"
symbol parada_emergencia = b2 ' Estado de parada de emergencia (0=normal, 1=parada)
inicio:
' Configuraci?n de comunicaci?n serial
setfreq m8                 ' Configurar frecuencia a 8MHz para comunicaci?n serial estable
' Inicializaci?n
  high enable              ' Deshabilitamos el motor al inicio
  low estep                ' Aseguramos que el pulso de paso est? en bajo
  pos_actual = POS_CERO    ' Al inicio, asumimos que el motor est? en posici?n cero
  estado_anterior_ir = 0   ' Inicializar estado del sensor IR
  parada_emergencia = 0    ' Inicializar estado de parada (normal)
  contador_objetos = 0     ' NUEVO: Inicializar contador de objetos
for i = 1 to 10
	      high led_estado
	      pause 200
	      low led_estado
      	pause 200
    next i
high led_estado
  comando_recibido = 0
goto espera_inicio

espera_inicio:
if signal_recibida = 1 then
	high signal

  serin b.0, T4800_8, (comando_recibido, 13,10)
  low led_estado
  ' Enviar mensaje de inicializaci?n al otro PICAXE
if comando_recibido = iniciar then
	sertxd ("Mensaje recibido: ", comando_recibido,13,10)
	serout c.0, T4800_8,(continuar, 13,10)
	sertxd ("Mensaje enviado: ", continuar,13,10)
	for i = 1 to 10
	      high led_estado
	      pause 200
	      low led_estado
      	pause 200
    next i
    goto main
endif
endif
goto inicio

main:
pause 50
  serin B.0, T4800_8, (comando_recibido, 13,10)

  ' NUEVO: Verificar estado del sensor IR y contar objetos
if sensor_ir = 1 and estado_anterior_ir = 0 then
    ' Detectado un nuevo objeto (flanco ascendente)
    estado_anterior_ir = 1
    contador_objetos = contador_objetos + 1
    for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
    comando_recibido = 0
    serout c.0, T4800_8, (objeto_detectado, 13,10)
    serin b.0, T4800_8, (comando_recibido, 13,10)
    sertxd ("Mensaje enviado: ", objeto_detectado,13,10)
    sertxd ("Mensaje recibido: ", comando_recibido,13,10)
    ' NUEVO: Al detectar un objeto, procesar comando actual
    gosub procesar_comando
  elseif sensor_ir = 0 and estado_anterior_ir = 1 then
    ' El objeto ya no est? presente (flanco descendente)
    estado_anterior_ir = 0
endif

  ' Verificar bot?n de parada de emergencia
if btn_parada = 1 then
	do 
		pause 50
	loop until btn_parada = 1
    parada_emergencia = 1
    high enable            ' Desactivar motor en parada de emergencia
	for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	comando_recibido = 0
	serout C.0, T4800_8, (parada, 13,10)
	serin B.0, T4800_8, (comando_recibido, 13,10)
	sertxd ("Mensaje enviado: ", parada,13,10)
	sertxd ("Mensaje recibido: ", comando_recibido,13,10)
	for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
  	comando_recibido = 0
	serout C.0, T4800_8, (contador_objetos, 13,10)
	serin B.0, T4800_8, (comando_recibido, 13,10)
	sertxd ("Mensaje enviado, objetos contados: ", contador_objetos,13,10)
	sertxd ("Mensaje recibido: ", comando_recibido,13,10)
endif
  
if comando_recibido = parada then
	  
	  parada_emergencia = 1
	  high enable
	  serout C.0, T4800_8, (continuar, 13,10)
	  sertxd ("Mensaje enviado: ", continuar,13,10)
	  for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	  
	  comando_recibido = 0
	serout C.0, T4800_8, (contador_objetos, 13,10)
	serin B.0, T4800_8, (comando_recibido, 13,10)
	sertxd ("Mensaje enviado objetos contados: ", contador_objetos,13,10)
	sertxd ("Mensaje recibido: ", continuar,13,10)
endif
  
  ' Verificar bot?n de reset 
if btn_reset = 1 then
    parada_emergencia = 0  ' Desactivar parada de emergencia
    pos_actual = POS_CERO  ' Resetear posici?n
    contador_objetos = 0   ' NUEVO: Resetear contador de objetos
      serout C.0, T4800_8, (resetear, 13, 10)
	serin B.0, T4800_8, (comando_recibido, 13,10)
	sertxd ("Mensaje enviado: ", resetear,13,10)
	sertxd ("Mensaje recibido: ", comando_recibido,13,10)
      for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
    ' Volver a posici?n cero
    pos_destino = POS_CERO
    low enable
    gosub mover_motor
    high enable
    comando_recibido = 0
    	serout c.0, T4800_8, (contador_objetos, 13,10)
	serin B.0, T4800_8, (comando_recibido, 13,10)
    sertxd ("Mensaje enviado objetos contados: ", contador_objetos,13,10)
    sertxd ("Mensaje recibido: ", comando_recibido,13,10)
    contador_objetos =  0
endif
  
  ' Si estamos en parada de emergencia, no procesar comandos de movimiento
if parada_emergencia = 1 then
    pause 50
    goto main
endif
  
  ' Verificar continuamente si se debe finalizar
if comando_recibido = finalizar then
      serout C.0, T4800_8, (continuar, 13, 10)
	sertxd ("Mensaje enviado: ", continuar,13,10)
      for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	comando_recibido = 0
	serout c.0, T4800_8, (contador_objetos, 13,10)
	serin B.0, T4800_8, (comando_recibido, 13,10)
	sertxd ("Mensaje enviado: ", contador_objetos,13,10)
	sertxd ("Mensaje recibido: ", comando_recibido,13,10)
	contador_objetos = 0
	for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
	
    end
endif

goto main

' NUEVO: Subrutina para procesar comando actual basado en detecci?n IR
procesar_comando:
  ' Procesar comando recibido
  if comando_recibido = nada then       ' Quedarse en la posici?n actual
      serout C.0, T4800_8, (continuar, 13,10)
	sertxd ("Mensaje recibido: ", comando_recibido,13,10)
	sertxd ("Mensaje enviado: ", continuar,13,10)
      for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
    pause 50
  elseif comando_recibido = verde then   ' Posici?n verde (200?)
    pos_destino = POS_VERDE
    low enable             ' Habilitamos el motor
    sertxd ("Mensaje recibido: ", comando_recibido,13,10)
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
      serout C.0, T4800_8, (continuar, 13,10)
	sertxd ("Mensaje enviado: ", continuar,13,10)
      for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
  elseif comando_recibido = rojo then   ' Posici?n roja (45?)
    pos_destino = POS_ROJO
    low enable             ' Habilitamos el motor
    sertxd ("Mensaje recibido: ", comando_recibido,13,10)
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
      serout C.0, T4800_8, (continuar, 13,10)
	sertxd ("Mensaje enviado: ", continuar,13,10)
      for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
    
  elseif comando_recibido = azul then   ' Posici?n azul (300?)
    pos_destino = POS_AZUL
    low enable             ' Habilitamos el motor
    sertxd ("Mensaje recibido: ", comando_recibido,13,10)
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
      serout C.0, T4800_8, (continuar, 13,10) 
	sertxd ("Mensaje enviado: ", continuar,13,10)
      for i = 0 to 10
	        high led_estado
	        pause 250
	        low led_estado
	  next i
  endif
  return

' Subrutina para mover el motor desde la posici?n actual a la posici?n destino
mover_motor:
  ' Determinar direcci?n y pasos a mover
  if pos_destino > pos_actual then
    ' Mover en sentido positivo (avanzar)
    pasos_mover = pos_destino - pos_actual
    high dir_salida        ' Direcci?n para avanzar
  else
    ' Mover en sentido negativo (retroceder)
    pasos_mover = pos_actual - pos_destino
    low dir_salida         ' Direcci?n para retroceder
  endif
  
  ' Solo realizar pasos si hay que moverse
  if pasos_mover > 0 then
    gosub realizar_pasos
  endif
  
  ' Actualizar la posici?n actual
  pos_actual = pos_destino
  return

' Subrutina para realizar los pasos calculados
realizar_pasos:
  for temp = 1 to pasos_mover
    ' Verificar parada de emergencia durante el movimiento
    if btn_parada = 1 then
      high enable          ' Detener motor inmediatamente
      parada_emergencia = 1
        serout C.0, T4800_8, (parada, 13,10)
	  sertxd ("Mensaje enviado: ", parada,13,10)
	  comando_recibido = 0
	  for i = 0 to 10
	        high led_estado
	        pause 50
	        low led_estado
	  next i
		  serin b.0, T4800_8, (comando_recibido, 13,10)
		  serout c.0, T4800_8, (contador_objetos, 13,10)
      return               ' Salir sin completar los pasos
    endif
    
    high estep
    pause pausa_paso
    low estep
    pause pausa_paso
  next temp
  return