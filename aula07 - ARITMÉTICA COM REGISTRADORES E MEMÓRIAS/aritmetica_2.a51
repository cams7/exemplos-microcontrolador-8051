; Aula 007 do curso 8051 - Aritmética com Registradores e memórias
;
;  Autor: Wagner Rambo Julho de 2015
;
;

                org                     0000h                   ;Origem no endereço 00h

inicio:

                mov                     a,  #0ffh               ;Move a constante ff hexa (255) para o acc              |1 ciclo
                mov                     b,  #0h                 ;Move a constante 0 hexa (0) para o b                   |2 ciclos
                mov                     23h,#0ffh               ;Move a constante ff hexa (255) para o M[23]            |2 ciclos
                mov                     20h,#0fh                ;Move a constante f hexa (15) para o M[20]              |2 ciclos


                add                     a,  23h                 ;a = a + M[23] = 1fe hexa (510) = fe hexa (254)         |1 ciclo
                                                                ;a = fe (byte menos significativo)

                inc                     a                       ;a = a + 1 = ff hexa (255)                              |1 ciclo
                inc                     a                       ;a = a + 1 = 100 hexa (256) = 0 hexa (0)                |1 ciclo
                dec                     b                       ;b = b - 1 = ff hexa (255)                              |1 ciclo
                
                mov                     a,  #0ffh               ;Move a constante ff hexa (255) para o acc              |1 ciclo
                subb                    a,  20h                 ;a = a - M[20] = f0 hexa (240) "ef hexa (239)"          |1 ciclo
                subb                    a,  23h                 ;a = a - M[23] = (-16) = f0 hexa (240)                  |1 ciclo

                mov                     a,  #0ffh               ;Move o valor ff hexa (255) para o acc                  |1 ciclos
                mov                     b,  #0ffh               ;Move o valor ff hexa (255) para o b                    |2 ciclos

                mul                     ab                      ;a x b = fe01 hexa (65025)                              |4 ciclos
                                                                ;b = fe hexa (254) (byte mais significativo)
                                                                ;a = 01 hexa (1)   (byte menos significativo)

                mov                     a,  #0ffh               ;Move o valor ff hexa (255) para o acc                  |1 ciclos
                mov                     b,  #064h               ;Move o valor 64 hexa (100) para o b                    |2 ciclos

                div                     ab                      ;a / b = 2 hex (2)                                      |2 ciclos
                                                                ;a = 2  hexa (2)  (divisão) 
                                                                ;b = 37 hexa (55) (resto)

                ajmp                    $                       ;segura o código                                        |26 ciclos

                end                                             ;final do programa