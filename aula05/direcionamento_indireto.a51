; 
; Exemplo de direcionamento indireto
;
; Curso de microcontroladores 8051
;
; Wagner Rambo Julho de 2015
;
 
                org             0000h                   ;Origem no endereço 00h de memória
 
 inicio:
 
                mov             28h,#0bbh               ;Direcionamento imediato / move o conteúdo(ou a constante bbh) para o endereço 28h
                mov             r1,#28h                 ; r1 atua como um ponteiro para dados e aponta para o endereço 28h
                mov             a,@r1                   ; a = bbh
 
                ajmp            $                       ;segura o código nesta linha
 
                end                                     ;final do programa