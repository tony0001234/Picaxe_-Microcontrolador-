symbol BTN_STOP = pinC.0  ' Bot?n de inicio

' Pines de los potenci?metros
symbol POT_1 = pinB.0
symbol POT_2 = pinB.1
symbol POT_3 = pinB.2
symbol POT_4 = pinB.3

symbol LED_STOP = pinC.1

' Variables para valores ADC de los potenci?metros
symbol VALOR_POT0 = W0
symbol VALOR_POT1 = W1
symbol VALOR_POT2 = W2
symbol VALOR_POT3 = W3

' Variables de procesamiento
symbol PROMEDIO = w4
symbol MODA = w5
symbol TEMP = W6
symbol TEMP2 = W7

' Variables de control de rango
symbol LIMITE_BAJO = 100
symbol LIMITE_ALTO = 200

main:

    PROMEDIO = 0
    MODA = 0
    low c.1
    if BTN_STOP = 1 then 
        do
            pause 50
        loop until BTN_STOP = 0
  	  
	  high c.1
	  
    wait 10
    endif
	  ' Leer valores ADC de los potenci?metros
        Readadc b.0, w0
        sertxd("Valor potenciometro 1k = ", #VALOR_POT0, 13,10)
        pause 10
        Readadc b.1, w1
        sertxd("Valor potenciometro 10k = ", #VALOR_POT1, 13,10)
        pause 10
        Readadc b.2, w2
        sertxd("Valor potenciometro 100k = ", #VALOR_POT2, 13,10)
        pause 10
        Readadc b.3, w3
        sertxd("Valor potenciometro 250k = ", #VALOR_POT3, 13,10)
        pause 10

        ' Calcular el promedio de los valores ADC
        TEMP = VALOR_POT0 + VALOR_POT1 + VALOR_POT2 + VALOR_POT3
        PROMEDIO = TEMP / 4

        ' Determinar la moda
        IF VALOR_POT0 = VALOR_POT1 or VALOR_POT0 = VALOR_POT2 or VALOR_POT0 = VALOR_POT3 THEN
            MODA = VALOR_POT0
        ELSEIF VALOR_POT1 = VALOR_POT2 or VALOR_POT1 = VALOR_POT3 THEN
            MODA = VALOR_POT1
        ELSEIF VALOR_POT2 = VALOR_POT3 THEN
            MODA = VALOR_POT2
        ELSE
            MODA = VALOR_POT3
        ENDIF

        sertxd("El valor de la Moda es: ", #MODA, 13,10)
        sertxd("El valor del Promedio es: ", #PROMEDIO, 13,10)

        sertxd("Rango v?lido: ", #LIMITE_BAJO, " - ", #LIMITE_ALTO, 13,10)

        ' Verificar si los valores est?n fuera del rango
        if VALOR_POT0 < LIMITE_BAJO or VALOR_POT0 > LIMITE_ALTO then
            sertxd("ERROR: Ajustar Potenci?metro de 1k", 13, 10)
        endif
        if VALOR_POT1 < LIMITE_BAJO or VALOR_POT1 > LIMITE_ALTO then
            sertxd("ERROR: Ajustar Potenci?metro de 10k", 13, 10)
        endif
        if VALOR_POT2 < LIMITE_BAJO or VALOR_POT2 > LIMITE_ALTO then
            sertxd("ERROR: Ajustar Potenci?metro 100k", 13, 10)
        endif
        if VALOR_POT3 < LIMITE_BAJO or VALOR_POT3 > LIMITE_ALTO then
            sertxd("ERROR: Ajustar Potenci?metro 250k", 13, 10)
        endif

        wait 5  ' Espera antes de la siguiente medici?n

goto main
