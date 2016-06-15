;
; Curso de Assembly para 8051 WR Kits
;
; Aula 10: Acessando Dados de um Banco
;
; Eng. Wagner Rambo
;
; Agosto de 2015
;

; --- Vetor de RESET ---
        org     0000h           ;Origem no endereço 00h de memória

init:
        mov     r0,#00h         ;Inicializa o contador (r0)
        mov     dptr,#display7  ;Move um dos dados do display para dptr

; --- Rotina Principal ---
main:
        mov     a,r0            ;Move o conteúdo do contador (r0) para o acc
        movc    a,@a+dptr       ;Move o byte relativo de dptr somado com o valor de acc para o acc
        mov     p0,a            ;Move o conteúdo de acc para Port0
        inc     r0              ;Incrementa o contador (r0)
        cjne    r0,#0Ah,main    ;Verifica se o valor do contador(r0) é igual a 10, caso contrário, volta para o inicio
        ajmp    $               ;Segura o código nesta linha

; --- Banco ---
display7:
        db      40h             ;01000000b - Número 0 no display
        db      79h             ;01111001b - Número 1 no display
        db      24h             ;00100100b - Número 2 no display
        db      30h             ;00110000b - Número 3 no display
        db      19h             ;00011001b - Número 4 no display
        db      12h             ;00010010b - Número 5 no display
        db      02h             ;00000010b - Número 6 no display
        db      78h             ;01111000b - Número 7 no display
        db      00h             ;00000000b - Número 8 no display
        db      10h             ;00010000b - Número 9 no display

        end                     ;Final do Programa