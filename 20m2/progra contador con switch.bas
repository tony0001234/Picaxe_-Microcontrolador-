main:

let dirsb=%11111111

if pinc.0=1 then 
	let pinsb=%01000000
	pause 500
	let pinsb=%01111001
	pause 500
	let pinsb=%00100100
	pause 500
	let pinsb=%00110000
	pause 500
	let pinsb=%00011001
	pause 500
	let pinsb=%00010010
	pause 500
	let pinsb=%00000010
	pause 500
	let pinsb=%01111000
	pause 500
	let pinsb=%00000000
	pause 500
	let pinsb=%00011000
	pause 500
	goto main
else
	goto main
endif