#picaxe 20m2

' Constantes
symbol PASOS_POR_CM = 400  ' Ejemplo: 400 pasos por cada cent?metro

' Variables para manejo de entrada serial
symbol dato_recibido = b0   ' Byte recibido
symbol valor_cm = w1        ' Valor de cent?metros (word)
symbol pasos_necesarios = w2 ' C?lculo de pasos (word)
symbol digito_actual = b4   ' D?gito procesado
symbol contador_digitos = b5 ' Contador de d?gitos ingresados

' Ejemplo 1: M?todo B?sico de Entrada
ejemplo_basico:
    ' Mensaje inicial
    sertxd("--- Metodo Basico de Entrada ---", cr, lf)
    sertxd("Ingrese distancia en centimetros (0-99):", cr, lf)
    
    ' Reiniciar variables
    let valor_cm = 0
    let contador_digitos = 0
    
bucle_entrada_basico:
    ' Esperar y recibir un car?cter
    serrxd (dato_recibido)
    
    ' Procesar seg?n el car?cter recibido
    select case dato_recibido
        case "0" to "9"  ' D?gitos num?ricos
            ' Convertir ASCII a valor num?rico
            let digito_actual = dato_recibido - 48
            
            ' Acumular valor (permite 2 d?gitos)
            if contador_digitos = 0 then
                let valor_cm = digito_actual
            else
                let valor_cm = valor_cm * 10 + digito_actual
            endif
            
            ' Incrementar contador de d?gitos
            inc contador_digitos
            
            ' Eco del car?cter recibido
            sertxd(dato_recibido)
        
        case 13  ' Enter - Finalizar entrada
            if contador_digitos > 0 then
                ' Calcular pasos necesarios
                let pasos_necesarios = valor_cm * PASOS_POR_CM
                
                ' Mostrar resultados
                sertxd(cr, lf, "Distancia ingresada: ", #valor_cm, " cm", cr, lf)
                sertxd("Pasos necesarios: ", #pasos_necesarios, cr, lf)
                
                ' Opcional: Mostrar informaci?n adicional
                sertxd("Configuracion: 400 pasos por cm", cr, lf)
                
                ' Salir del bucle
                goto fin_ejemplo_basico
            endif
    end select
    
    goto bucle_entrada_basico

fin_ejemplo_basico:
    pause 2000  ' Pausa para mostrar resultados
    
' Ejemplo 2: M?todo con Validaci?n de Rango
ejemplo_validacion:
    ' Mensaje inicial
    sertxd(cr, lf, "--- Metodo con Validacion de Rango ---", cr, lf)
    sertxd("Ingrese distancia en centimetros (10-90):", cr, lf)
    
    ' Reiniciar variables
    let valor_cm = 0
    let contador_digitos = 0
    
bucle_entrada_validacion:
    ' Esperar y recibir un car?cter
    serrxd (dato_recibido)
    
    ' Procesar seg?n el car?cter recibido
    select case dato_recibido
        case "0" to "9"  ' D?gitos num?ricos
            ' Convertir ASCII a valor num?rico
            let digito_actual = dato_recibido - 48
            
            ' Acumular valor (permite 2 d?gitos)
            if contador_digitos = 0 then
                let valor_cm = digito_actual
            else
                let valor_cm = valor_cm * 10 + digito_actual
            endif
            
            ' Incrementar contador de d?gitos
            inc contador_digitos
            
            ' Eco del car?cter recibido
            sertxd(dato_recibido)
        
        case 13  ' Enter - Finalizar entrada
            if contador_digitos > 0 then
                ' Validar rango
                if valor_cm >= 10 and valor_cm <= 90 then
                    ' Calcular pasos necesarios
                    let pasos_necesarios = valor_cm * PASOS_POR_CM
                    
                    ' Mostrar resultados
                    sertxd(cr, lf, "Distancia valida: ", #valor_cm, " cm", cr, lf)
                    sertxd("Pasos necesarios: ", #pasos_necesarios, cr, lf)
                    
                    ' Informaci?n adicional
                    sertxd("Precision: 1 cm = 400 pasos", cr, lf)
                    
                    ' Salir del bucle
                    goto fin_ejemplo_validacion
                else
                    ' Valor fuera de rango
                    sertxd(cr, lf, "Error: Distancia debe estar entre 10 y 90 cm", cr, lf)
                    
                    ' Reiniciar para nueva entrada
                    let valor_cm = 0
                    let contador_digitos = 0
                    sertxd("Intente nuevamente: ")
                endif
            endif
    end select
    
    goto bucle_entrada_validacion

fin_ejemplo_validacion:
    pause 2000  ' Pausa para mostrar resultados

' Ejemplo 3: M?todo con M?ltiples Validaciones
ejemplo_multiple:
    ' Mensaje inicial
    sertxd(cr, lf, "--- Metodo Avanzado ---", cr, lf)
    sertxd("Ingrese distancia en centimetros:", cr, lf)
    sertxd("Rango: 10-90 cm", cr, lf)
    sertxd("Presione Backspace para corregir", cr, lf)
    
    ' Reiniciar variables
    let valor_cm = 0
    let contador_digitos = 0
    
bucle_entrada_multiple:
    ' Esperar y recibir un car?cter
    serrxd (dato_recibido)
    
    ' Procesar seg?n el car?cter recibido
    select case dato_recibido
        case "0" to "9"  ' D?gitos num?ricos
            ' Limitar a 2 d?gitos
            if contador_digitos < 2 then
                ' Convertir ASCII a valor num?rico
                let digito_actual = dato_recibido - 48
                
                ' Acumular valor
                if contador_digitos = 0 then
                    let valor_cm = digito_actual
                else
                    let valor_cm = valor_cm * 10 + digito_actual
                endif
                
                ' Incrementar contador de d?gitos
                inc contador_digitos
                
                ' Eco del car?cter recibido
                sertxd(dato_recibido)
            endif
        
        case 8  ' Backspace - Borrar ?ltimo d?gito
            if contador_digitos > 0 then
                ' Borrar ?ltimo d?gito
                let valor_cm = valor_cm / 10
                dec contador_digitos
                
                ' Borrar visualmente
                sertxd(8, " ", 8)
            endif
        
        case 13  ' Enter - Finalizar entrada
            if contador_digitos > 0 then
                ' Validar rango
                if valor_cm >= 10 and valor_cm <= 90 then
                    ' Calcular pasos necesarios
                    let pasos_necesarios = valor_cm * PASOS_POR_CM
                    
                    ' Mostrar resultados
                    sertxd(cr, lf, "Distancia confirmada: ", #valor_cm, " cm", cr, lf)
                    sertxd("Conversion:", cr, lf)
                    sertxd("  1 cm = 400 pasos", cr, lf)
                    sertxd("  ", #valor_cm, " cm = ", #pasos_necesarios, " pasos", cr, lf)
                    
                    ' Informaci?n extra
                    sertxd("Motor: Stepper - Paso completo", cr, lf)
                    
                    ' Salir del bucle
                    goto fin_ejemplo_multiple
                else
                    ' Valor fuera de rango
                    sertxd(cr, lf, "Error: Distancia invalida", cr, lf)
                    sertxd("Rango permitido: 10-90 cm", cr, lf)
                    
                    ' Reiniciar para nueva entrada
                    let valor_cm = 0
                    let contador_digitos = 0
                    sertxd("Intente nuevamente: ")
                endif
            endif
    end select
    
    goto bucle_entrada_multiple

fin_ejemplo_multiple:
    pause 2000  ' Pausa para mostrar resultados

' Programa principal - Ejecuta ejemplos secuencialmente
inicio:
    ' Configurar comunicaci?n serial
    setfreq m8  ' Frecuencia para comunicaci?n serial
    
    ' Ejecutar ejemplos
    goto ejemplo_basico
    ' Descomentar/comentar seg?n el ejemplo a probar
    ' goto ejemplo_validacion
    ' goto ejemplo_multiple