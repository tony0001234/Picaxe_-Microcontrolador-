main:	
   symbol seg = b0
   symbol minu = b1
   symbol hora = b2
   symbol dia = b3
   symbol date = b4
   symbol mes = b5
   symbol ao = b6
   symbol cont = b7
      i2cslave %11010000,i2cfast,i2cbyte
      hi2cin 0, (seg,minu,hora,dia,date,mes,ao,cont)
      pause 100
	 let seg = bdctobin seg
	 let minu = bdctobin minu
	 let dia = bdctobin dia
	 let date = bdctobin date
	 let mes = bdctobin mes
	 let ao = bdctobin ao
	 let cont = bcdtobin cont
   serout 7,T2400, (254,128)
   serout 7,T2400, (254,1)
   serout 7,T2400, (" ",#hora,":",#minu,":",#seg,13,10)
   sertxd (#dia,"/",#mes,"/",#ao, "  ",#hora,":",)
   wait 1
goto main