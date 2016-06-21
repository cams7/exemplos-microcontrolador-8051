;
;  Curso de Assembly para 8051 - WR Kits
;
;  Aula 013: Rotinas de Delay
;
;  MCU: AT89S51    Clock: 12MHz    Ciclo de Máquina = 1µs
;
;  Autor: Eng. Wagner Rambo   Data: Agosto de 2015
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits  
;


        org             0000h           ; Origem no endereço 0000h de memória

main:
        mov             P3,a            ; Move o valor de acc para o Port P3
        cpl             a               ; Complementa o acumulador (acc = not acc)
        mov             P2,a            ; Move o valor de acc para o Port P2
        acall           delay500ms      ; Chama a rotina de temporização
        ajmp            main            ; Loop infinito


delay500ms:
                                        ; 2                             | Ciclos de máquina do mnemônico call
        mov             R1,#0fah        ; 1                             | Move o valor 250 decimal para o registrador R1
 
 aux1:
        mov             R2,#0f9h        ; 1 x 250                       | Move o valor 249 decimal para o registrador R2
        nop                             ; 1 x 250
        nop                             ; 1 x 250
        nop                             ; 1 x 250
        nop                             ; 1 x 250
        nop                             ; 1 x 250
 
 aux2:
        nop                             ; 1 x 250 x 249 = 62250
        nop                             ; 1 x 250 x 249 = 62250
        nop                             ; 1 x 250 x 249 = 62250
        nop                             ; 1 x 250 x 249 = 62250
        nop                             ; 1 x 250 x 249 = 62250
        nop                             ; 1 x 250 x 249 = 62250
 
        djnz            R2,aux2         ; 2 x 250 x 249 = 124500        | Decrementa o R2 até chegar a zero
        djnz            R1,aux1         ; 2 x 250                       | Decrementa o R1 até chegar a zero
 
        ret                             ; 2                             | Retorna para a função main
                                        ; ------------------------------------
                                        ; Total = 500005 us ~~ 500 ms = 0,5 seg

        end                             ; Final do programa