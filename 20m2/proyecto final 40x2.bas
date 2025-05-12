#picaxe 40x2
#terminal 9600

symbol btn_parada = pinA.0
symbol btn_reset = pinA.1
symbol btn_finalizar = pinA.2
symbol btn_inicio = pinA.3

'Pines servos
symbol servo_pin1 = C.1
symbol servo_pin2 = C.2

symbol pos_0 = 100
symbol pos_90 = 150
symbol pos_180 = 200

'Pines control del driver
symbol dir_salida = D.2    ' Direccion
symbol enable = D.3        ' Enable para el driver
symbol estep = C.4

symbol sensor_ir = pinD.0 ' Pin para el sensor IR

' Constantes para posiciones en grados (convertidas a pasos)
symbol POS_CERO = 0        ' Posici?n 0?
symbol POS_ROJO = 45       ' Posici?n 45? (25 pasos reales, pero usando valor directo)
symbol POS_VERDE = 111     ' Posici?n 200? (111 pasos reales)
symbol POS_AZUL = 167      ' Posici?n 300? (167 pasos reales)  

' Pines para el sensor de color TCS3200
symbol sensorOUT = pinB.7		' Entrada de frecuencia del sensor de color
symbol s0 = B.6
symbol s1 = B.5
symbol s2 = B.4
symbol s3 = B.3
symbol led = B.2

' Pines para LEDs indicadores (opcional)
symbol led_rojo = A.5      ' LED indicador de color rojo detectado
symbol led_verde = A.6      ' LED indicador de color verde detectado
symbol led_azul = A.7       ' LED indicador de color azul detectado
symbol led_estado = C.0     ' LED indicador de estado/error


' --- Variables para la detecci?n de color mejorada ---
symbol rojo = w0            ' Valor crudo rojo
symbol verde = w1           ' Valor crudo verde
symbol azul = w2            ' Valor crudo azul
symbol blanco = w3		' Valor de referencia blanco
symbol rojo_cal = w4        ' Valores calibrados
symbol verde_cal = w5
symbol azul_cal = w6
symbol max_valor = w7       ' Para normalizaci?n

symbol temp = w8
symbol temp2 = w9
symbol temp3 = w10

' Variables de operacion steper
symbol pausa_paso = 5      ' Tiempo de pausa entre pasos
symbol pos_actual = w11     ' Posicion actual del motor
symbol pos_destino = w12    ' Posicion destino a alcanzar
symbol pasos_mover = w13    ' Cantidad de pasos a mover

symbol i = b0
symbol contador_objetos = b1    ' Contador de objetos detectados por IR
symbol parada_emergencia = b2 ' Estado de parada de emergencia (0=normal, 1=parada)
symbol control_finalizar = b3

inicio:
	setfreq m8                ' Configurar frecuencia a 8MHz para estabilidad
	contador_objetos = 0      ' Inicializar contador
	
	high enable              ' Deshabilitamos el motor al inicio
	low estep                ' Aseguramos que el pulso de paso este en bajo
	pos_actual = POS_CERO    ' Al inicio, asumimos que el motor esta en posicion cero
	parada_emergencia = 0    ' Inicializar estado de parada (normal)
	contador_objetos = 0     ' Inicializar contador de objetos
	control_finalizar = 0	' Variable control para finalizar el proceso
	
	' Configurar pines de salida para LEDs
	low led_rojo
	low led_verde
	low led_azul
	low led_estado
	
	low led
	wait 20
	' Senializacion de arranque (parpadeo del LED de estado)
	sertxd("Alimentacion: OK",13,10)
	for i = 1 to 5
		high led_estado
		pause 200
		low led_estado
		pause 200
	next i

goto espera_inicio:
	
espera_inicio:
	if btn_inicio = 1 then
		' Esperar a que se suelte el boton para evitar rebotes
		do
			pause 50
		loop until btn_inicio = 0
		
		for i = 1 to 5
			high led_estado
			pause 200
			low led_estado
			pause 200
		next i
		sertxd("Boton INICIO: OK",13,10)
		
		'bucle para el servo 
		for i = 1 to 50
			pulsout servo_pin1, pos_180
			pause 20
		next i
		
		'bucle para el servo 
		for i = 1 to 50
			pulsout servo_pin2, pos_180
			pause 20
		next i
		
		sertxd("Estado de Servos: OK",13,10)
		
		goto ciclo_principal
	endif
	pause 50
goto espera_inicio

ciclo_principal:
	pause 50
	if btn_parada = 0 then
		' Esperar a que se suelte el boton para evitar rebotes
		do
			pause 50
		loop until btn_parada = 1
		sertxd("Boton de PARADA: OK")
		for i = 1 to 5
			high led_estado
			pause 200
			low led_estado
			pause 200
		next i
		sertxd("Objetos contados: ", #contador_objetos, 13,10)
		do
			pause 250
			sertxd("Precione el boton resetear...",13,10)
		loop until btn_reset = 1
		sertxd("Boton RESETEAR: OK")
		
		parada_emergencia = 0	' Desactiva parada de emergencia 
		contador_objetos = 0	' Resetea contador
		
		pos_destino = POS_CERO
		low enable
		gosub mover_motor
		high enable
		contador_objetos = 0
		
		for i = 1 to 5
			high led_estado
			pause 200
			low led_estado
			pause 200
		next i
		sertxd("Reseteo Realizado Correctamente!!!",13,10)
		gosub inicio
	endif
	
	if btn_finalizar = 1 then
		do
			pause 50
		loop until btn_finalizar = 0
		sertxd("Objetos contados: ", #contador_objetos,13,10)
		for i = 1 to 5
			high led_estado
			pause 200
			low led_estado
			pause 200
		next i
		control_finalizar = 1
	endif
	
	'verifica el paso de objetos en IR
	if sensor_ir = 1 then
		do
			pause 50
		loop until sensor_ir = 0
		
		inc contador_objetos
		sertxd("Sensor IR: OK",13,10)
		sertxd("Objetos contado al momento: ", #contador_objetos,13,10)
		for i = 1 to 5
			high led_estado
			pause 200
			low led_estado
			pause 200
		next i
		
		sertxd("-Objeto detectado-",13,10)
		'=======CODIGO SENSOR DE COLOR========
		'Configuracion del 20%
		high led
		
		high s0
		low s1
		
		'valor sin filtro
		high s2
		low s3
		pause 100
		count B.7, 200, blanco
		
		'leer color rojo
		low s2
		low s3
		pause 100
		count B.7, 200, rojo
		
		'leer color verde
		high s2
		high s3
		pause 100
		count B.7, 200, verde
		
		'leer color azul
		low s2
		high s3
		pause 100
		count B.7, 200, azul
		
		'Valores inversos
		temp = 1+rojo
		rojo = 65535 / temp
		temp2 = 1+verde
		verde = 65535 / temp2
		temp3 = 1+azul
		azul = 65535 / temp3
		
		'Encontrar el valor m?ximo para normalizaci?n
		max_valor = rojo
		if verde > max_valor then
			max_valor = verde
		endif
		if azul > max_valor then
			max_valor = azul
		endif
		
		'Normalizar a escala 0-255
		temp = rojo*255
		rojo_cal = temp / max_valor
		temp2 = verde*255
		verde_cal = temp2 / max_valor
		temp3 = azul*255
		azul_cal = temp3 / max_valor
		
		' 5. Asegurar rango 0-255
		if rojo_cal > 255 then
			rojo_cal = 255
		endif
		if verde_cal > 255 then
			verde_cal = 255
		endif
		if azul_cal > 255 then
			azul_cal = 255
		endif
		
		'Invertir valores para que coincidan con la intensidad de color
		rojo_cal = 255 - rojo_cal
		verde_cal = 255 - verde_cal
		azul_cal = 255 - azul_cal
		
		' === Visualizar valores en LEDs ===
		low led_rojo
		low led_verde
		low led_azul
		
		low led
		
		  ' === Determinar color predominante ===
		if rojo_cal > verde_cal and rojo_cal > azul_cal then
			high led_rojo                ' Encender LED rojo
			sertxd("Tonalidad detectada: ROJO",13,10)
			for i = 0 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i
			
			'bucle para el servo 
			for i = 1 to 50
				pulsout servo_pin1, pos_180
				pause 20
			next i
'			sertxd("Estado de servos: OK",13,10)
			pos_destino = POS_ROJO
			
			low enable		' Habilitamos el motor
			gosub mover_motor
			
			pos_destino = POS_CERO
			gosub mover_motor
			
			high enable		' Deshabilitamos el motor despues del movimiento
			
			sertxd("Estado de steper: OK",13,10)
			
			'bucle para el servo 
			for i = 1 to 50
				pulsout servo_pin1, pos_90
				pause 20
			next i
			
			for i = 0 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i
			
		elseif verde_cal > rojo_cal and verde_cal > azul_cal then
			high led_verde               ' Encender LED verde
			sertxd("Tonalidad detectado: VERDE",13,10)
			for i = 0 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i
			
			'bucle para el servo 
'			for i = 1 to 50
'				pulsout servo_pin1, pos_180
'				pause 20
'			next i
'			sertxd("Estado de servos: OK",13,10)
			pos_destino = POS_VERDE
			
			low enable
			gosub mover_motor
			
			pos_destino = POS_CERO
			gosub mover_motor
			
			high enable
			
			sertxd("Estado de steper: OK",13,10)
			
			'bucle para el servo 
'			for i = 1 to 50
'				pulsout servo_pin1, pos_90
'				pause 20
'			next i
			
			for i = 0 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i

		elseif azul_cal > rojo_cal and azul_cal > verde_cal then
			high led_azul                ' Encender LED azul
		      
			sertxd("Tonalidad detectada: AZUL",13,10)
			for i = 0 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i
			
			'bucle para el servo 
			for i = 1 to 50
				pulsout servo_pin2, pos_180
				pause 20
			next i
'			sertxd("Estado de servos: OK",13,10)
			
			pos_destino = POS_AZUL
			
			low enable
			gosub mover_motor
			
			pos_destino = POS_CERO
			gosub mover_motor
			
			high enable
			
			sertxd("Estado de steper: OK",13,10)
			
			'bucle para el servo 
			for i = 1 to 50
				pulsout servo_pin2, pos_90
				pause 20
			next i
			
			for i = 1 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i
			
		else
			sertxd("Tonalidad detectada: INDETERMINADO",13,10)
			for i = 1 to 10
				high led_estado
				pause 250
				low led_estado
				pause 250
			next i
		endif
	sertxd("-Procedimiento finalizado-",13,10)
	endif
	
	if control_finalizar = 1 then
		goto inicio
	endif

goto ciclo_principal

' Subrutina para mover el motor desde la posicion actual a la posicion destino
mover_motor:
	' Determinar direccion y pasos a mover
	if pos_destino > pos_actual then
		' Mover en sentido positivo (avanzar)
		pasos_mover = pos_destino
		high dir_salida        ' Direcci?n para avanzar
'		sertxd("pos_destino mayor a pos_actual: ", #pasos_mover,13,10)
	else
		' Mover en sentido negativo (retroceder)
		pasos_mover = pos_actual
		low dir_salida         ' Direcci?n para retroceder
'		sertxd("pos_destino menor a pos_actual: ", #pasos_mover,13,10)
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
	for i = 1 to pasos_mover
	' Verificar parada de emergencia durante el movimiento
		if btn_parada = 0 then
			high enable
			do
				pause 50
			loop until btn_parada = 1
			gosub resetear
		endif
		
		if btn_finalizar = 1 then
			do
				pause 50
			loop until btn_finalizar = 0
			
			control_finalizar = 1
		endif
		
		high estep
		pause pausa_paso
		low estep
		pause pausa_paso
	next i
	
	if control_finalizar = 1 then
		sertxd("Objetos contados: ", #contador_objetos,13,10)
		for i = 1 to 10
			high led_estado
			pause 250
			low led_estado
			pause 250
		next i
	endif
	
return

resetear:		
	parada_emergencia = 1
	do
		high led_estado
		pause 250
		sertxd("Parada de emergencia precionada, precione resetear para restablecer el sistema...",13,10)
		low led_estado
	loop until btn_reset = 1

	sertxd("Boton RESETEAR: OK")
	sertxd("Objetos contados: ", #contador_objetos,13,10)
	parada_emergencia = 0	' Desactiva parada de emergencia 
	contador_objetos = 0	' Resetea contador

	pos_destino = POS_CERO
	low enable
	gosub mover_motor
	high enable
	contador_objetos = 0

	for i = 1 to 10
		high led_estado
		pause 250
		low led_estado
		pause 250
	next i
	sertxd("Reseteo Realizado Correctamente!!!",13,10)
gosub inicio