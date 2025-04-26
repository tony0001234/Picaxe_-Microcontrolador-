' PICAXE 2 - Receptor/Transmisor
#picaxe 20m2
#terminal 9600

symbol rx_pin = b.0      ' Pin de recepci?n en PICAXE 2
symbol tx_pin = C.0      ' Pin de transmisi?n en PICAXE 2
symbol dato_enviado = b0 ' Variable para almacenar el dato a enviar
symbol dato_recibido = b1 ' Variable para almacenar el dato recibido
symbol counter = b2      ' Contador para enviar diferentes valores
symbol signal = c.7
symbol signal_recibida = pinc.6

symbol continuar = "O"
symbol buffer = "I"
inicio:
    setfreq m8           ' Configura la frecuencia a 8MHz para mejor comunicaci?n
    high B.6             ' LED indicador de encendido
    pause 1000           ' Espera inicial
    counter = 50         ' Inicia el contador en un valor diferente

main:
if signal_recibida = 1 then
	high signal
'serin rx_pin, T4800_8, ("P1:", dato_recibido,13,10)
'    if dato_recibido = continuar then
	    
	    ' Espera recibir un dato del PICAXE 1
	    do
		    do
	    serin rx_pin, T4800_8, ("P1:"), dato_recibido
	    high b.1            ' Indicador de recepci?n
	    pause 100
	    low b.1
	    loop until dato_recibido = continuar
	    ' Muestra el dato recibido en el terminal
	    sertxd ("Recibido de PICAXE 1: ", dato_recibido, 13, 10)
	    
	    ' Env?a un dato al PICAXE 1
	    dato_enviado = counter
	    serout tx_pin, T4800_8, ("P2:", buffer, 13, 10)
	    high b.2            ' Indicador de transmisi?n
	    pause 100
	    low b.2
	    loop until signal_recibida = 0
    endif
'    endif
    ' Incrementa el contador para el pr?ximo env?o
    inc counter
    if counter > 150 then
        counter = 50
    endif
    
    pause 1000
    goto main