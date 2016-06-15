;
;  Curso de Assembly para microcontroladores 8051
;
;  Aula 009 - Desvios/Pulos Condicionais e Incondicionais
;
;  Eng. Wagner Rambo
;
;

        org     0000h           ;origem no endereço 00h de memória
        clr     a               ;limpa o acc

inicio:
        cpl     a               ;a = not (a)
        mov     p0,a            ;move o valor do acc para p0
        jmp     inicio          ;loop infinito

        end                     ;Final do programa
; ajmp
; ljmp
; sjmp