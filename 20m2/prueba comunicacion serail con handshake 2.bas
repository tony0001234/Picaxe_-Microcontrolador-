' PICAXE 2 - Receptor/Transmisor con protocolo handshake
#picaxe 20m2
#terminal 4800
symbol rx_pin = b.0      ' Pin de recepci?n en PICAXE 2
symbol tx_pin = C.0      ' Pin de transmisi?n en PICAXE 2
symbol dato_enviado = b0 ' Variable para almacenar el dato a enviar
symbol dato_recibido = b1 ' Variable para almacenar el dato recibido
symbol signal = c.7
symbol signal_recibida = pinc.6
symbol continuar = "O"
symbol iniciar = "I"
' C?digo para el esclavo (fragmento de inicio)
inicio:
    setfreq m8
    high b.6
    ' Primero se configura para escuchar la se?al SYNC
    serin rx_pin, T4800_8, dato_recibido
    ' Si recibe SYNC, responde con AC
    if dato_recibido = continuar then
	    serout tx_pin, T4800_8, (continuar)
	    goto main
    endif
    for b2 = 1 to 5    ' Parpadea r?pido para indicar fallo de sincronizaci?n
        high B.6
        pause 1000
        low B.6
        pause 1000
    next b2
    ' Si ocurre timeout, reintentar
goto inicio

main:
	'serin rx_pin, T4800_8, ("P1:"), dato_recibido
	high b.1            ' Indicador de recepci?n
	pause 1000
	low b.1
	' Muestra el dato recibido en el terminal
	sertxd ("Recibido de PICAXE 1: ", dato_recibido, 13, 10)
	'serout tx_pin, T4800_8, ("P2:", iniciar, 13, 10)
	high b.2            ' Indicador de transmisi?n
	pause 1000
	low b.2
goto main