symbol btn_blanco = pinc.3

symbol pin_m0 = c.1
symbol pin_m1 = c.2
symbol pin_m2 = c.4

symbol contador_pulsos = b0

contador_pulsos = 0
main:

if btn_blanco = 1 then
	do
		pause 50
	loop until contador_pulsos = 0
	
	contador_pulsos = 1+ contador_pulsos
	
	select contador_pulsos
		case 1
			pause 50
			low pin_m0
			low pin_m1
			low pin_m2
		case 2
			pause 50
			high pin_m0
			low pin_m1
			low pin_m2
		case 3
			pause 50
			low pin_m0
			high pin_m1
			low pin_m2
		case 4
			pause 50
			high pin_m0
			high pin_m1
			low pin_m2
		case 5
			pause 50
			high pin_m0
			high pin_m1
			high pin_m2
		else
			pause 50
			contador_pulsos = 0
	endselect
	
endif

goto main