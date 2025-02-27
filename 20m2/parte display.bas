for b8 = 0 to 50
	if b3 > 0 then
		low digit4
		gosub MostrarDigito4
		pause 30
		high digit4
	endif
	if b2 > 0 then
		low digit3
		gosub MostrarDigito3
		pause 30
		high digit3
	endif
	if b1 >= 0 then
		low digit2
		gosub MostrarDigito2
		pause 30
		high digit2
	endif

low digit1
gosub MostrarDigito1
pause 30
high digit1

next b8