symbol segment_a = B.0
symbol segment_b = B.1
symbol segment_c = B.2
symbol segment_d = B.3
symbol segment_e = B.4
symbol segment_f = B.5
symbol segment_g = B.6

symbol digit1 = B.7      ' Control del primer d?gito
symbol digit2 = C.7      ' Control del segundo d?gito
symbol digit3 = C.5      ' Control del tercer d?gito
symbol digit4 = C.4      ' Control del cuarto d?gito

symbol start_button = pinC.0  ' Bot?n de inicio
symbol stop_button = pinC.1   ' Bot?n de detener
symbol reset_button = pinC.2  ' Bot?n de reinicio

symbol contador = w0          ' Contador de 0 a 999
symbol running = b0           ' Estado de ejecuci?n (0 = detenido, 1 = en ejecuci?n)

' Programa principal
main:
    ' Control de los botones
    if start_button = 1 then
        running = 1
        pause 100
    elseif stop_button = 1 then
        running = 0
        pause 100
    elseif reset_button = 1 then
        contador = 0
        running = 0
        pause 100
    endif

    ' L?gica de conteo
    if running = 1 then
        pause 1000   ' Controla la velocidad del conteo (1 segundo por n?mero)
        inc contador
        if contador > 999 then
            contador = 0
        endif
    ' Muestra los d?gitos del contador en el display de 4 d?gitos
    for b2 = 0 to 3
        ' Extraer el d?gito correspondiente
        b1 = contador / 10^b2 % 10

        ' Apagar todos los d?gitos antes de encender uno
        high digit1, digit2, digit3, digit4

        ' Encender el d?gito correspondiente
        select case b2
            case 0: low digit1
            case 1: low digit2
            case 2: low digit3
            case 3: low digit4
        endselect

        gosub MostrarDigito  ' Llamar a la subrutina para mostrar el d?gito
        pause 1000             ' Peque?a pausa para estabilizar la visualizaci?n
    next b2
    endif

    

    goto main

' Subrutina para mostrar un n?mero en el display de 7 segmentos
MostrarDigito:
    select case b1
        case 0: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            low segment_g
        case 1: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 2: high segment_a
            high segment_b
            low segment_c
            high segment_d
            high segment_e
            low segment_f
            high segment_g
        case 3: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            low segment_f
            high segment_g
        case 4: low segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            high segment_f
            high segment_g
        case 5: high segment_a
            low segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
        case 6: high segment_a
            low segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 7: high segment_a
            high segment_b
            high segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 8: high segment_a
            high segment_b
            high segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 9: high segment_a
            high segment_b
            high segment_c
            high segment_d
            low segment_e
            high segment_f
            high segment_g
    endselect
return
