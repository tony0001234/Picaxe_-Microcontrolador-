' Definici?n de pines de entrada
symbol dirPin = pinB.7     ' Pin para direcci?n
symbol pinA = pinB.6       ' Pin para entrada A
symbol pinB = pinB.5       ' Pin para entrada B

' Definici?n de pines de salida para control del driver
symbol dir_salida = c.0    ' Direcci?n para el driver
symbol enable = c.1        ' Enable para el driver
symbol estep = c.2         ' Pulso de paso para el driver

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

' Inicializaci?n
inicio:
  pos_actual = POS_CERO    ' Al inicio, asumimos que el motor est? en posici?n cero
  high enable              ' Deshabilitamos el motor al inicio
  low estep                ' Aseguramos que el pulso de paso est? en bajo

main:
  ' Verifica las entradas y determina la posici?n destino
  if pinA = 0 and pinB = 0 then       ' Quedarse en la posici?n actual
    pause 50
    goto main              ' Continuar verificando entradas
  elseif pinA = 0 and pinB = 1 then   ' Posici?n verde (200?)
    pos_destino = POS_VERDE
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
  elseif pinA = 1 and pinB = 0 then   ' Posici?n roja (45?)
    pos_destino = POS_ROJO
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
  elseif pinA = 1 and pinB = 1 then   ' Posici?n azul (300?)
    pos_destino = POS_AZUL
    low enable             ' Habilitamos el motor
    gosub mover_motor
    high enable            ' Deshabilitamos el motor despu?s del movimiento
  endif
  
  goto main

' Subrutina para mover el motor desde la posici?n actual a la posici?n destino
mover_motor:
  ' Determinar direcci?n y pasos a mover
  if pos_destino >= pos_actual then
    ' Mover en sentido positivo (avanzar)
    pasos_mover = pos_destino - pos_actual
    
    ' Verificar el pin de direcci?n para establecer el sentido de giro
    if dirPin = 1 then
      high dir_salida      ' Direcci?n seg?n entrada dirPin
    else
      low dir_salida
    endif
  else
    ' Mover en sentido negativo (retroceder)
    pasos_mover = pos_actual - pos_destino
    
    ' Verificar el pin de direcci?n para establecer el sentido de giro (invertido)
    if dirPin = 1 then
      low dir_salida       ' Direcci?n seg?n entrada dirPin (invertida)
    else
      high dir_salida
    endif
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
    high estep
    pause pausa_paso
    low estep
    pause pausa_paso
  next temp
  return