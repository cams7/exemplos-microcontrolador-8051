;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 35 - Controle de Servo Motores
;
;   Utilizando as fontes de interrupção externa INT0 e INT1 para o controle de direção de um servo motor
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
;   Autor: Eng. Wagner Rambo   |   Data: Janeiro de 2016
;
;
; --- Constantes ---
        P_SERVO equ     P1.0    ;Porta do servo motor

; --- Vetor de RESET ---
        org     0000h           ;origem no endereço 00h de memória
        ajmp    init            ;desvia das interrupções

 
; --- Rotina de Interrupção INT0 ---
                                ;Rotaciona o eixo do servo em 90º no sentido anti-horário   
        org     0003h           ;endereço da interrupção do INT0
        setb    P_SERVO         ;seta a "porta do servo"
        acall   delay600us      ;chama subrotina de 0,6ms
        clr     P_SERVO         ;limpa a "porta do servo"
        acall   delay20ms       ;chama subrotina de 20ms
        reti                    ;retorna da interrupção
  
; --- Rotina de Interrupção INT1 ---
                                ;Rotaciona o eixo do servo em 90º no sentido horário
        org     0013h           ;endereço da interrupção do INT1                                
        setb    P_SERVO         ;seta a "porta do servo"
        acall   delay600us      ;chama subrotina de 0,6ms
        acall   delay600us      ;chama subrotina de 0,6ms
        acall   delay600us      ;chama subrotina de 0,6ms
        acall   delay600us      ;chama subrotina de 0,6ms
        clr     P_SERVO         ;limpa a "porta do servo"
        acall   delay20ms       ;chama subrotina de 20ms
        reti                    ;retorna da interrupção
   
    
; --- Final das Rotinas de Interrupção ---

 
; --- Rotina Principal ---
init:
        mov     IE,#85h         ;habilita interrupções INT0 e INT1
                                ;Registrador IE (Interrupt Enable) - Habilita Interrupção
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  0   1   0   1
                                                  
                                ;EA (Enable All) – habilita todas interrupções
                                ;ES (Enable Serial) – habilita interrupção serial
                                ;ET1 (Enable Timer1) – habilita interrupção do Timer1
                                ;EX1 (Enable external1) – habilita interrupção externa INT1
                                ;ET0 (Enable Timer0) – habilita interrupção do Timer0
                                ;EX0 (Enable external0) – habilita interrupção externa INT0

        mov     IP,#04h         ;INT0 e INT1 em baixa prioridade
                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrupção
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  0   1   0   0
          
                                ;PS (Priority Serial) – prioridade da serial
                                ;PT1 (Priority Timer1) – prioridade do Timer1
                                ;PX1 (Priority External1) – prioridade INT1
                                ;PT0 (Priority Timer0) – prioridade Timer0
                                ;PX0 (Priority External0) – prioridade INT0

        mov     TCON,#00h       ;INT0 e INT1 sensíveis a nível
                                ;Registrador TCON (Timer Control) - Configura os tipos de interrupção e contém as flags de indicação
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   0   0   0   0   0   0   0
            
                                ;TRx = 1 -> Liga a contagem
                                ;TRx = 0 -> Desliga a contagem
                                ;TFx = 1 -> Flag de indicação: ocorreu overflow
                                ;TFx = 0 -> Flag de indicação: não ocorreu overflow
                                ;IEx = 0 -> Flag de indicação: não houve interrupção externa
                                ;IEx = 1 –> Flag de indicação: houve interrupção externa
                                ;ITx = 0 –> Interrupção externa sensível a nível
                                ;ITx = 1 –> Interrupção externa sensível à borda 
 
main:                           ;loop infinito
        setb    P_SERVO         ;seta a "porta do servo"
        acall   delay1500us     ;chama subrotina de 1,5ms
        clr     P_SERVO         ;limpa a "porta do servo"
        acall   delay20ms       ;chama subrotina de 20ms
        ajmp    main            ;desvia para "main"
 
 
; --- Sub Rotinas ---
delay20ms:                      ;sub rotina para o tempo de 20ms

                                ; 2 ciclos da instrução acall
        mov     R1,#32h         ; 1 ciclo | move 50d para R1

aux1:
        mov     R0,#32h         ; 1 x 50 | move 50d para R0

aux2:
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        nop                     ; 1 x 50 x 50 | no operation
        
        djnz    R0,aux2         ; 2 x 50 x 50 | decrementa R0
                                ;R0 igual a zero?
                                ;não, desvia para aux2       

        djnz    R1,aux1         ; 2 x 50 | decrementa R0
                                ;R1 igual a zero?
                                ;não, desvia para aux1

        ret                     ; 2 ciclos | sim, retorna


delay600us:                     ;sub rotina para o tempo de 600µs

                                ; 2 ciclos da instrução acall
        mov     R2,#200d        ; 1 ciclo | move 200 para R2

aux3:
        nop                     ; 1 x 200 | no operation
        
        djnz    R2,aux3         ; 2 x 200 | decrementa R2
                                ; R2 igual a zero?
                                ;não, desvia para aux3

        ret                     ; 2 ciclos | sim, retorna


delay1500us:                    ;sub rotina para o tempo de 1500µs

                                ; 2 ciclos da instrução acall
        mov     R3,#250d        ; 1 ciclo | move 250 para R3

aux4:
        nop                     ; 1 x 250 | no operation
        nop                     ; 1 x 250 | no operation
        nop                     ; 1 x 250 | no operation
        nop                     ; 1 x 250 | no operation

        djnz    R3,aux4         ; 2 x 250 | decrementa R3
                                ; R3 igual a zero?
                                ;não, desvia para aux4

        ret                     ; 2 ciclos | sim, retorna


        end                     ;Final do programa
         
 