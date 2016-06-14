; Exemplo aula 4
;
; Curso de Microcontroladores 8051 em Assembly
;
; ciclo de máquina = 1/(12MHz/12) = 1us
;
; 
;


        org             0000h                   ;Origem no endereço 00h de memória

inicio:

        mov             a,#01h                  ;Move a constante 1h para o acc                         | 1 ciclo
        mov             b,#00000110b            ;Move a constante 6 para o b                            | 2 ciclos
        mov             a,#7d                   ;Move a constante 7 para o acc                          | 1 ciclo
        inc             a                       ;Incrementa o acumulador em 1 unidade                   | 1 ciclo
        mov             dptr,#9957h             ;Move o valor 9957h para o registrador data pointer     | 2 ciclos
        jmp             $                       ;Segurar o código nesta linha                           | 2 ciclos


        end                                     ;Final do programa