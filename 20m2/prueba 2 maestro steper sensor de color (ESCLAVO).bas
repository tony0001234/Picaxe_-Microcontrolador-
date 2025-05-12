#picaxe 20m2
#terminal 9600
' Definici?n de pines de entrada/salida


SYMBOL SERVO_PIN1 = B.5
SYMBOL SERVO_PIN2 = B.6

SYMBOL POS_0 = 100
SYMBOL POS_90 = 150
SYMBOL POS_180 = 200

symbol led_estado = b.4

' Definici?n de pines de salida para control del driver
symbol dir_salida = c.1    ' Direcci?n para el driver (cambiado a C.2)
symbol enable = c.2        ' Enable para el driver
symbol estep = c.3       

'symbol signal = c.7
'symbol signal_recibida = pinC.6
symbol btn_reset = pinB.1  ' Bot?n de reset
symbol btn_parada = pinB.2 ' Bot?n de parada de emergencia

' NUEVO: Definici?n del pin para sensor IR
symbol sensor_ir = pinB.7 ' Pin para el sensor IR
'symbol led_estado = B.6

symbol out1 = c.0
symbol out2 = b.0
symbol out3 = c.7

symbol in1 = pinc.4
symbol in2 = pinc.5
symbol in3 = pinc.6

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
  	low out1
	low out2
	low out3
'	high led_estado
goto espera_inicio

espera_inicio:
if in1 = 1 and in2 = 1 and in3 = 1 then 'comando inicio /////////
	pause 50
	low out1
	high out2
	low out3
	
	do
		high out3
	loop until in1 = 1 and in2 = 0 and in3 = 0
	pause 100
	low out3 
      	pause 200
    goto main
endif
goto inicio

main:
pause 50
  'Verificar estado del sensor IR y contar objetos
if sensor_ir = 1 and estado_anterior_ir = 0 then
    ' Detectado un nuevo objeto (flanco ascendente)
    estado_anterior_ir = 1
    contador_objetos = contador_objetos + 1

	do
		high out1
		low out2
		high out3
	loop until in1 = 1 and in2 = 0 and in3 = 0
	pause 100
	low out1
	low out2
	low out3

    ' Al detectar un objeto, procesar comando actual
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
    
    do
		high out1
		high out2
		high out3
	loop until in1 = 1 and in2 = 0 and in3 = 0
	pause 100
	low out1
	low out2
	low out3
    
endif
  
if in1 = 1 and in2 = 1 and in3 = 0 then '//////comando recibido parada////////////
	low out1
	high out2
	low out3
	pause 250
	low out1
	low out2
	low out3

	  parada_emergencia = 1
	  high enable

endif
  
  ' Verificar bot?n de reset 
if btn_reset = 1 then
	do
		low out1
		high out2
		high out3
loop until in1 = 1 and in2 = 0 and in3 = 0
    pause 100
    low out1
    low out2
    low out3
	
    parada_emergencia = 0  ' Desactivar parada de emergencia
    pos_actual = POS_CERO  ' Resetear posici?n
    contador_objetos = 0   ' NUEVO: Resetear contador de 
    pos_destino = POS_CERO
    low enable
    gosub mover_motor
    high enable

    contador_objetos =  0
endif
  
  ' Si estamos en parada de emergencia, no procesar comandos de movimiento
if parada_emergencia = 1 then
    pause 50
    goto main
endif
  
  ' Verificar continuamente si se debe finalizar
if in1 = 1 and in2 = 0 and in3 = 1 then'//////////comando finalizar//////////
	low out1
	high out2
	low out3
	pause 250
	low out1
	low out2
	low out3
	gosub inicio
    end
endif

goto main

'Subrutina para procesar comando actual basado en detecci?n IR
procesar_comando:
  if in1 = 0 and in2 = 1 and in3 = 0 then   ' Posici?n verde (200?)
	low out1
	high out2
	low out3
	pause 250
	low out1
	low out2
	low out3
	  
    pos_destino = POS_VERDE
    low enable             ' Habilitamos el motor
    FOR i = 1 TO 50
	PULSOUT SERVO_PIN1, POS_180
	PAUSE 20
NEXT i
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
    FOR i = 1 TO 50
	PULSOUT SERVO_PIN1, POS_90
	PAUSE 20
NEXT i

  elseif in1 = 0 and in2 = 0 and in3 = 1 then   ' Posici?n roja (45?)
	low out1
	high out2
	low out3
	pause 250
	low out1
	low out2
	low out3
	  
    pos_destino = POS_ROJO
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento

  elseif in1 = 0 and in2 = 1 and in3 = 1 then   ' Posici?n azul (300?)
	low out1
	high out2
	low out3
	pause 250
	low out1
	low out2
	low out3
	  
    pos_destino = POS_AZUL
    low enable             ' Habilitamos el motor
    
    FOR i = 1 TO 50
	PULSOUT SERVO_PIN2, POS_180
	PAUSE 20
    NEXT i
    
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
    FOR i = 1 TO 50
	PULSOUT SERVO_PIN2, POS_90
	PAUSE 20
    NEXT i

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
	do
		high out1
		high out2
		high out3
	loop until in1 = 1 and in2 = 0 and in3 = 0
	pause 100
	low out1
	low out2
	low out3

      return               ' Salir sin completar los pasos
    endif
    
    high estep
    pause pausa_paso
    low estep
    pause pausa_paso
  next temp
  return