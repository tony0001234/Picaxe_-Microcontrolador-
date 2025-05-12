#picaxe 20m2
#terminal 9600
' Definici?n de pines de entrada/salida

' PINES DE COMUNICACI?N (NUEVOS) - REEMPLAZO DE LA COMUNICACI?N SERIAL
symbol com_out_1 = c.0     ' Se?ales de salida para comunicaci?n (antes TX)
symbol com_out_2 = c.1     ' Segunda l?nea de comunicaci?n de salida
symbol com_out_3 = c.6     ' Tercera l?nea de comunicaci?n de salida 
symbol com_out_4 = c.7     ' Cuarta l?nea de comunicaci?n de salida (antes signal)

symbol com_in_1 = pinB.0   ' Se?ales de entrada para comunicaci?n (antes RX)
symbol com_in_2 = pinB.3   ' Segunda l?nea de comunicaci?n de entrada
symbol com_in_3 = pinB.4   ' Tercera l?nea de comunicaci?n de entrada
symbol com_in_4 = pinB.5   ' Cuarta l?nea de comunicaci?n de entrada

' Definici?n de pines de salida para control del driver
symbol dir_salida = c.2    ' Direcci?n para el driver
symbol enable = c.3        ' Enable para el driver
symbol estep = c.4         ' Step para el driver

symbol btn_reset = pinB.1  ' Bot?n de reset
symbol btn_parada = pinB.2 ' Bot?n de parada de emergencia

' NUEVO: Definici?n del pin para sensor IR
symbol sensor_ir = pinB.7  ' Pin para el sensor IR
symbol led_estado = B.6    ' LED indicador de estado

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
symbol comando_recibido = b1   ' Comando recibido por comunicaci?n

' Contador de objetos detectados por el sensor IR
symbol contador_objetos = w5 ' Contador para objetos detectados por IR

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

symbol i = b3
symbol parada_emergencia = b2 ' Estado de parada de emergencia (0=normal, 1=parada)

inicio:
' Inicializaci?n
  high enable              ' Deshabilitamos el motor al inicio
  low estep                ' Aseguramos que el pulso de paso est? en bajo
  pos_actual = POS_CERO    ' Al inicio, asumimos que el motor est? en posici?n cero
  estado_anterior_ir = 0   ' Inicializar estado del sensor IR
  parada_emergencia = 0    ' Inicializar estado de parada (normal)
  contador_objetos = 0     ' Inicializar contador de objetos
  
  ' Inicializar pines de comunicaci?n de salida a bajo
  low com_out_1
  low com_out_2
  low com_out_3
  low com_out_4
  
  ' Secuencia de parpadeo para indicar inicio
  for i = 1 to 10
      high led_estado
      pause 200
      low led_estado
      pause 200
  next i
  
  high led_estado
  goto espera_inicio

' Subrutina para enviar comandos por los pines de comunicaci?n
enviar_comando:
  ' b1 contiene el comando a enviar
  if b1.0 = 1 then high com_out_1 else low com_out_1
  if b1.1 = 1 then high com_out_2 else low com_out_2
  if b1.2 = 1 then high com_out_3 else low com_out_3
  if b1.3 = 1 then high com_out_4 else low com_out_4
  
  ' Pulso para indicar que los datos est?n listos
  pause 100
  return

' Subrutina para leer comandos desde los pines de comunicaci?n
leer_comando:
  ' Leer el estado de los pines de entrada
  b1 = 0 ' Resetear comando
  if com_in_1 = 1 then b1.0 = 1
  if com_in_2 = 1 then b1.1 = 1
  if com_in_3 = 1 then b1.2 = 1
  if com_in_4 = 1 then b1.3 = 1
  
  ' Esperar a que la se?al se estabilice
  pause 100
  return

espera_inicio:
  ' Verificar si se recibe el comando de inicio
  gosub leer_comando
  if b1 = CMD_INICIAR then
    low led_estado
    ' Confirmar inicio
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Secuencia de parpadeo para confirmar inicio
    for i = 1 to 10
        high led_estado
        pause 200
        low led_estado
        pause 200
    next i
    goto main
  endif
  goto espera_inicio

main:
  pause 50
  ' Leer comando entrante
  gosub leer_comando
  comando_recibido = b1

  ' Verificar estado del sensor IR y contar objetos
  if sensor_ir = 1 and estado_anterior_ir = 0 then
    ' Detectado un nuevo objeto (flanco ascendente)
    estado_anterior_ir = 1
    contador_objetos = contador_objetos + 1
    
    ' Parpadeo para indicar detecci?n
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
    ' Notificar objeto detectado
    b1 = CMD_OBJETO
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
    
    ' Procesar el comando actual
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
    
    ' Indicar parada de emergencia
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
    ' Enviar se?al de parada
    b1 = CMD_PARADA
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
    
    ' Enviar contador de objetos
    b1 = CMD_CONTADOR
    gosub enviar_comando
    
    ' Enviar valor del contador (en patrones de 4 bits si es necesario)
    ' Para este ejemplo, asumimos que contador_objetos < 16 para simplificar
    ' Si contador > 15, se necesitar?a un protocolo adicional
    b1 = contador_objetos & 15  ' Tomar solo los 4 bits inferiores
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
  endif
  
  ' Procesar comando de parada recibido
  if comando_recibido = CMD_PARADA then
    parada_emergencia = 1
    high enable
    
    ' Confirmar recepci?n
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
    ' Enviar contador de objetos
    b1 = CMD_CONTADOR
    gosub enviar_comando
    
    ' Enviar valor (simplificado para contador < 16)
    b1 = contador_objetos & 15
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
  endif
  
  ' Verificar bot?n de reset
  if btn_reset = 1 then
    parada_emergencia = 0  ' Desactivar parada de emergencia
    pos_actual = POS_CERO  ' Resetear posici?n
    contador_objetos = 0   ' Resetear contador de objetos
    
    ' Notificar reset
    b1 = CMD_RESETEAR
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
    
    ' Volver a posici?n cero
    pos_destino = POS_CERO
    low enable
    gosub mover_motor
    high enable
    
    ' Enviar contador (ahora en cero)
    b1 = CMD_CONTADOR
    gosub enviar_comando
    b1 = 0  ' contador = 0
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
    
    contador_objetos = 0
  endif
  
  ' Si estamos en parada de emergencia, no procesar comandos de movimiento
  if parada_emergencia = 1 then
    pause 50
    goto main
  endif
  
  ' Verificar si se debe finalizar
  if comando_recibido = CMD_FINALIZAR then
    ' Confirmar recepci?n
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
    ' Enviar contador final
    b1 = CMD_CONTADOR
    gosub enviar_comando
    b1 = contador_objetos & 15
    gosub enviar_comando
    
    ' Esperar confirmaci?n
    gosub leer_comando
    
    contador_objetos = 0
    
    ' Indicaci?n de finalizaci?n
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
    end
  endif

  goto main

' Subrutina para procesar comando actual basado en detecci?n IR
procesar_comando:
  ' Procesar comando recibido
  if comando_recibido = CMD_NADA then       ' Quedarse en la posici?n actual
    ' Confirmar recepci?n
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
    pause 50
  elseif comando_recibido = CMD_VERDE then   ' Posici?n verde (200?)
    pos_destino = POS_VERDE
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
    
    ' Confirmar acci?n completada
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
  
  elseif comando_recibido = CMD_ROJO then   ' Posici?n roja (45?)
    pos_destino = POS_ROJO
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
    
    ' Confirmar acci?n completada
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
    next i
    
  elseif comando_recibido = CMD_AZUL then   ' Posici?n azul (300?)
    pos_destino = POS_AZUL
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
    
    ' Confirmar acci?n completada
    b1 = CMD_CONTINUAR
    gosub enviar_comando
    
    ' Indicaci?n visual
    for i = 0 to 10
        high led_estado
        pause 250
        low led_estado
        pause 250
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
      
      ' Enviar se?al de parada
      b1 = CMD_PARADA
      gosub enviar_comando
      
      ' Indicaci?n visual
      for i = 0 to 10
        high led_estado
        pause 50
        low led_estado
        pause 50
      next i
      
      ' Esperar confirmaci?n
      gosub leer_comando
      
      ' Enviar contador
      b1 = CMD_CONTADOR
      gosub enviar_comando
      b1 = contador_objetos & 15
      gosub enviar_comando
      
      return               ' Salir sin completar los pasos
    endif
    
    high estep
    pause pausa_paso
    low estep
    pause pausa_paso
  next temp
  return