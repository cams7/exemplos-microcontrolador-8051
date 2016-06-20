;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 36 - Controle de Lâmpadas
;
;  
;
;   MCU: AT89S51    Clock: 12MHz    Ciclo de Máquina: 1µs
;
;  
;   Sistema Sugerido: PARADOXUS 8051
;
;   Disponível a venda em https://wrkits.com.br/catalog/show/140
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
;   Autor: Eng. Wagner Rambo   |   Data: Fevereiro de 2016
;
;

; --- Constantes ---
        LAMP    equ     P0.7    ;lampada controlada por saída P0.7
 
 
; --- Vetor de RESET ---
        org     0000h           ;origem no endereço 00h de memória
        ajmp    main            ;desvia das interrupções

 
; --- Rotina de Interrupção INT0 ---
   
        org     0003h           ;endereço da interrupção do INT0
        clr     LAMP            ;aciona lampada
        acall   delay500ms      ;chama subrotina de 500ms
        acall   delay500ms      ;chama subrotina de 500ms
        acall   delay500ms      ;chama subrotina de 500ms
        acall   delay500ms      ;chama subrotina de 500ms
        setb    LAMP            ;desliga lampada
       
        reti                    ;retorna da interrupção
    
; --- Final das Rotinas de Interrupção ---
 
  
; --- Rotina Principal ---
main:
        mov     IE,#81h         ;habilita interrupção externa INT0
                                ;Registrador IE (Interrupt Enable) - Habilita Interrupção
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  0   0   0   1
                                           
                                ;EA (Enable All) – habilita todas interrupções
                                ;ES (Enable Serial) – habilita interrupção serial
                                ;ET1 (Enable Timer1) – habilita interrupção do Timer1
                                ;EX1 (Enable external1) – habilita interrupção externa INT1
                                ;ET0 (Enable Timer0) – habilita interrupção do Timer0
                                ;EX0 (Enable external0) – habilita interrupção externa INT0

        mov     IP,#01h         ;INT0 em alta prioridade
                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrupção
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  0   0   0   1
   
                                ;PS (Priority Serial) – prioridade da serial
                                ;PT1 (Priority Timer1) – prioridade do Timer1
                                ;PX1 (Priority External1) – prioridade INT1
                                ;PT0 (Priority Timer0) – prioridade Timer0
                                ;PX0 (Priority External0) – prioridade INT0

        mov     TCON,#01h       ;INT0 sensível a borda
                                ;Registrador TCON (Timer Control) - Configura os tipos de interrupção e contém as flags de indicação
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   0   0   0   0   0   0   1
     
                                ;TRx = 1 -> Liga a contagem
                                ;TRx = 0 -> Desliga a contagem
                                ;TFx = 1 -> Flag de indicação: ocorreu overflow
                                ;TFx = 0 -> Flag de indicação: não ocorreu overflow
                                ;IEx = 0 -> Flag de indicação: não houve interrupção externa
                                ;IEx = 1 –> Flag de indicação: houve interrupção externa
                                ;ITx = 0 –> Interrupção externa sensível a nível
                                ;ITx = 1 –> Interrupção externa sensível à borda 
 
        ajmp    $               ;aguarda interrupção
 
 
; --- Sub Rotinas ---
delay500ms:
                                ; 2       | ciclos de máquina do mnemônico call
        mov     R1,#0fah        ; 1       | move o valor 250 decimal para o registrador R1
 
aux1:
        mov     R2,#0f9h        ; 1 x 250 | move o valor 249 decimal para o registrador R2
                nop             ; 1 x 250
                nop             ; 1 x 250
                nop             ; 1 x 250
                nop             ; 1 x 250
                nop             ; 1 x 250
 
aux2:
                nop             ; 1 x 250 x 249 = 62250
                nop             ; 1 x 250 x 249 = 62250
                nop             ; 1 x 250 x 249 = 62250
                nop             ; 1 x 250 x 249 = 62250
                nop             ; 1 x 250 x 249 = 62250
                nop             ; 1 x 250 x 249 = 62250
 
        djnz    R2,aux2         ; 2 x 250 x 249 = 124500     | decrementa o R2 até chegar a zero
        djnz    R1,aux1         ; 2 x 250                    | decrementa o R1 até chegar a zero
 
        ret                     ; 2                          | retorna
                                ;------------------------------------
                                ; Total = 500005 us ~~ 500 ms = 0,5 seg 
 
 
        end                     ;Final do programa
          
  