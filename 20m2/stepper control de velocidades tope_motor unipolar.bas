

#picaxe 20m2

' Definici?n de constantes y variables
symbol MOTOR_PIN1 = B.0    ' Pin para fase 1 del motor
symbol MOTOR_PIN2 = B.1    ' Pin para fase 2 del motor
symbol MOTOR_PIN3 = B.2    ' Pin para fase 3 del motor
symbol MOTOR_PIN4 = B.3    ' Pin para fase 4 del motor
symbol LED_HIGH = B.5
symbol LED_MID = B.6
symbol LED_LOW = B.7

symbol BTN_VELOCIDAD_MAS = C.0    ' Bot?n para aumentar velocidad
symbol BTN_VELOCIDAD_MENOS = C.1  ' Bot?n para disminuir velocidad
symbol BTN_PARAR = C.2            ' Bot?n para parar motor
symbol BTN_CONTINUAR = C.3        ' Bot?n para continuar giro
symbol BTN_RESET = C.4            ' Bot?n para resetear

' Variables
symbol velocidad = w0      ' Variable para almacenar la velocidad (word - 16 bits)
symbol paso = b2           ' Variable para seguimiento del paso actual
symbol estado_motor = b3   ' Estado del motor: 0 = parado, 1 = girando
symbol giro = b4		   ' Giro del motor: 0 = derecha, 1 = izquierda

' Inicializaci?n
inicio:
    let velocidad = 25     ' Velocidad inicial (ms entre pasos)
    let paso = 0
    let estado_motor = 1   ' Iniciar con el motor girando
    let giro = 0
    
    ' Configuraci?n de pines
    let dirsB = %00001111  ' Configurar pines del motor como salidas
    let dirsC = %00000000  ' Configurar pines de botones como entradas
    pullup %11111     ' Habilitar resistencias pull-up para los botones en puerto C
    
    pause 500
    HIGH LED_MID
    
    goto bucle_principal

' Bucle principal
bucle_principal:
    ' Verificar botones
    gosub verificar_botones
    
    ' Si el motor debe girar
    if estado_motor = 1 then
        gosub mover_motor
    endif
    
    goto bucle_principal

' Rutina para verificar el estado de los botones
verificar_botones:
    ' Verificar bot?n para aumentar velocidad
    if pinC.0 = 1 then
	    
	    	select velocidad
		    case 25: velocidad = 5
			    HIGH LED_HIGH
			    LOW LED_MID
			    LOW LED_LOW
		    case 45: velocidad = 25
			    LOW LED_HIGH
			    HIGH LED_MID
			    LOW LED_LOW
		end select

        do
	        pause 10
	    loop until pinC.0 = 0
    endif
    
    ' Verificar bot?n para disminuir velocidad
    if pinC.1 = 1 then
	    
	  	select velocidad
		    case 25: velocidad = 45
			    LOW LED_HIGH
			    LOW LED_MID
			    HIGH LED_LOW
		    case 5: velocidad = 25
			    LOW LED_HIGH
			    HIGH LED_MID
			    LOW LED_LOW
		end select
          
	    do
	        pause 10
	    loop until pinC.1 = 0
    endif
    
    ' Verificar bot?n de parada
    if pinC.2 = 1 then
        let estado_motor = 0
	  if giro = 0 then
		  let giro = 1
	  else
	  	let giro = 0
	  endif
        ' Apagar todas las bobinas
        low MOTOR_PIN1
        low MOTOR_PIN2
        low MOTOR_PIN3
        low MOTOR_PIN4
	  
	  LOW LED_HIGH
	  LOW LED_MID
	  LOW LED_LOW
          do
	        pause 10
	    loop until pinC.2 = 0
    endif
    
    ' Verificar bot?n de continuar
    if pinC.3 = 1 then
        let estado_motor = 1
	  HIGH LED_MID
	  velocidad = 25
          do
	        pause 10
	    loop until pinC.3 = 0
    endif
    
    ' Verificar bot?n de reset
    if pinC.4 = 1 then
        ' Reiniciar variables
        let velocidad = 25
        let paso = 0
        let estado_motor = 1
	  
	  LOW LED_HIGH
	  HIGH LED_MID
	  LOW LED_LOW
	  
          do
	        pause 10
	    loop until pinC.4 = 0
    endif
    
    return

' Rutina para mover el motor
mover_motor:
    ' Secuencia para el motor stepper 28BYJ-48 (secuencia Half-step)
    select paso
        case 0
            high MOTOR_PIN1
            low MOTOR_PIN2
            low MOTOR_PIN3
            low MOTOR_PIN4
        case 1
            high MOTOR_PIN1
            high MOTOR_PIN2
            low MOTOR_PIN3
            low MOTOR_PIN4
        case 2
            low MOTOR_PIN1
            high MOTOR_PIN2
            low MOTOR_PIN3
            low MOTOR_PIN4
        case 3
            low MOTOR_PIN1
            high MOTOR_PIN2
            high MOTOR_PIN3
            low MOTOR_PIN4
        case 4
            low MOTOR_PIN1
            low MOTOR_PIN2
            high MOTOR_PIN3
            low MOTOR_PIN4
        case 5
            low MOTOR_PIN1
            low MOTOR_PIN2
            high MOTOR_PIN3
            high MOTOR_PIN4
        case 6
            low MOTOR_PIN1
            low MOTOR_PIN2
            low MOTOR_PIN3
            high MOTOR_PIN4
        case 7
            high MOTOR_PIN1
            low MOTOR_PIN2
            low MOTOR_PIN3
            high MOTOR_PIN4
    end select
    
    ' Incrementar paso para el siguiente ciclo
    if giro = 0 then 
	    let paso = paso +1
    else
	    let paso = paso -1
    endif
    if paso > 7 then
        let paso = 0
    elseif paso < 0 then
	  let paso = 7
    endif
    
    ' Pausa para controlar la velocidad
    pause velocidad
    
    return