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
        mov     r0,#00h         ;Inicializa o contador (r0)
        mov     dptr,#banco     ;Move um dos dados do banco para dptr

; --- Rotina Principal ---
inicio:
        mov     a,r0            ;Move o conteúdo do contador (r0) para o acc
        movc    a,@a+dptr       ;Move o byte relativo de dptr somado com o valor de acc para o acc
        mov     p0,a            ;Move o conteúdo de acc para Port0
        inc     r0              ;Incrementa o contador (r0)
        cjne    r0,#08h,inicio  ;Verifica se o valor do contador(r0) é igual a 8, caso contrário, volta para o inicio
        ajmp    $               ;Segura o código nesta linha

; --- Banco ---
banco:
        db      01h             ;00000001b
        db      02h             ;00000010b
        db      04h             ;00000100b
        db      08h             ;00001000b
        db      10h             ;00010000b
        db      20h             ;00100000b
        db      40h             ;01000000b
        db      80h             ;10000000b

        end                     ;Final do Programa