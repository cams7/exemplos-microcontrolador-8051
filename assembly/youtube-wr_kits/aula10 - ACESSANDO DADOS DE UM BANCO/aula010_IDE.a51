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
        org     0000h           ; Origem no endereço 00h de memória        
        
		mov     dptr,#banco     ; Move um dos dados do banco para dptr
		
init:
		mov     r0,#00h         ; Inicializa o contador (r0)

; --- Rotina Principal ---
main:
        mov     a,r0            ; Move o conteúdo do contador (r0) para o acc
        movc    a,@a+dptr       ; Move o byte relativo de dptr somado com o valor de acc para o acc
        mov     p0,a            ; Move o conteúdo de acc para Port0
		acall  	delay500ms      ; Chama a rotina de temporização
        inc     r0              ; Incrementa o contador (r0)
        cjne    r0,#08h,main  	; Verifica se o valor do contador(r0) é igual a 8, caso contrário, volta para a subrotina "main"
        sjmp    init            ; Volta para a subrotina "init"
		
delay500ms:
                                ; 2                             | Ciclos de máquina do mnemônico call
        mov    	R1,#0fah        ; 1                             | Move o valor 250 decimal para o registrador R1
 
 aux1:
        mov    	R2,#0f9h        ; 1 x 250                       | Move o valor 249 decimal para o registrador R2
        nop                    	; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
 
 aux2:
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
 
        djnz    R2,aux2         ; 2 x 250 x 249 = 124500        | Decrementa o R2 até chegar a zero
        djnz  	R1,aux1         ; 2 x 250                       | Decrementa o R1 até chegar a zero
 
        ret                   	; 2                             | Retorna para a função main
                                ; ------------------------------------
                                ; Total = 500005 us ~~ 500 ms = 0,5 seg

; --- Banco ---
banco:
        db      01h             ; 00000001b
        db      02h             ; 00000010b
        db      04h             ; 00000100b
        db      08h             ; 00001000b
        db      10h             ; 00010000b
        db      20h             ; 00100000b
        db      40h             ; 01000000b
        db      80h             ; 10000000b

        end                     ; Final do Programa