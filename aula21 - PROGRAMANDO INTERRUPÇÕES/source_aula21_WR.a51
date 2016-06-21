;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 21 - Programando Interrupções 
;
; Deseja-se programar as interrupções para o microcontrolador AT89S51 da seguinte forma:
;
; - INT1 seja em máxima prioridade, sensível a nível
; - TIMER1 seja em segunda prioridade
; - INT0 seja em terceira prioridade, sensível à borda
; - Serial e TIMER0 desabilitados         
;
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Outubro de 2015
;

; --- Vetor da RESET (Externa - RST) ---
        org     0000h           ;origem no endereço 0000h de memória
        ajmp    inicio          ;desvia das interrupções

; --- Rotina de Interrupção INT0 (Externa - P3.2) ---
        org     0003h           ;endereço da interrupção do INT0
        reti                    ;retorna da interrupção

; --- Rotina de Interrupção INT1 (Externa - P3.3) ---
        org     0013h           ;endereço da interrupção do INT1
        reti                    ;retorna da interrupção

; --- Rotina de Interrupção do TIMER0 (Interna - Periférico) ---
;       org     000Bh           ;endereço da interrupção do TIMER0
;       reti                    ;retorna da interrupção

; --- Rotina de Interrupção do TIMER1 (Interna - Periférico) ---
        org     001Bh           ;endereço da interrupção do TIMER1
        reti                    ;retorna da interrupção

; --- Rotina de Interrupção do SERIAL (Interna - Periférico) ---
;       org     0023h           ;endereço da interrupção da SERIAL
;       reti                    ;retorna da interrupção

; --- Final das Rotinas de Interrupção ---


; --- Configurações Iniciais ---
inicio:

        mov     a,#10001101b    ;move a constante 10001101b para acc
        mov     IE,a            ;Habilita todas as interrupções, habilita INT0, INT1 e TIMER1
                                ;IE - Interrupt Enable
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  1   1   0   1
                                
        mov     a,#00001100b    ;move a constante 00001100b para acc
        mov     IP,a            ;TIMER1 e INT1 como alta prioridade, INT0 como baixa prioridade
                                ;IP - Interrupt Priority
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  1   1   0   0

        mov     a,#00000001b    ;move a constante 00000001b para acc
        mov     TCON,a          ;Config INT1 como sensível a nível, INT0 como sensível à borda
                                ;TCON - Timer Control
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   0   0   0   0   0   0   1 

        end                     ;Final do programa