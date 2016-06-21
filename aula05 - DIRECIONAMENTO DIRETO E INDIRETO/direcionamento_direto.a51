;
; Curso de 8051 em Assembly
;
; Exemplo de direcionamento direto
;
; Wagner Rambo Julho de 2015
;

                org             0000h                   ;Origem no endereço 00h de memória

ini:
                mov             20h,#0bbh               ;Move o valor constante para o endereço 20h de memória
                mov             23h,20h                 ;Move o conteúdo do endereço 20h de memória p/ 23h
                mov             a,P2                    ;Move o conteúdo do port2 para o acumulador
                add             a,23h                   ; a = a + M23 

                end                                     ;Final do programa