symbol contador = b0           
symbol up_button = pinC.0       
symbol down_button = pinC.1    
symbol reset_button = pinC.2   


symbol segment_a = B.0
symbol segment_b = B.1
symbol segment_c = B.2
symbol segment_d = B.3
symbol segment_e = B.4
symbol segment_f = B.5
symbol segment_g = B.6


main:
    
    if up_button = 1 then
        if contador < 9 then
            inc contador
        else
            contador = 0
        endif
        pause 200

    elseif down_button = 1 then
        if contador > 0 then
            dec contador
        else
            contador = 9
        endif
        pause 200

    elseif reset_button = 1 then
        contador = 0
        pause 200
    endif

    
    gosub mostrarNumero

    pause 100
    goto main

mostrarNumero:
    select case contador
        case 0: low segment_a
            low segment_b
            low segment_c
            low segment_d
            low segment_e
            low segment_f
            high segment_g
        case 1: high segment_a
            low segment_b
            low segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 2: low segment_a
            low segment_b
            high segment_c
            low segment_d
            low segment_e
            high segment_f
            low segment_g
        case 3: low segment_a
            low segment_b
            low segment_c
            low segment_d
            high segment_e
            high segment_f
            low segment_g
        case 4: high segment_a
            low segment_b
            low segment_c
            high segment_d
            high segment_e
            low segment_f
            low segment_g
        case 5: low segment_a
            high segment_b
            low segment_c
            low segment_d
            high segment_e
            low segment_f
            low segment_g
        case 6: low segment_a
            high segment_b
            low segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 7: low segment_a
            low segment_b
            low segment_c
            high segment_d
            high segment_e
            high segment_f
            high segment_g
        case 8: low segment_a
            low segment_b
            low segment_c
            low segment_d
            low segment_e
            low segment_f
            low segment_g
        case 9: low segment_a
            low segment_b
            low segment_c
            low segment_d
            high segment_e
            low segment_f
            low segment_g
    endselect
    return