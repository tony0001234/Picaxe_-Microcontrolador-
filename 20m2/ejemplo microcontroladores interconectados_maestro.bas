symbol pin_dir = b.0
symbol pin_step = b.1
symbol pin_enable = b.2

symbol btn_azul = pinc.0

low pin_enable
main:

'if btn_azul = 1 then
'	do
'		pause 50
'	loop until btn_azul = 0
	
	for b0 = 0 to 200
		high pin_dir
		high pin_step
		pause 1
		low pin_step
		pause 1
	next b0
	wait 2

	for b0 = 0 to 200
		low pin_dir
		high pin_step
		pause 1
		low pin_step
		pause 1
	next b0
	
'endif


goto main