;
; Display de 7 segmentos
;
; César Magalhães
;
; Junho de 2016

; --- Vetor de RESET ---
        org             0000h                   ;Origem no endereço 00h de memória       
        mov             DPTR,#display7          ;Move um dos dados do display para DPTR

init:
        mov             R0,#00h                 ;Inicializa o contador (R0)

; --- Rotina Principal ---
main:
        mov             a,R0                    ;Move o conteúdo do contador (R0) para o acc
        movc            a,@a+DPTR               ;Move o byte relativo de DPTR somado com o valor de acc para o acc
        mov             P0,a                    ;Move o conteúdo de acc para a porta 0
        call            delay1segundo           ;Atraza em um segundo
        inc             R0                      ;Incrementa o contador (R0)
        cjne            R0,#0Ah,main            ;Verifica se o valor do contador(R0) é igual a 10, caso contrário, volta para o inicio
        ajmp            init                    ;Loop infinito

; --- Banco ---
display7:
        db              40h                     ;01000000b - Número 0 no display
        db              79h                     ;01111001b - Número 1 no display
        db              24h                     ;00100100b - Número 2 no display
        db              30h                     ;00110000b - Número 3 no display
        db              19h                     ;00011001b - Número 4 no display
        db              12h                     ;00010010b - Número 5 no display
        db              02h                     ;00000010b - Número 6 no display
        db              78h                     ;01111000b - Número 7 no display
        db              00h                     ;00000000b - Número 8 no display
        db              10h                     ;00010000b - Número 9 no display

delay1segundo:
        call            delay500ms              ;Chama a rotina de temporização
        call            delay500ms
        ret
               
delay500ms:                                     ;2 | Ciclos de maquina do mnemônico call
        mov             R1,#0FAh                ;1 | Move o valor FAh (250) para R1

aux1:
        mov             R2,#0F9h                ;1 x 250 | Move o valor F9h (249) para R2
        nop                                     ;1 x 250 | Atraza um ciclo de maquina
        nop                                     ;1 x 250
        nop                                     ;1 x 250
        nop                                     ;1 x 250
        nop                                     ;1 x 250

aux2:
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        nop                                     ;1 x 250 x 249
        djnz            R2,aux2                 ;2 x 250 x 249 | Decrementa o R2 até chegar a 0  
        djnz            R1,aux1                 ;2 x 250       | Decrementa o R1 até chegar a 0
              
        ret                                     ; 2 | Retorna para função principal

        end                                     ;Final do Programa