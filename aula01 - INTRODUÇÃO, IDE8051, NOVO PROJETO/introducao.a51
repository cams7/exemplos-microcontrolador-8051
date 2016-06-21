; Introdução - Exemplo de programa


        org             0000h                   ;Origem no endereço 00h


inicio:

        mov             a, #0ffh                ;Move a constante ff hexa para o acumulador
        mov             a, #00h                 ;Move a constante 00 hexa para o acumulador
        mov            r0, #55h                 ;Move a constante 55 hexa para o registrador 0
        mov             b, #0aah                ;Move a constante aa hexa para o registrador 0

        jmp             $                       ;Segura o programa nesta linha


        end                                     ;Final do programa

