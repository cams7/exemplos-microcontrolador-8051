;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 30 - Programar o Timer0, no Modo 2 
;
; Deseja-se programar o serviço de interrupção do Timer0 para o microcontrolador AT89S51:
;
; - Timer no modo 2 (contador de 8 bits com auto-reload);
; - Timer0 com alta prioridade de interrupção;
; - Configurar o estouro de T0 para ocorrer a cada 60ms
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Dezembro de 2015
;
 
; --- Vetor de RESET (Externa - RST) ---
        org             0000h                   ;Origem no endereço 00h de memória
        ajmp            main                    ;Desvia das rotinas de interrupção

; --- Rotinas de Interrupção (Interna - Periférico) ---
        org             000Bh                   ;A interrupção do Timer0 aponta para este endereço
        djnz            R7,exit_time0           ;Decrementa R7. R7 igual a zero? Não, desvia para sair da interrupção
        mov             R7,#250d                ;Sim, recarrega R7 com 250d
        djnz            R6,exit_time0           ;Decrementa R6. R6 igual a zero? Não, desvia para sair da interrupção
        mov             R6,#16d                 ;Sim, recarrega R6 com 16d

        cpl             P2.5                    ;Inverte o estado de P2.5

exit_time0:
        reti                                    ;Retorna da interrupção

; --- Programa Principal ---
main:
        mov             R7,#250d                ;Carrega o valor 250d para R7
        mov             R6,#16d                 ;Carrega o valor 16d para R6
        mov             a,#0DFh                 ;Move a constante 11011111b para acc
        mov             P2,a                    ;Configurando P2.5 como saída

        mov             IE,#82h                 ;Habilita a interrupção do Timer0 e a global
                                                ;IE - Interrupt Enable
                                                ;EA .. ES ET1 EX1 ET0 EX0
                                                ;1  00 0  0   0   1   0

        mov             IP,#02h                 ;Configura timer0 com alta prioridade de interrupção
                                                ;IP - Interrupt Priority
                                                ;... PS PT1 PX1 PT0 PX0
                                                ;000 0  0   0   1   0

        mov             TCON,#10h               ;Habilita a contagem do Timer0
                                                ;TCON - Timer Control
                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                ;0   0   0   1   0   0   0   0
                                                
                                                ;TRx = 1 -> Liga a contagem      (x)
                                                ;TRx = 0 -> Desliga a contagem
                                                ;TFx = 1 -> Ocorreu overflow
                                                ;TFx = 0 -> Não ocorreu overflow (x)

        mov             TMOD,#02h               ;Configura o Timer0 para incrementar com ciclo de máquina
                                                ;Configura o Timer0 no modo 2 (8 bits com auto-reload)
                                                ;TMOD – Timer Mode
                                                ;Timer 1        Timer 0
                                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                                ;0    0   0  0  0    0   1  0

                                                ;Modo M1 M0 Definição
                                                ;0 -  0  0  Contador de 32 bits
                                                ;1 -  0  1  Contador de 16 bits  (x)
                                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                                ;3 -  1  1  Time misto
                                                
        mov             TH0,#6d                 ;Inicializa TH0 em 6d (256 - 6 = 250)
        mov             TL0,#6d                 ;Inicializa TL0 em 6d (256 - 6 = 250)                                          

                                                ;2^8(256) - 6 = 250
                                                ;250 * 1e-6 = 0,00025s = 250us
                                                ;1/0,00025 = 4000
                                                ;4000/250(R7) = 16(R6)
 
 
        ajmp            $               ;Aguarda a interrupção... 
 
        end                             ;Final do programa