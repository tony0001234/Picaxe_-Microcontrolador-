symbol pasos_por_revolucion = 200   ' Pasos por cada giro del motor
symbol avance_por_revolucion = 2    ' Cent?metros avanzados por revoluci?n
symbol distancia_cm = w0            ' Variable para almacenar la distancia ingresada
symbol pasos_necesarios = w1        ' Variable para almacenar el c?lculo de pasos

main:
    sertxd("Ingrese la distancia en cm: ", 13, 10)  ' Solicita el dato en HyperTerminal
    serrxd distancia_cm                           ' Recibe el valor en w0 desde el PC

    ' Verifica que la distancia ingresada sea v?lida (mayor que 0)
    if distancia_cm > 0 then
        ' C?lculo de los pasos necesarios
        pasos_necesarios = distancia_cm * pasos_por_revolucion / avance_por_revolucion

        ' Enviar resultados por HyperTerminal
        sertxd("Distancia ingresada: ", #distancia_cm, " cm", 13, 10)
        sertxd("Pasos necesarios: ", #pasos_necesarios, 13, 10)
    else
        sertxd("Error: La distancia debe ser mayor a 0.", 13, 10)
    endif

    sertxd("Reiniciando...", 13, 10)
    pause 1000
    goto main
