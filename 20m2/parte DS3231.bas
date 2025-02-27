	
   symbol seg = b0
   symbol minu = b1
   symbol hora = b2
   symbol dia = b3
   symbol date = b4
   symbol mes = b5
   symbol ao = b6
   symbol cont = b7
   main:	
'parte funcionale ds3231
      i2cslave %11010000,i2cfast,i2cbyte
      hi2cin 0, (seg,minu,hora,dia,date,mes,ao,cont)
      pause 100
	 'let seg = bcdtobin seg
	 'let minu = bcdtobin minu
	 'let dia = bcdtobin dia
	 'let date = bcdtobin date
	 'let mes = bcdtobin mes
	 'let ao = bcdtobin ao
	 'let cont = bcdtobin cont
   'sertxd (254,128)
   'sertxd (254,1)

   sertxd (" ",#seg,":",#minu,":",#hora,13,10)
   sertxd (#dia,"/",#mes,"/",#ao, "  ",#cont,":",13,10)
   wait 1
   goto main