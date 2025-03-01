symbol MOTOR_PIN1 = B.0    ' Pin para fase 1 del motor
symbol MOTOR_PIN2 = B.1    ' Pin para fase 2 del motor
symbol MOTOR_PIN3 = B.2    ' Pin para fase 3 del motor
symbol MOTOR_PIN4 = B.3    ' Pin para fase 4 del motor

symbol BTN_PARAR = C.2            ' Bot?n para parar motor
symbol BTN_CONTINUAR = C.3        ' Bot?n para continuar giro
symbol BTN_RESET = C.4            ' Bot?n para resetear

symbol paso = b2           ' Variable para seguimiento del paso actual
symbol estado_motor = b3   ' Estado del motor: 0 = parado, 1 = girando

' Inicializaci?n
inicio:
    let paso = 0
    let estado_motor = 1   ' Iniciar con el motor girando
    
    ' Configuraci?n de pines
    let dirsB = %00001111  ' Configurar pines del motor como salidas
    let dirsC = %00000000  ' Configurar pines de botones como entradas
    pullup %11111     ' Habilitar resistencias pull-up para los botones en puerto C
    
    pause 500
    
goto bucle_principal
    

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
    
    ' Verificar bot?n de parada
    if pinC.2 = 1 then
        let estado_motor = 0
        ' Apagar todas las bobinas
        low MOTOR_PIN1
        low MOTOR_PIN2
        low MOTOR_PIN3
        low MOTOR_PIN4

          do
	        pause 10
	    loop until pinC.2 = 0
    endif
    
    ' Verificar bot?n de continuar
    if pinC.3 = 1 then
        let estado_motor = 1
          do
	        pause 10
	    loop until pinC.3 = 0
    endif
    
    ' Verificar bot?n de reset
    if pinC.4 = 1 then
        ' Reiniciar variables
        let paso = 0
        let estado_motor = 1
	    
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
    let paso = paso + 1
    if paso > 7 then
        let paso = 0
    endif
    
    ' Pausa para controlar la velocidad
    pause 40
    
    return