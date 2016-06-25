; Projeto Aula 2
;
; Altera o nível lógico do PORT0
;
; Autor: Wagner Rambo
;
; MCU: AT89S51


        org             0000h                   ;Origem no endereço 00h de memória

inicio:

        mov             p0,#00h                 ;Todo PORT0 em nível lógico baixo
        mov             p0,#0FFh                ;Todo PORT0 em nível lógico alto
        jmp             inicio                  ;Pula para o inicio

        end                                     ;Final do programa