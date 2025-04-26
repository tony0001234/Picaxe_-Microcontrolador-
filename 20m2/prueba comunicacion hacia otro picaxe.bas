#terminal 9600
setfreq m8
symbol buffer = W0
symbol btn_emer =pinC.6
symbol iniciar = "I"
'symbol led = b.6
'symbol btn_enviar = pinb.7

symbol continuar = "O"
'buffer = 6776
buffer = 0
main:
if btn_emer = 1 then
	do
		pause 50
	loop until btn_emer = 0
	wait 10
endif

'do
    serin b.0, T4800, buffer
'    if buffer = 10 then exit 
 ' loop until buffer = iniciar

'if btn_enviar = 1 then
'	do
'		pause 50
'	loop until btn_enviar = 0
'	
'	serout B.0, N2400, ("Enviando: ", #buffer, 13, 10)
'      high led
'endif

    
    
  '  if buffer = iniciar then
	    
	    sertxd ("Mensaje recibido:  (", buffer, ")", 13, 10)
	    'serout c.0, N4800, (iniciar, 13,10)
	    'sertxd ("Mensaje enviado:  (", iniciar, ")", 13, 10)
	    for b0 = 0 to 10
		    high b.6
		    pause 500
		    low b.6
		    pause 500
	    next b0
'endif
    
    'low led
goto main