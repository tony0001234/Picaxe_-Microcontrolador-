' PICAXE 1 - Transmisor/Receptor
#picaxe 20m2
#terminal 9600

symbol rx_pin = b.0      ' Pin de recepci?n en PICAXE 1
symbol tx_pin = C.0      ' Pin de transmisi?n en PICAXE 1
symbol dato_enviado = b0 ' Variable para almacenar el dato a enviar
symbol dato_recibido = b1 ' Variable para almacenar el dato recibido
symbol counter = b2      ' Contador para enviar diferentes valores
symbol signal = c.7
symbol signal_recibida = pinc.6
symbol buffer = "O"
inicio:
    setfreq m8           ' Configura la frecuencia a 8MHz para mejor comunicaci?n
    high B.3             ' LED indicador de encendido
    pause 1000           ' Espera inicial
main:
    ' Env?a un dato al otro PICAXE
    dato_enviado = counter
    high signal
    if signal_recibida = 1 then
	    serout tx_pin, T4800_8, ("P1:", buffer, 13, 10)
	    high B.1             ' Indicador de transmisi?n
	    pause 100
	    low B.1
	    
	    ' Espera recibir un dato del otro PICAXE
	    serin rx_pin, T4800_8, ("P2:"), dato_recibido
	    high B.2             ' Indicador de recepci?n
	    pause 100
	    low B.2
	    
	    ' Muestra el dato recibido en el terminal
	    sertxd ("Recibido de PICAXE 2: ", dato_recibido, 13, 10)
    endif
    ' Incrementa el contador para el pr?ximo env?o
    inc counter
    if counter > 100 then
        counter = 0
    endif
    
    pause 1000
goto main