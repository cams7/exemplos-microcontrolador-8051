;
;  Curso de Assembly para 8051 Aula 008
;
;  Instruções Lógicas e Booleanas
;
;  Autor: Eng. Wagner Rambo
;
;  Data: Julho de 2015
;

        org     0000h           ;Origem no endereço 00h de memória

inicio:

        mov     a,#01010011b    ;Carrega o valor 01010011 binário para o acc (53)
        mov     b,#00101001b    ;Carrega o valor 00101001 binário para o b   (29)

        anl     a,b             ; acc = acc AND b   = 0000 0001 (01)
                                ; a = 01010011
                                ; b = 00101001
                                ;     --------
                                ; a = 00000001

        cpl     a               ; acc = not(acc)    = 1111 1110 (FE)
                                ; a = 00000001
                                ;     --------
                                ; a = 11111110
                
        orl     a,b             ; acc = acc OR b    = 1111 1111 (FF)
                                ; a = 11111110
                                ; b = 00101001
                                ;     --------
                                ; a = 11111111

        xrl     a,b             ; acc = acc XOR b   = 1101 0110 (D6)
                                ; a = 11111111
                                ; b = 00101001
                                ;     --------
                                ; a = 11010110

        rr      a               ; acc = 01101011 (6B)
        rr      a               ; acc = 10110101 (B5)
        rr      a               ; acc = 11011010 (DA)

        rl      a               ; acc = 10110101 (B5)
        rl      a               ; acc = 01101011 (6B)
        rl      a               ; acc = 11010110 (D6)

        swap    a               ; acc = 01101101 (6D)
        swap    a               ; acc = 11010110 (D6)


        ajmp    $               ;Segura o código nesta linha

        end                     ;Final do programa
