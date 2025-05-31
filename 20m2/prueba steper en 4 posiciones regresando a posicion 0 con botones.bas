#picaxe 40x2
#terminal 9600

' Definici?n de botones
symbol boton1 = pinA.0      ' Bot?n 1 - Posici?n 0? (no se mueve)
symbol boton2 = pinA.1      ' Bot?n 2 - Posici?n 45? (45 pasos)
symbol boton3 = pinA.2      ' Bot?n 3 - Posici?n 200? (111 pasos)
symbol boton4 = pinA.3      ' Bot?n 4 - Posici?n 300? (167 pasos)

' Pines control del motor stepper
symbol dir_salida = d.2     ' Direcci?n
symbol enable = c.4         ' Enable para el driver
symbol estep = d.3         ' Paso

' LEDs indicadores (opcional)
symbol led_estado = c.0     ' LED para indicar estado general
symbol led_pos1 = a.5       ' LED indicador posici?n 1
symbol led_pos2 = a.6       ' LED indicador posici?n 2
symbol led_pos3 = a.7       ' LED indicador posici?n 3
symbol led_pos4 = b.0       ' LED indicador posici?n 4

' Constantes para posiciones en pasos
symbol POS_CERO = 0         ' Posici?n 0?
symbol POS_45 = 45          ' Posici?n 45? (45 pasos)
symbol POS_200 = 111        ' Posici?n 200? (111 pasos)
symbol POS_300 = 167        ' Posici?n 300? (167 pasos)

' Variables de operaci?n para el stepper
symbol pausa_paso = 3       ' Tiempo de pausa entre pasos (ms)
symbol pos_actual = w0      ' Posici?n actual del motor
symbol pos_destino = w1     ' Posici?n destino a alcanzar
symbol pasos_mover = w2     ' Cantidad de pasos a mover
symbol i = b0               ' Variable de iteraci?n

' Inicializaci?n del sistema
inicio:
    setfreq m8              ' Configurar frecuencia a 8MHz para estabilidad
    
    ' Configuraci?n inicial del motor
    high enable             ' Deshabilitar el motor al inicio (l?gica invertida)
    low estep               ' Asegurar que el pulso de paso est? en bajo
    pos_actual = POS_CERO   ' Iniciar en posici?n cero
    
    ' Configurar LEDs iniciales
    low led_estado
    low led_pos1
    low led_pos2
    low led_pos3
    low led_pos4
    
    ' Secuencia de inicio
    sertxd("Sistema iniciado - Control de Motor Stepper",13,10)
    sertxd("Presione un bot?n para mover el motor:",13,10)
    sertxd("Bot?n 1: Posici?n 0?",13,10)
    sertxd("Bot?n 2: Posici?n 45? (45 pasos)",13,10)
    sertxd("Bot?n 3: Posici?n 200? (111 pasos)",13,10)
    sertxd("Bot?n 4: Posici?n 300? (167 pasos)",13,10)
    
    ' Parpadeo de LED de estado para indicar que est? listo
    for i = 1 to 3
        high led_estado
        pause 200
        low led_estado
        pause 200
    next i
    high led_estado  ' Mantener encendido para indicar que est? listo

' Bucle principal
bucle_principal:
    ' Verificar cada bot?n
    gosub verificar_botones
    pause 50  ' Peque?a pausa para estabilidad
    goto bucle_principal

' Subrutina para verificar el estado de los botones
verificar_botones:
    ' Verificar bot?n 1 - Posici?n 0?
    if boton1 = 0 then
        ' Esperar a que el bot?n se suelte (debounce)
        do
            pause 20
        loop until boton1 = 0
        
        ' Encender LED correspondiente
        low led_pos1
        low led_pos2
        low led_pos3
        low led_pos4
        high led_pos1
        
        sertxd("Bot?n 1 presionado - Posici?n 0?",13,10)
        pos_destino = POS_CERO
        gosub mover_motor
    endif
    
    ' Verificar bot?n 2 - Posici?n 45?
    if boton2 = 1 then
        ' Esperar a que el bot?n se suelte (debounce)
        do
            pause 20
        loop until boton2 = 0
        
        ' Encender LED correspondiente
        low led_pos1
        low led_pos2
        low led_pos3
        low led_pos4
        high led_pos2
        
        sertxd("Bot?n 2 presionado - Posici?n 45?",13,10)
        pos_destino = POS_45
        gosub mover_motor
        
        ' Esperar un momento antes de regresar a cero
        pause 1000
        sertxd("Regresando a posici?n 0?...",13,10)
        pos_destino = POS_CERO
        gosub mover_motor
        high led_pos1  ' Indicar regreso a posici?n 1
    endif
    
    ' Verificar bot?n 3 - Posici?n 200?
    if boton3 = 1 then
        ' Esperar a que el bot?n se suelte (debounce)
        do
            pause 20
        loop until boton3 = 0
        
        ' Encender LED correspondiente
        low led_pos1
        low led_pos2
        low led_pos3
        low led_pos4
        high led_pos3
        
        sertxd("Bot?n 3 presionado - Posici?n 200?",13,10)
        pos_destino = POS_200
        gosub mover_motor
        
        ' Esperar un momento antes de regresar a cero
        pause 1000
        sertxd("Regresando a posici?n 0?...",13,10)
        pos_destino = POS_CERO
        gosub mover_motor
        high led_pos1  ' Indicar regreso a posici?n 1
    endif
    
    ' Verificar bot?n 4 - Posici?n 300?
    if boton4 = 1 then
        ' Esperar a que el bot?n se suelte (debounce)
        do
            pause 20
        loop until boton4 = 0
        
        ' Encender LED correspondiente
        low led_pos1
        low led_pos2
        low led_pos3
        low led_pos4
        high led_pos4
        
        sertxd("Bot?n 4 presionado - Posici?n 300?",13,10)
        pos_destino = POS_300
        gosub mover_motor
        
        ' Esperar un momento antes de regresar a cero
        pause 1000
        sertxd("Regresando a posici?n 0?...",13,10)
        pos_destino = POS_CERO
        gosub mover_motor
        high led_pos1  ' Indicar regreso a posici?n 1
    endif
return

' Subrutina para mover el motor desde la posici?n actual a la posici?n destino
mover_motor:
    ' Antes de mover, habilitar el driver
    low enable              ' Habilitar el motor (l?gica invertida)
    
    ' Determinar direcci?n y pasos a mover
    if pos_destino > pos_actual then
        ' Mover en sentido positivo (avanzar)
        pasos_mover = pos_destino - pos_actual
        high dir_salida     ' Direcci?n para avanzar
        sertxd("Moviendo ", #pasos_mover, " pasos hacia adelante",13,10)
    else
        ' Mover en sentido negativo (retroceder)
        pasos_mover = pos_actual - pos_destino
        low dir_salida      ' Direcci?n para retroceder
        sertxd("Moviendo ", #pasos_mover, " pasos hacia atr?s",13,10)
    endif

    ' Solo realizar pasos si hay que moverse
    if pasos_mover > 0 then
        gosub realizar_pasos
    else
        sertxd("Ya est? en la posici?n solicitada",13,10)
    endif

    ' Actualizar la posici?n actual
    pos_actual = pos_destino
    sertxd("Posici?n actual: ", #pos_actual, " pasos",13,10)
    
    ' Despu?s de mover, deshabilitar el driver para ahorrar energ?a
    high enable             ' Deshabilitar motor (l?gica invertida)
return

' Subrutina para realizar los pasos calculados
realizar_pasos:
    ' Parpadear LED de estado durante el movimiento
    low led_estado
    
    ' Realizar los pasos necesarios
    for i = 1 to pasos_mover
        ' Generar pulso para un paso
        high estep
        pause 5
        low estep
        pause 5
        
        ' Parpadear LED cada 10 pasos para mostrar actividad
      '  if i // 10 = 0 then
      '      high led_estado
      '      pause 5
      '      low led_estado
      '  endif
    next i
    
    ' Encender LED de estado al finalizar
    high led_estado
    
    ' Peque?a pausa para estabilizaci?n
    pause 100
return