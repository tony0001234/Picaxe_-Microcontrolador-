' PICAXE 1 - Transmisor con protocolo handshake
#picaxe 20m2
#terminal 4800

symbol rx_pin = b.0      ' Pin de recepci?n en PICAXE 1
symbol tx_pin = C.0      ' Pin de transmisi?n en PICAXE 1
symbol dato_enviado = b0 ' Variable para almacenar el dato a enviar
symbol dato_recibido = b1 ' Variable para almacenar el dato recibido
symbol signal = c.7
symbol signal_recibida = pinc.6
symbol continuar = "O"
symbol iniciar = "I"
' C?digo para el maestro (fragmento de inicio)
inicio:
    setfreq m8           ' Configura la frecuencia a 8MHz para mejor comunicaci?n
    high B.3           ' LED indicador de "buscando esclavo"
    for b2 = 1 to 20   ' Intenta 20 veces (puedes ajustar)
        serout tx_pin, T4800_8, (iniciar)
        serin rx_pin, T4800_8, dato_recibido
	  if dato_recibido = continuar then
	        low B.3        ' Si llegamos aqu?, se recibi? respuesta
	        goto main      ' Contin?a con programa principal
        endif
        pause 500      ' Pausa antes del siguiente intento
    next b2
    ' Si fall? despu?s de 20 intentos
    for b2 = 1 to 5    ' Parpadea r?pido para indicar fallo de sincronizaci?n
        high B.3
        pause 1000
        low B.3
        pause 1000
    next b2
goto inicio        ' Reintentar desde el principio

main:
	'serout tx_pin, T4800_8, ("P1:", continuar, 13, 10)
	high B.1             ' Indicador de transmisi?n
	pause 1000
	low B.1

	' Espera recibir un dato del otro PICAXE
	'serin rx_pin, T4800_8, ("P2:"), dato_recibido
	high B.2             ' Indicador de recepci?n
	pause 1000
	low B.2

	' Muestra el dato recibido en el terminal
	sertxd ("Recibido de PICAXE 2: ", dato_recibido, 13, 10)
	pause 1000
goto main