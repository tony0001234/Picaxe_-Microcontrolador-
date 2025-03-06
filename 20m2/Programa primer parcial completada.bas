' Definici?n de pines - Driver motor
symbol DIR_PIN = B.0       ' Pin de direcci?n conectado al DRV8825
symbol STEP_PIN = B.1      ' Pin de paso conectado al DRV8825
symbol ENABLE_PIN = B.2    ' Pin de habilitaci?n conectado al DRV8825

' Definici?n de pines - Botones de control
symbol BTN_INICIO = PinC.3    ' Bot?n para iniciar movimiento
symbol BTN_DERECHA = PinC.0   ' Bot?n para giro a derecha
symbol BTN_IZQUIERDA = PinC.1 ' Bot?n para giro a izquierda
symbol BTN_HOME = PinC.2      ' Bot?n para volver al punto de inicio

' Definici?n de pines - Control de velocidad
symbol POT_VELOCIDAD = PinB.3 ' Pin para lectura de potenci?metro
symbol LED_VEL_BAJA = B.5  ' LED para velocidad baja
symbol LED_VEL_MEDIA = B.6 ' LED para velocidad media
symbol LED_VEL_ALTA = B.7  ' LED para velocidad alta

' Variables para c?lculo de pasos
symbol PASOS_POR_CM = 80   ' Pasos requeridos por cent?metro 
' Variables principales
symbol distancia = w1      ' Distancia a mover (en cent?metros)
symbol pasos_totales = w2  ' N?mero total de pasos a dar
symbol pasos_actuales = w3 ' Pasos recorridos actualmente
symbol direccion_home = b0
symbol direccion = b6      ' 0 = derecha, 1 = izquierda
symbol estado = b7         ' Estado del sistema
symbol velocidad = b8      ' Velocidad actual (1=baja, 2=media, 3=alta)
symbol valor_pot = w4      ' Valor le?do del potenci?metro
symbol pausa_paso = b9     ' Valor de pausa entre pasos

' Inicializaci?n
inicio:
  low ENABLE_PIN   ' Habilitar driver stepper
  low DIR_PIN      ' Direcci?n inicial derecha
  
  ' Inicializar LEDs de velocidad (velocidad media por defecto)
  low LED_VEL_BAJA
  high LED_VEL_MEDIA
  low LED_VEL_ALTA
  velocidad = 2
  pausa_paso = 5   ' Valor medio por defecto
  direccion = 0
  direccion_home = 1
  
  ' Enviar mensaje de bienvenida
  sertxd("Controlador de Motor Stepper", cr, lf)

  wait 1

' Bucle principal
bucle_principal:  

  ' Verificar botones
  gosub verificar_botones
  
  ' Verificar potenci?metro y ajustar velocidad
  gosub verificar_velocidad
  
  pause 50  ' Peque?a pausa para estabilidad
goto bucle_principal

' Subrutina para verificar botones
verificar_botones:
  ' Bot?n de inicio de movimiento
  if BTN_INICIO = 1 then
    do
	    pause 50
    loop until BTN_INICIO = 0
	    
    ' Verificar entrada serial
    gosub verificar_entrada_serial
	  
    gosub verificar_direccion
	  
    gosub mover_distancia
  endif
  
  ' Bot?n de giro a derecha
  if BTN_DERECHA = 1 then
    do
	    pause 50
    loop until BTN_DERECHA = 0

    direccion = 0
    direccion_home = 1
    low DIR_PIN
    sertxd("Direccion: Derecha", cr, lf)
  endif
  
  ' Bot?n de giro a izquierda
  if BTN_IZQUIERDA = 1 then
    do
	    pause 50
    loop until BTN_IZQUIERDA = 0

    direccion = 1
    direccion_home = 0
    high DIR_PIN
    sertxd("Direccion: Izquierda", cr, lf)
  endif
  
  ' Bot?n de retorno a punto de inicio (home)
  if BTN_HOME = 1 then
    do
	    pause 50
    loop until BTN_HOME = 0
	  
    gosub volver_home
  endif
  
return
  
' Subrutina para verificar entrada serial
verificar_entrada_serial:
  sertxd("Ingrese distancia en centimetros: ", cr, lf)
' Leer dato serial
  serrxd distancia
  
  if distancia > 0 then
    ' C?lculo de los pasos necesarios
    pasos_totales = distancia * PASOS_POR_CM

    ' Enviar resultados por HyperTerminal
    sertxd("Distancia ingresada: ", #distancia, " cm", 13, 10)
    sertxd("Pasos necesarios: ", #pasos_totales, 13, 10)
  else
    sertxd("Error: La distancia debe ser mayor a 0.", 13, 10)
  endif
return

' Subrutina para verificar potenci?metro y ajustar velocidad
verificar_velocidad:
  ' Leer valor del potenci?metro (0-255)
  readadc B.3, valor_pot
  
  ' Determinar nivel de velocidad basado en rango del potenci?metro
  if valor_pot < 85 then  ' 0-84: Velocidad baja
    if velocidad != 1 then
      velocidad = 1
      pausa_paso = 10  ' Pausa larga entre pasos (m?s lento)
      
      ' Actualizar LEDs
      high LED_VEL_BAJA
      low LED_VEL_MEDIA
      low LED_VEL_ALTA

    endif
  elseif valor_pot < 170 then  ' 85-169: Velocidad media
    if velocidad != 2 then
      velocidad = 2
      pausa_paso = 5   ' Pausa media entre pasos
      
      ' Actualizar LEDs
      low LED_VEL_BAJA
      high LED_VEL_MEDIA
      low LED_VEL_ALTA
	
    endif
  else  ' 170-255: Velocidad alta
    if velocidad != 3 then
      velocidad = 3
      pausa_paso = 2   ' Pausa corta entre pasos (m?s r?pido)
      
      ' Actualizar LEDs
      low LED_VEL_BAJA
      low LED_VEL_MEDIA
      high LED_VEL_ALTA
      
    endif
  endif
  
  return

' Subrutina para mover distancia especificada
mover_distancia:
  ' Verificar si hay distancia configurada
  if pasos_totales = 0 then
    sertxd("Error: Distancia no configurada", cr, lf)
    return
  endif
  
  ' Informar inicio de movimiento y velocidad
  sertxd("Iniciando movimiento a velocidad ", #velocidad, cr, lf)
  
    ' Verificar si la velocidad ha cambiado durante el movimiento
    gosub verificar_velocidad
  
  ' Ciclo de movimiento
  for pasos_actuales = 0 to pasos_totales
    high STEP_PIN
    pause pausa_paso  ' Usar el valor de pausa seg?n la velocidad
    low STEP_PIN
    pause pausa_paso  ' Usar el valor de pausa seg?n la velocidad

  next pasos_actuales
  
  ' Informar fin de movimiento
  sertxd("Movimiento completado", cr, lf)
  
  return

verificar_direccion:

	if direccion = 0 then
		  direccion_home = 1
		  low DIR_PIN
		  sertxd("moviendo con valor de direccion_home if = ", direccion_home, cr, lf)
	endif
	if direccion = 1 then
		  direccion_home = 0
		  high DIR_PIN
		  sertxd("moviendo con valor de direccion_home if = ", direccion_home, cr, lf)
	endif

return

' Subrutina para volver al punto de inicio
volver_home:
  pause 50
  
  ' Verificar si la velocidad ha cambiado durante el movimiento
  gosub verificar_velocidad
  
    ' Informar inicio de retorno y velocidad
  sertxd("Retornando al inicio a velocidad ", #velocidad, cr, lf)
  
  gosub verificar_direccion
  
  ' Configurar direcci?n opuesta al ?ltimo movimiento
  if direccion_home = 0 then
	  low DIR_PIN  ' Direcci?n derecha
	  direccion = 1
	  sertxd("moviendo con valor de direccion_home if = ", direccion_home, cr, lf)
  endif
  if direccion_home = 1 then
  	  high DIR_PIN  ' Direcci?n izquierda
	  direccion = 0
	  sertxd("moviendo con valor de direccion_home else = ", direccion_home, cr, lf)
  endif
  
  for pasos_actuales = 0 to pasos_totales
    high STEP_PIN
    pause pausa_paso  ' Usar el valor de pausa seg?n la velocidad
    low STEP_PIN
    pause pausa_paso  ' Usar el valor de pausa seg?n la velocidad
    
  next pasos_actuales
  
  ' Reiniciar distancia total
  pasos_totales = 0
  
  ' Informar retorno
  sertxd("Retorno al punto inicial completado", cr, lf)
  pause 50

  return