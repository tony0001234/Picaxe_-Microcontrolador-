symbol num1 = b0  ' Primer n?mero
symbol num2 = b1  ' Segundo n?mero
symbol result = w0  ' Resultado de la operaci?n (16 bits para manejar resultados mayores a 255)
symbol op = b2  ' Variable para almacenar la operaci?n seleccionada

main:

' Enviar el men? de opciones al usuario
serout B.7, N2400, ("Calculadora:", 13, 10)
serout B.7, N2400, ("1. Suma", 13, 10)
serout B.7, N2400, ("2. Resta", 13, 10)
serout B.7, N2400, ("3. Multiplicacion", 13, 10)
serout B.7, N2400, ("4. Division", 13, 10)
serout B.7, N2400, ("Ingrese su opci?n (1-4): ", 13, 10)

' Leer la opci?n del usuario (se espera que sea un n?mero entre 1 y 4)
serin B.6, N2400, op

' Solicitar el primer n?mero
serout B.7, N2400, ("Ingrese el primer n?mero (0-99): ", 13, 10)
serin B.6, N2400, num1

' Solicitar el segundo n?mero
serout B.7, N2400, ("Ingrese el segundo n?mero (0-99): ", 13, 10)
serin B.6, N2400, num2

' Selecci?n de la operaci?n
select case op
    case 1  ' Suma
        result = num1 + num2
        serout B.7, N2400, ("Resultado de la suma: ", #result, 13, 10)
    
    case 2  ' Resta
        if num1 >= num2 then
            result = num1 - num2
        else
            result = 0
        endif
        serout B.7, N2400, ("Resultado de la resta: ", #result, 13, 10)
    
    case 3  ' Multiplicaci?n
        result = num1 * num2
        serout B.7, N2400, ("Resultado de la multiplicaci?n: ", #result, 13, 10)
    
    case 4  ' Divisi?n
        if num2 > 0 then
            result = num1 / num2
            serout B.7, N2400, ("Resultado de la divisi?n: ", #result, 13, 10)
        else
            serout B.7, N2400, ("Error: Divisi?n por cero", 13, 10)
        endif
    
    else
        serout B.7, N2400, ("Opci?n no v?lida", 13, 10)
endselect

goto main