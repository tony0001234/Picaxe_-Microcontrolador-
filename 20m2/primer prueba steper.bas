symbol dir = B.0
symbol step1 = B.1
symbol sleep1 = B.2
symbol reset1 = B.3
symbol enable = B.4

main:

	high sleep1
	high reset1
	high enable
	
	for b0 = 0 to 10
		
		 high dir
		 
		gosub pasos
		
		pause 66
		low dir
		pause 66
		
		gosub pasos
		
	next b0

goto main

pasos:
	for b1 = 0 to 10
		
		high step1
		pause 66
		low step1
		pause 66
	
	next b1
return