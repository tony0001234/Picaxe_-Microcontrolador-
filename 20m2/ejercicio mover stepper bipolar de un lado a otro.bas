symbol DIR_PIN = B.0 
symbol STEP_PIN = B.1 
symbol ENABLE_PIN = B.2 
symbol DELAY_VAL = 5     ' Valor de retardo entre pasos (ms)
symbol PASOS = 200       ' N?mero de pasos para una vuelta completa

symbol contador = b0
symbol direccion = b1    ' 0 = sentido horario, 1 = sentido antihorario

inicio:
  low ENABLE_PIN         ' Habilitar driver (activo bajo)
  low DIR_PIN            ' Direcci?n inicial (sentido horario)
  direccion = 0          ' Establecer direcci?n inicial a horario
  pause 1000             ' Esperar 1 segundo para estabilizar

bucle_principal:
  ' Mover en direcci?n actual
  gosub mover_motor
  
  ' Cambiar direcci?n
  direccion = 1 - direccion    ' Alternar entre 0 y 1
  if direccion = 0 then
    low DIR_PIN
  else
    high DIR_PIN
  endif
  
  ' Esperar antes de volver a mover
  pause 2000             ' Esperar 2 segundos entre movimientos
  
  goto bucle_principal   ' Repetir indefinidamente

mover_motor:
  ' Realizar una secuencia de pasos
  for contador = 1 to PASOS
    high STEP_PIN        ' Establecer pin de paso en alto
    pause DELAY_VAL      ' Mantener paso
    low STEP_PIN         ' Establecer pin de paso en bajo
    pause DELAY_VAL      ' Esperar antes del siguiente paso
  next contador
  return