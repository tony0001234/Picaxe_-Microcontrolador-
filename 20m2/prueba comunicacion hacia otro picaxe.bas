setfreq m4
symbol buffer = b0
symbol btn_emer =pinC.6

'symbol led = b.6
'symbol btn_enviar = pinb.7

'buffer = 6776

main:
if btn_emer = 1 then
	do
		pause 50
	loop until btn_emer = 0
	wait 10
endif
'do
    serin b.0, N4800, buffer
'    if buffer = 10 then exit 
'  loop
    'serin b.0, N2400, ("Valor: "), #buffer
    'hserin b.6, 9600, buffer
'if btn_enviar = 1 then
'	do
'		pause 50
'	loop until btn_enviar = 0
'	
'	serout B.0, N2400, ("Enviando: ", #buffer, 13, 10)
'      high led
'endif

    
    sertxd ("Mensaje recibido:  (", #buffer, ")", 13, 10)
    pause 500
    'low led
goto main