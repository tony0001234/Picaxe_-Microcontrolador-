#picaxe 20m2
' Programa para controlar motor stepper bipolar 17PM-K077BP03CN
' utilizando el driver DRV8825 con PICAXE 20M2
' Con control de velocidad, botones de l?mite y cambio de direcci?n

' Definici?n de pines - Driver motor
symbol DIR_PIN = B.0      ' Pin de direcci?n conectado al DRV8825
symbol STEP_PIN = B.1     ' Pin de paso conectado al DRV8825
symbol ENABLE_PIN = B.2   ' Pin de habilitaci?n conectado al DRV8825

' Definici?n de pines - Botones
symbol BTN_DIR = PinC.0      ' Bot?n para cambiar direcci?n
symbol BTN_VEL_UP = PinC.1   ' Bot?n para aumentar velocidad
symbol BTN_VEL_DOWN = PinC.2 ' Bot?n para disminuir velocidad
symbol TOPE_DER = PinC.3     ' Bot?n de tope derecho
symbol TOPE_IZQ = PinC.4     ' Bot?n de tope izquierdo

symbol BTN_EMERGENCIA = PinC.7

' Definici?n de pines - LEDs indicadores de velocidad
symbol LED_VEL_BAJA = B.5  ' LED para velocidad baja
symbol LED_VEL_MEDIA = B.6 ' LED para velocidad media
symbol LED_VEL_ALTA = B.7  ' LED para velocidad alta

' Valores de retardo para las velocidades (ms)
symbol DELAY_VEL_BAJA = 10  ' Retardo para velocidad baja
symbol DELAY_VEL_MEDIA = 5  ' Retardo para velocidad media
symbol DELAY_VEL_ALTA = 2   ' Retardo para velocidad alta

' Variables
symbol direccion = b0     ' 0 = sentido horario (derecha), 1 = sentido antihorario (izquierda)
symbol velocidad = b1     ' 0 = baja, 1 = media, 2 = alta
symbol delay_actual = b2  ' Valor actual del retardo
symbol estado_motor = b3  ' 0 = detenido, 1 = en movimiento
symbol contador = b4      ' Contador para bucles

' Inicializaci?n
inicio:
  ' Valores iniciales
  low ENABLE_PIN      ' Habilitar driver (activo bajo)
  low DIR_PIN         ' Direcci?n inicial (derecha)
  direccion = 1       ' 0 = sentido derecha 1 = izquirda
  velocidad = 1       ' Iniciar en velocidad media
  delay_actual = DELAY_VEL_MEDIA
  estado_motor = 1    ' Motor inicialmente en movimiento
  
  ' Configurar LEDs de velocidad
  low LED_VEL_BAJA
  high LED_VEL_MEDIA  ' LED de velocidad media encendido al inicio
  low LED_VEL_ALTA
  
  pause 1000          ' Esperar 1 segundo para estabilizar

' Bucle principal
bucle_principal:

  if BTN_EMERGENCIA = 1 then
	  wait 10
	do 
		wait 10
	loop until BTN_EMERGENCIA = 0
  endif

  ' Verificar botones de tope
  if direccion = 0 and TOPE_DER = 1 then   ' Si va a la derecha y se presiona tope derecho
    estado_motor = 0                       ' Detener motor
  endif
  
  if direccion = 1 and TOPE_IZQ = 1  then   ' Si va a la izquierda y se presiona tope izquierdo
    estado_motor = 0                       ' Detener motor
  endif
  
  ' Verificar bot?n de cambio de direcci?n
  if BTN_DIR = 1 then
    
      do
	      pause 10           ' Esperar hasta que se suelte el bot?n
	  loop until BTN_DIR = 0
	  'if BTN_DIR = 0 then return
	  select direccion
		case 0
		  low DIR_PIN  ' Direcci?n derecha
		case 1
	  	  high DIR_PIN  ' Direcci?n izquierda
	  endselect
	  
	  direccion = 1 - direccion
	  
	  ' Restablecer estado del motor
	  estado_motor = 1
		pause 50
  endif
  
  ' Verificar botones de velocidad
  if BTN_VEL_UP = 1 then
    gosub aumentar_velocidad
  endif
  
  if BTN_VEL_DOWN = 1 then
    gosub disminuir_velocidad
  endif
  
  ' Mover motor si est? activo
  if estado_motor = 1 then
    gosub paso_motor
  endif
  
  ' Peque?a pausa para estabilidad
  pause 10
  goto bucle_principal

' Subrutina para dar un paso al motor
paso_motor:
  high STEP_PIN
  pause delay_actual
  low STEP_PIN
  pause delay_actual
  return
  
' Subrutina para aumentar velocidad
aumentar_velocidad:
  ' Debounce para evitar m?ltiples detecciones
  pause 50
  'if BTN_VEL_UP = 0 then return
  
  ' Aumentar velocidad si no est? en m?xima
  if velocidad < 2 then
    velocidad = velocidad + 1
    gosub actualizar_velocidad
  endif
  
  do
      pause 10           ' Esperar hasta que se suelte el bot?n
  loop until BTN_VEL_UP = 0
  return

' Subrutina para disminuir velocidad
disminuir_velocidad:
  ' Debounce para evitar m?ltiples detecciones
  pause 50
  'if BTN_VEL_DOWN = 0 then return
  
  ' Disminuir velocidad si no est? en m?nima
  if velocidad > 0 then
    velocidad = velocidad - 1
    gosub actualizar_velocidad
  endif

  do
      pause 10           ' Esperar hasta que se suelte el bot?n
  loop until BTN_VEL_DOWN = 0
  return

' Subrutina para actualizar velocidad
actualizar_velocidad:
  ' Establecer retardo seg?n velocidad
  select velocidad
    case 0
      delay_actual = DELAY_VEL_BAJA
      high LED_VEL_BAJA
      low LED_VEL_MEDIA
      low LED_VEL_ALTA
    case 1
      delay_actual = DELAY_VEL_MEDIA
      low LED_VEL_BAJA
      high LED_VEL_MEDIA
      low LED_VEL_ALTA
    case 2
      delay_actual = DELAY_VEL_ALTA
      low LED_VEL_BAJA
      low LED_VEL_MEDIA
      high LED_VEL_ALTA
  endselect
  return