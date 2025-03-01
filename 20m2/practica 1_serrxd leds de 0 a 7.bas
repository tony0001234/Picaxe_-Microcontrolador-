#picaxe 20m2

' Comunicaci?n serial a 4800 baud (N,8,1)
' Uso de TX y RX para recibir n?meros de 0 a 7
' Pines B.0 a B.7 conectados a LEDs
' C.0 = Bot?n RESET
' C.1 = Bot?n TEST

' Variables
symbol led_actual = b0     ' LED actualmente activo (0-7)
symbol recibido = b1       ' Dato recibido por serial
symbol modo = b2           ' 0 = normal, 1 = modo test
symbol direccion = b3      ' 0 = ascendente, 1 = descendente (para modo test)
symbol btn_reset = pinC.0  ' Bot?n de reset
symbol btn_test = pinC.1   ' Bot?n de test
symbol mascara = b4        ' Variable para la m?scara de bits

inicio:
    ' Configuraci?n inicial
    setfreq m8              ' Configurar a 8MHz para mejor precisi?n en comunicaci?n serial
    
    ' Configurar pines
    let dirsB = %11111111   ' Configurar puerto B como salidas (LEDs)
    let dirsC = %00000000   ' Configurar puerto C como entradas (botones)
    pullup %00000011  ' Habilitar pull-ups para C.0 y C.1
    
    ' Inicializaci?n variables
    let led_actual = 0
    let modo = 0
    let direccion = 0
    
    ' Apagar todos los LEDs
    let outpinsB = %00000000
    
    ' Configuraci?n serial
    sertxd("Sistema Iniciado. Envie numeros del 0-7",cr,lf)
    
bucle_principal:
    ' Revisar botones
    gosub revisar_botones
    
    ' Verificar si hay datos en la entrada serial
    if modo = 0 then        ' Solo recibir serial si no estamos en modo test
        ' Comprobar si hay datos disponibles
        serrxd (recibido)   ' Instrucci?n serrxd en lugar de serin2
        
        ' Verificar si el n?mero est? en el rango v?lido (0-7)
        if recibido >= "0" and recibido <= "7" then
            ' Convertir de ASCII a n?mero (restar 48)
            let led_actual = recibido - 48
            
            ' Mostrar LED correspondiente
            gosub actualizar_led
            
            ' Enviar confirmaci?n
            sertxd("LED ", #led_actual, " activado", cr, lf)
        else
            ' Valor inv?lido
            sertxd("Valor invalido. Use 0-7", cr, lf)
        endif
    endif
    
    ' Si est? en modo test, ejecutar la secuencia
    if modo = 1 then
        gosub ejecutar_test
    endif
    
    goto bucle_principal

' Subrutina para revisar estado de botones
revisar_botones:
    ' Bot?n de reset
    if btn_reset = 0 then
        ' Reiniciar todo
        let led_actual = 0
        let modo = 0
        let outpinsB = %00000000
        sertxd("Sistema reiniciado", cr, lf)
        pause 200  ' debounce
    endif
    
    ' Bot?n de test
    if btn_test = 0 then
        ' Cambiar a modo test
        let modo = 1
        let led_actual = 0
        let direccion = 0
        sertxd("Iniciando modo TEST", cr, lf)
        pause 200  ' debounce
    endif
    
    return

' Subrutina para actualizar el LED activo
actualizar_led:
    ' Apagar todos los LEDs primero
    let outpinsB = %00000000
    
    ' Seleccionar la m?scara correcta basada en led_actual
    lookup led_actual, (%00000001, %00000010, %00000100, %00001000, %00010000, %00100000, %01000000, %10000000), mascara
    
    ' Encender solo el LED seleccionado
    let outpinsB = mascara
    
    return

' Subrutina para ejecutar secuencia de test
ejecutar_test:
    ' Encender LED actual
    gosub actualizar_led
    
    ' Esperar 500ms (frecuencia de 1Hz)
    pause 500
    
    ' Actualizar a siguiente LED seg?n direcci?n
    if direccion = 0 then
        ' Direcci?n ascendente
        inc led_actual
        if led_actual > 7 then
            let led_actual = 7
            let direccion = 1
        endif
    else
        ' Direcci?n descendente
        dec led_actual
        if led_actual > 7 then  ' Overflow cuando led_actual es 255 (despu?s de decrementar 0)
            let led_actual = 0
            let direccion = 0
            
            ' Fin del ciclo completo, volver al modo normal
            let modo = 0
            let outpinsB = %00000000
            sertxd("Modo TEST finalizado", cr, lf)
        endif
    endif
    
    return