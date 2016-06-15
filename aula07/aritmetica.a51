; Aula 007 do curso 8051 - Aritmética com Registradores e memórias
;
;  Autor: Wagner Rambo Julho de 2015
;
;

                org                     0000h                   ;Origem no endereço 00h

inicio:

                mov                     a,#0ah                  ;Move a constante a hexa para o acc
                mov                     b,#03h                  ;Move a constante 3 hexa para o b
                mov                   23h,#06h                  ;Move a constante 6 hexa para o M[23]
                mov                   20h,#0fh                  ;Move a constante f hexa para o M[20]

                add                     a,23h                   ;a = a + M[23]

                inc                     a                       ;a = a + 1 (a++;)
                dec                     b                       ;b = b - 1 (b--;)

                subb                    a,20h                   ;a = a - M[20]

                mov                     a,#0ch                  ;Move o valor c hexa para o acc
                mov                     b,#08h                  ;Move o valor 8 hexa para o b

                mul                     ab                     ;ab = a x b
                                                                ;b = byte mais significativo
                                                                ;a = byte menos significativo

                mov                     a,#45h                  ;
                mov                     b,#7                    ;

                div                     ab                      ;a = divisão, b = resto

                ajmp                    $                       ;segura o código

                end                                             ;final do programa