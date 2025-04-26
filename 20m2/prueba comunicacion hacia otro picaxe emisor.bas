#terminal 9600
setfreq m8
symbol bucle = b0
symbol btn_emer =pinC.6
symbol buffer = w0

symbol iniciar = "I"

symbol led = b.5
'symbol btn_enviar = pinb.7

'buffer = 6776

main:
if btn_emer = 1 then
	do
		pause 50
	loop until btn_emer = 0
	wait 5
endif
    'serin C.0, N2400, ("Valor: "), #buffer
'if btn_enviar = 1 then
'	do
'		pause 50
'	loop until btn_enviar = 0
'for b0 = 0 to 50
'	pause 500
	serout c.0, T4800, (iniciar,13,10)
	sertxd ("Mensaje Enviando:  (", iniciar, ")", 13, 10)
      'high led
'endif

    
    'sertxd ("Mensaje enviado:  (", buffer, ")", 13, 10)
    'serin b.0, N4800, (buffer,13,10)
    'sertxd ("Mensaje recibido:  (", buffer,")", 13, 10)
    for b0 = 0 to 10
		    high b.6
		    pause 500
		    low b.6
		    pause 500
	    next b0
'    pause 500
'    low led
'next b0
goto main